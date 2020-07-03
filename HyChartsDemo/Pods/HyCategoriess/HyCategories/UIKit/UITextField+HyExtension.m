//
//  UITextField+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/8/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UITextField+HyExtension.h"
#import "HyRunTimeMethods.h"
#import <objc/message.h>


@interface HyTextFieldDelegateConfigure() <UITextFieldDelegate>
@property (nonatomic,copy) BOOL (^textFieldShouldBeginEditing)(UITextField *textField);
@property (nonatomic,copy) BOOL (^textFieldShouldEndEditing)(UITextField *textField);
@property (nonatomic,copy) void (^textFieldDidBeginEditing)(UITextField *textField);
@property (nonatomic,copy) void (^textFieldDidEndEditing)(UITextField *textField);
@property (nonatomic,copy) BOOL (^textFieldShouldReturn)(UITextField *textField);
@property (nonatomic,copy) BOOL (^textFieldShouldClear)(UITextField *textField);
@property (nonatomic,copy) BOOL (^textFieldShouldChange)(UITextField *textField, NSRange range, NSString *replacementString);
@end


@implementation HyTextFieldDelegateConfigure

- (HyTextFieldDelegateConfigure *(^)(BOOL (^)(UITextField *)))configTextFieldShouldBeginEditing {
    return ^(BOOL (^block)(UITextField *)){
        self.textFieldShouldBeginEditing = [block copy];
        return self;
    };
}

- (HyTextFieldDelegateConfigure *(^)(BOOL (^)(UITextField *)))configTextFieldShouldEndEditing {
    return ^(BOOL (^block)(UITextField *)){
        self.textFieldShouldEndEditing = [block copy];
        return self;
    };
}

- (HyTextFieldDelegateConfigure *(^)(BOOL (^)(UITextField *)))configTextFieldShouldReturn {
    return ^(BOOL (^block)(UITextField *)){
        self.textFieldShouldReturn = [block copy];
        return self;
    };
}

- (HyTextFieldDelegateConfigure *(^)(void (^)(UITextField *)))configTextFieldDidBeginEditing {
    return ^(void (^block)(UITextField *)){
        self.textFieldDidBeginEditing = [block copy];
        return self;
    };
}

- (HyTextFieldDelegateConfigure *(^)(void (^)(UITextField *)))configTextFieldDidEndEditing {
    return ^(void (^block)(UITextField *)){
        self.textFieldDidEndEditing = [block copy];
        return self;
    };
}

- (HyTextFieldDelegateConfigure *(^)(BOOL (^)(UITextField *)))configTextFieldShouldClear {
    return ^(BOOL (^block)(UITextField *)){
        self.textFieldShouldClear = [block copy];
        return self;
    };
}

- (HyTextFieldDelegateConfigure *(^)(BOOL (^)(UITextField *, NSRange, NSString *)))configTextFieldShouldChange {
    return ^(BOOL (^block)(UITextField *, NSRange, NSString *)){
        self.textFieldShouldChange = [block copy];
        return self;
    };
}

#pragma mark — UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return
    self.textFieldShouldBeginEditing ?
    self.textFieldShouldBeginEditing(textField) : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textFieldDidBeginEditing ?
    self.textFieldDidBeginEditing(textField) : nil;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return
    self.textFieldShouldEndEditing ?
    self.textFieldShouldEndEditing(textField) : YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.textFieldDidEndEditing ?
    self.textFieldDidEndEditing(textField) : nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    return
    self.textFieldShouldChange ?
    self.textFieldShouldChange(textField, range, string) : YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return
    self.textFieldShouldClear ?
    self.textFieldShouldClear(textField) : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return
    self.textFieldShouldReturn ?
    self.textFieldShouldReturn(textField) : YES;
}
@end


@interface UITextField ()
@property (nonatomic,strong) HyTextFieldDelegateConfigure *hy_delegateConfigure;
@end
@implementation UITextField (HyExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hy_swizzleInstanceMethods([self class],@[@"setPlaceholder:",
                                                 @"textRectForBounds:",
                                                 @"editingRectForBounds:"]);
    });
}

+ (instancetype)hy_textFieldWithFrame:(CGRect)frame
                                 font:(UIFont *)font
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                          placeholder:(NSString *)placeholder
                     placeholderColor:(UIColor *)placeholderColor
                             delegate:(id<UITextFieldDelegate>)delegate {
 
    UITextField *textField = [[self alloc] initWithFrame:frame];
    textField.font = font;
    textField.text = text;
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    textField.hy_placeholderColor = placeholderColor;
    textField.delegate = delegate;
    return textField;
}

+ (instancetype)hy_textFieldWithFrame:(CGRect)frame
                                 font:(UIFont *)font
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                          placeholder:(NSString *)placeholder
                     placeholderColor:(UIColor *)placeholderColor
                    delegateConfigure:(void(^)(HyTextFieldDelegateConfigure *))delegateConfigure {
    
    UITextField *textField = [[self alloc] initWithFrame:frame];
    textField.font = font;
    textField.text = text;
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    textField.hy_placeholderColor = placeholderColor;
    textField.hy_delegateConfigure = [[HyTextFieldDelegateConfigure alloc] init];
    !delegateConfigure ?: delegateConfigure(textField.hy_delegateConfigure);
    textField.delegate = textField.hy_delegateConfigure;
    return textField;
}

- (CGRect)hy_textRectForBounds:(CGRect)bounds {
    
    bounds = CGRectMake(bounds.origin.x + self.hy_textInsets.left,
                        bounds.origin.y + self.hy_textInsets.top,
                        bounds.size.width - (self.hy_textInsets.left + self.hy_textInsets.right),
                        bounds.size.height - (self.hy_textInsets.top + self.hy_textInsets.bottom));
    CGRect resultRect = [self hy_textRectForBounds:bounds];
    return resultRect;
}

- (CGRect)hy_editingRectForBounds:(CGRect)bounds {
    
    bounds = CGRectMake(bounds.origin.x + self.hy_textInsets.left,
                        bounds.origin.y + self.hy_textInsets.top,
                        bounds.size.width - (self.hy_textInsets.left + self.hy_textInsets.right),
                        bounds.size.height - (self.hy_textInsets.top + self.hy_textInsets.bottom));
    return [self hy_editingRectForBounds:bounds];
}

- (void)hy_setPlaceholder:(NSString *)placeholder {
    
    [self hy_setPlaceholder:placeholder];
    [self handlePlaceholderColor];
}

- (void)handlePlaceholderColor {
    if (self.hy_placeholderColor && self.placeholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: self.hy_placeholderColor}];
    }
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

- (void)setHy_textInsets:(UIEdgeInsets)hy_textInsets {
    objc_setAssociatedObject(self,
                             @selector(hy_textInsets),
                             [NSValue valueWithUIEdgeInsets:hy_textInsets],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hy_textInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setHy_delegateConfigure:(HyTextFieldDelegateConfigure *)hy_delegateConfigure {
    objc_setAssociatedObject(self,
                             @selector(hy_delegateConfigure),
                             hy_delegateConfigure,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HyTextFieldDelegateConfigure *)hy_delegateConfigure {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_placeholderColor:(UIColor *)hy_placeholderColor {
    
    objc_setAssociatedObject(self,
                             @selector(hy_placeholderColor),
                             hy_placeholderColor,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self handlePlaceholderColor];
}

- (UIColor *)hy_placeholderColor {
    return objc_getAssociatedObject(self, _cmd);
}

@end
