//
//  UIFont+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIFont+HyExtension.h"
#import "NSObject+HyExtension.h"
#import <CoreText/CoreText.h>


@implementation UIFont (HyExtension)

- (BOOL)hy_isBold {
    [self respondsToSelector:@selector(fontDescriptor)];
    if (!Hy_RespondsToSel(self, @selector(fontDescriptor))) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
}

- (BOOL)hy_isItalic {
    if (!Hy_RespondsToSel(self, @selector(fontDescriptor))) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
}

- (BOOL)hy_isMonoSpace {
    if (!Hy_RespondsToSel(self, @selector(fontDescriptor))) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitMonoSpace) > 0;
}

- (BOOL)hy_isColorGlyphs {
    if (!Hy_RespondsToSel(self, @selector(fontDescriptor))) return NO;
    return (CTFontGetSymbolicTraits((__bridge CTFontRef)self) & kCTFontTraitColorGlyphs) != 0;
}

- (CGFloat)hy_fontWeight {
    NSDictionary *dict = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    return [dict[UIFontWidthTrait] floatValue];
}

- (UIFont *)hy_fontToBold {
    if (!Hy_RespondsToSel(self, @selector(fontDescriptor))) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:self.pointSize];
}

- (UIFont *)hy_fontToItalic {
    if (!Hy_RespondsToSel(self, @selector(fontDescriptor))) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)hy_fontToBoldItalic {
    if (!Hy_RespondsToSel(self, @selector(fontDescriptor))) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)hy_fontToNormal {
    if (!Hy_RespondsToSel(self, @selector(fontDescriptor))) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:0] size:self.pointSize];
}

@end
