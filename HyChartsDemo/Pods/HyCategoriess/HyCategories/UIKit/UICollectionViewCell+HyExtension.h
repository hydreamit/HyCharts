//
//  UICollectionViewCell+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/5.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (HyExtension)

@property (nonatomic,strong) id hy_cellData;
@property (nonatomic,strong,readonly) id hy_sectionData;
@property (nonatomic,strong,readonly) id hy_collectionViewData;
@property (nonatomic,strong,readonly) NSIndexPath *hy_indexPath;
@property (nonatomic,strong,readonly) UICollectionView *hy_collectionView;

+ (instancetype)hy_cellWithCollectionView:(UICollectionView *)collectionView
                                indexPath:(NSIndexPath *)indexPath
                                 cellData:(id)cellData;

- (void)hy_cellLoad;
- (void)hy_reloadCellData;

@end

NS_ASSUME_NONNULL_END
