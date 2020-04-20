//
//  UITextView+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/8/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UITextView+HyExtension.h"
#import "HyRunTimeMethods.h"

@interface HyTextViewDelegateConfigure () <UITextViewDelegate>
@property (nonatomic,copy) BOOL (^textViewShouldBeginEditing)(UITextView *textView);
@property (nonatomic,copy) BOOL (^textViewShouldEndEditing)(UITextView *textView);
@property (nonatomic,copy) void (^textViewDidBeginEditing)(UITextView *textView);
@property (nonatomic,copy) void (^textViewDidEndEditing)(UITextView *textView);
@property (nonatomic,copy) void (^textViewDidChange)(UITextView *textView);
@property (nonatomic,copy) void (^textViewDidChangeSelection)(UITextView *textView);
@property (nonatomic,copy) BOOL (^textViewShouldChangeTextInRange)(UITextView *textView, NSRange range, NSString *text);
@end
@implementation HyTextViewDelegateConfigure
- (instancetype)configTextViewShouldBeginEditing:(BOOL (^)(UITextView *textView))block {
    self.textViewShouldBeginEditing = [block copy];
    return self;
}
- (instancetype)configTextViewShouldEndEditing:(BOOL (^)(UITextView *textView))block {
    self.textViewShouldEndEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidBeginEditing:(void (^)(UITextView *textView))block {
    self.textViewDidBeginEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidEndEditing:(void (^)(UITextView *textView))block {
    self.textViewDidEndEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidChange:(void (^)(UITextView *textView))block {
    self.textViewDidChange = [block copy];
    return self;
}
- (instancetype)configTextViewDidChangeSelection:(void (^)(UITextView *textView))block {
    self.textViewDidChangeSelection = [block copy];
    return self;
}
- (instancetype)configTextViewShouldChangeTextInRange:(BOOL (^)(UITextView *textView, NSRange range, NSString *text))block {
    self.textViewShouldChangeTextInRange = [block copy];
    return self;
}

#pragma mark — UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return
    !self.textViewShouldBeginEditing ?:
    self.textViewShouldBeginEditing(textView);
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return
    !self.textViewShouldEndEditing ?:
    self.textViewShouldEndEditing(textView);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    !self.textViewDidBeginEditing ?:
    self.textViewDidBeginEditing(textView);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    !self.textViewDidEndEditing ?:
    self.textViewDidEndEditing(textView);
}

- (void)textViewDidChange:(UITextView *)textView {
    !self.textViewDidChange ?:
    self.textViewDidChange(textView);
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    !self.textViewDidChangeSelection ?:
    self.textViewDidChangeSelection(textView);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return
    !self.textViewShouldChangeTextInRange ?:
    self.textViewShouldChangeTextInRange(textView, range, text);
}

@end

@interface UITextView ()
@property (nonatomic,strong) HyTextViewDelegateConfigure *hy_delegateConfigure;
@end

@implementation UITextView (HyExtension)

+ (instancetype)hy_textFieldWithFrame:(CGRect)frame
                                 font:(UIFont *)font
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                             delegate:(id<UITextViewDelegate>)delegate {
    
    UITextView *textView = [[self alloc] initWithFrame:frame];
    textView.font = font;
    textView.text = text;
    textView.textColor = textColor;
    textView.delegate = delegate;
    return textView;
}

+ (instancetype)hy_textFieldWithFrame:(CGRect)frame
                                 font:(UIFont *)font
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                    delegateConfigure:(void(^)(HyTextViewDelegateConfigure *configure))delegateConfigure {
    
    UITextView *textView = [[self alloc] initWithFrame:frame];
    textView.font = font;
    textView.text = text;
    textView.textColor = textColor;
    textView.hy_delegateConfigure = [[HyTextViewDelegateConfigure alloc] init];
    !delegateConfigure ?: delegateConfigure(textView.hy_delegateConfigure);
    textView.delegate = textView.hy_delegateConfigure;
    return textView;
}

- (void)setHy_delegateConfigure:(HyTextViewDelegateConfigure *)hy_delegateConfigure {
    
    objc_setAssociatedObject(self,
                             @selector(hy_delegateConfigure),
                             hy_delegateConfigure,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HyTextViewDelegateConfigure *)hy_delegateConfigure {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSRange)hy_selectedRange {
    
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

- (void)hy_selecteTextWithRange:(NSRange)range {
    
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

- (void)hy_selectAllText {
    
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)hy_insertOrReplaceEdittingText:(NSString *)text {
    
    NSUInteger insertIndex = [self hy_selectedRange].location;
    NSMutableString *mString = [NSMutableString stringWithString:self.text];
    [mString replaceCharactersInRange:self.hy_selectedRange withString:text];
    self.text = mString;
    [self hy_selecteTextWithRange:NSMakeRange(insertIndex + 1, 0)];
}

- (void)hy_setTextKeepingSelectedRange:(NSString *)text {
    
    UITextRange *selectedTextRange = self.selectedTextRange;
    self.text = text;
    self.selectedTextRange = selectedTextRange;
}

- (void)hy_setAttributedTextKeepingSelectedRange:(NSAttributedString *)attributedText {
    
    UITextRange *selectedTextRange = self.selectedTextRange;
    self.attributedText = attributedText;
    self.selectedTextRange = selectedTextRange;
}

- (void)hy_scrollToTextVisibleAnimated:(BOOL)animated {
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    CGFloat contentOffsetY = self.contentOffset.y;
    CGRect caretRect = [self caretRectForPosition:self.selectedTextRange.end];
    if (CGRectGetMinY(caretRect) == self.contentOffset.y + self.textContainerInset.top) {
        return;
    }
    
    if (CGRectGetMinY(caretRect) < self.contentOffset.y + self.textContainerInset.top) {
        contentOffsetY = CGRectGetMinY(caretRect) - self.textContainerInset.top - self.contentInset.top;
    } else if (CGRectGetMaxY(caretRect) > self.contentOffset.y + CGRectGetHeight(self.bounds) - self.textContainerInset.bottom - self.contentInset.bottom) {
        contentOffsetY = CGRectGetMaxY(caretRect) - CGRectGetHeight(self.bounds) + self.textContainerInset.bottom + self.contentInset.bottom;
    } else {
        return;
    }
    
    [self setContentOffset:CGPointMake(self.contentOffset.x, contentOffsetY) animated:animated];
}

@end
