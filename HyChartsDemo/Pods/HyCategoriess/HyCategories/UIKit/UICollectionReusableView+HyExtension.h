//
//  UICollectionReusableView+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/5.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HyCollectionSeactionViewKinds) {
    HyCollectionSeactionViewKindsHeader,
    HyCollectionSeactionViewKindsFooter
};

@interface UICollectionReusableView (HyExtension)

@property (nonatomic,strong) id hy_sectionData;
@property (nonatomic,assign,readonly) NSInteger hy_section;
@property (nonatomic,strong,readonly) id hy_collectionViewData;
@property (nonatomic,strong,readonly) UICollectionView *hy_collectionView;
@property (nonatomic,assign,readonly) HyCollectionSeactionViewKinds hy_seactionViewKinds;

+ (instancetype)hy_headerFooterViewWithCollectionView:(UICollectionView *)collectionView
                                            indexPath:(NSIndexPath *)indexPath
                                    seactionViewKinds:(HyCollectionSeactionViewKinds)seactionViewKinds
                                          sectionData:(id)sectionData;
- (void)hy_headerFooterViewLoad;
- (void)hy_reloadHeaderFooterViewData;

@end

NS_ASSUME_NONNULL_END
