//
//  UITabBarController+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/13.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (HyExtension)

@property (nonatomic,assign) NSUInteger hy_clickItemFromIndex;
@property (nonatomic,copy,nullable) void(^hy_clickItemBlock)(UITabBarController *_self, NSInteger index, BOOL isRepeat);

- (void)hy_jumpSelectedToIndex:(NSInteger)index
                      animated:(BOOL)animated
                    completion:(void(^)(UIViewController *selectedVc))completion;

- (void)hy_addChildViewController:(UIViewController *)childVc
                            title:(NSString *)title
                            image:(NSString *)image
                    selectedImage:(NSString *)selectedImage
                      imageInsets:(UIEdgeInsets)imageInsets
                    titlePosition:(UIOffset)titlePosition;

@end

NS_ASSUME_NONNULL_END
