//
//  UITextView+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/8/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HyTextViewDelegateConfigure : NSObject
- (instancetype)configTextViewShouldBeginEditing:(BOOL (^)(UITextView *textView))block;
- (instancetype)configTextViewShouldEndEditing:(BOOL (^)(UITextView *textView))block;
- (instancetype)configTextViewDidBeginEditing:(void (^)(UITextView *textView))block;
- (instancetype)configTextViewDidEndEditing:(void (^)(UITextView *textView))block;
- (instancetype)configTextViewDidChange:(void (^)(UITextView *textView))block;
- (instancetype)configTextViewDidChangeSelection:(void (^)(UITextView *textView))block;
- (instancetype)configTextViewShouldChangeTextInRange:(BOOL (^)(UITextView *textView, NSRange range, NSString *text))block;
@end



@interface UITextView (HyExtension)


+ (instancetype)hy_textFieldWithFrame:(CGRect)frame
                                 font:(UIFont *)font
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                             delegate:(id<UITextViewDelegate>)delegate;


+ (instancetype)hy_textFieldWithFrame:(CGRect)frame
                                 font:(UIFont *)font
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                    delegateConfigure:(void(^)(HyTextViewDelegateConfigure *configure))delegateConfigure;



- (NSRange)hy_selectedRange;
- (void)hy_selecteTextWithRange:(NSRange)range;
- (void)hy_selectAllText;


- (void)hy_insertOrReplaceEdittingText:(NSString *)text;
- (void)hy_setTextKeepingSelectedRange:(NSString *)text;
- (void)hy_setAttributedTextKeepingSelectedRange:(NSAttributedString *)attributedText;
- (void)hy_scrollToTextVisibleAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
