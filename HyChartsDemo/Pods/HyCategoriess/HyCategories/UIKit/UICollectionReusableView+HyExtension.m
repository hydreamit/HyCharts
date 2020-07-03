//
//  UICollectionReusableView+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/5.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UICollectionReusableView+HyExtension.h"
#import "UICollectionView+HyExtension.h"
#import "HyRunTimeMethods.h"


@interface UICollectionReusableView ()
@property (nonatomic, assign) NSInteger hy_section;
@property (nonatomic, assign) HyCollectionSeactionViewKinds hy_seactionViewKinds;
@end


@implementation UICollectionReusableView (HyExtension)

+ (void)load {
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{

       hy_swizzleInstanceMethodToBlock([self class], @selector(initWithFrame:), ^id(SEL sel, IMP (^impBlock)(void)) {
           return ^UICollectionReusableView *(UICollectionReusableView *_self, CGRect frame){
               _self = HyObjectImpFuctoin(_self, sel, frame);
               [_self hy_headerFooterViewLoad];
               return _self;
           };
       });
       
       hy_swizzleInstanceMethodToBlock([self class], @selector(initWithCoder:), ^id(SEL sel, IMP (^impBlock)(void)) {
           return ^UICollectionReusableView *(UICollectionReusableView *_self, NSCoder *coder) {
               _self = HyObjectImpFuctoin(_self, sel, coder);
               [_self hy_headerFooterViewLoad];
               return _self;
           };
       });
   });
}

+ (instancetype)hy_headerFooterViewWithCollectionView:(UICollectionView *)collectionView
                                            indexPath:(NSIndexPath *)indexPath
                                    seactionViewKinds:(HyCollectionSeactionViewKinds)seactionViewKinds
                                          sectionData:(id)sectionData {
    
    NSString *kinds = seactionViewKinds == HyCollectionSeactionViewKindsHeader ?
    UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter;
    UICollectionReusableView *headerFooterView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kinds
                                       withReuseIdentifier:NSStringFromClass(self)
                                              forIndexPath:indexPath];
    headerFooterView.hy_seactionViewKinds = seactionViewKinds;
    headerFooterView.hy_section = indexPath.section;
    headerFooterView.hy_sectionData = sectionData;
    return headerFooterView;
}

- (void)hy_headerFooterViewLoad {}
- (void)hy_reloadHeaderFooterViewData {}

- (id)hy_collectionViewData {
    if (self.hy_collectionView) {
        return self.hy_collectionView.hy_collectionViewData;
    }
    return nil;
}

- (UICollectionView *)hy_collectionView {
    if (!self.superview) {
        return nil;
    }
    UICollectionView *collectionView = ((UICollectionView *)self.superview);
    if ([collectionView isKindOfClass:UICollectionView.class]) {
        return collectionView;
    }
    return nil;
}

- (void)setHy_section:(NSInteger)hy_section {
    objc_setAssociatedObject(self,
                             @selector(hy_section),
                             @(hy_section),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)hy_section {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setHy_seactionViewKinds:(HyCollectionSeactionViewKinds)hy_seactionViewKinds {
    objc_setAssociatedObject(self,
                             @selector(hy_seactionViewKinds),
                             @(hy_seactionViewKinds),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HyCollectionSeactionViewKinds)hy_seactionViewKinds {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setHy_sectionData:(id)hy_sectionData {
    objc_setAssociatedObject(self,
                             @selector(hy_sectionData),
                             hy_sectionData,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)hy_sectionData {
    return objc_getAssociatedObject(self, _cmd);
}

@end
