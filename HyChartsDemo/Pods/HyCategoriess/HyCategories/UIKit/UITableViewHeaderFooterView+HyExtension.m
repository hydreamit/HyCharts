//
//  UITableViewHeaderFooterView+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UITableViewHeaderFooterView+HyExtension.h"
#import "UITableView+HyExtension.h"
#import "HyRunTimeMethods.h"


@interface UITableViewHeaderFooterView ()
@property (nonatomic, assign) NSInteger hy_section;
@property (nonatomic, assign) HyTableSeactionViewKinds hy_seactionViewKinds;
@end


@implementation UITableViewHeaderFooterView (HyExtension)

+ (void)load {
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{

       hy_swizzleInstanceMethodToBlock([self class], @selector(initWithReuseIdentifier:), ^id(SEL sel, IMP (^impBlock)(void)) {
           return ^UITableViewHeaderFooterView *(UITableViewHeaderFooterView *_self, NSString *reuseIdentifier) {
               _self = HyObjectImpFuctoin(_self, sel, reuseIdentifier);
               [_self hy_headerFooterViewLoad];
               return _self;
           };
       });
       
       hy_swizzleInstanceMethodToBlock([self class], @selector(initWithCoder:), ^id(SEL sel, IMP (^impBlock)(void)) {
           return ^UITableViewHeaderFooterView *(UITableViewHeaderFooterView *_self, NSCoder *coder) {
               _self = HyObjectImpFuctoin(_self, sel, coder);
               [_self hy_headerFooterViewLoad];
               return _self;
           };
       });
   });
}

+ (instancetype)hy_headerFooterViewWithTableView:(UITableView *)tableView
                                         section:(NSInteger)section
                               seactionViewKinds:(HyTableSeactionViewKinds)seactionViewKinds
                                     sectionData:(id)sectionData {
    
    UITableViewHeaderFooterView *headerFooterView =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self)];
    headerFooterView.hy_section = section;
    headerFooterView.hy_seactionViewKinds = seactionViewKinds;
    headerFooterView.hy_sectionData = sectionData;
    return headerFooterView;
}

- (void)hy_headerFooterViewLoad {}
- (void)hy_reloadHeaderFooterViewData {}

- (id)hy_tableViewData {
    if (self.superview) {
        return self.hy_tableView.hy_tableViewData;
    }
    return nil;
}

- (UITableView *)hy_tableView {
    
    if (!self.superview) {
        return nil;
    }
    UITableView *tableView =
    (UITableView *)([NSStringFromClass(self.superview.class) isEqualToString:@"UITableViewWrapperView"] ?
                    self.superview.superview :
                    self.superview);
    
    if ([tableView isKindOfClass:UITableView.class]) {
        return tableView;
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
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        NSUInteger numberOfSection = [self.hy_tableView numberOfSections];
        for (NSInteger i = 0; i < numberOfSection; i++) {
            UITableViewHeaderFooterView *headerView = [self.hy_tableView headerViewForSection:i];
            UITableViewHeaderFooterView *footerView = [self.hy_tableView footerViewForSection:i];
            if (headerView == self || footerView == self) {
                number = @(i);
                break;
            }
        }
    }
    return [number integerValue];
}

- (void)setHy_seactionViewKinds:(HyTableSeactionViewKinds)hy_seactionViewKinds {
    objc_setAssociatedObject(self,
                             @selector(hy_seactionViewKinds),
                             @(hy_seactionViewKinds),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HyTableSeactionViewKinds)hy_seactionViewKinds {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        NSUInteger numberOfSection = [self.hy_tableView numberOfSections];
        for (NSInteger i = 0; i < numberOfSection; i++) {
            UITableViewHeaderFooterView *headerView = [self.hy_tableView headerViewForSection:i];
            if (headerView == self) {
                number = @(HyTableSeactionViewKindsHeader);
                break;
            }
            UITableViewHeaderFooterView *footerView = [self.hy_tableView footerViewForSection:i];
            if (footerView == self) {
                number = @(HyTableSeactionViewKindsFooter);
                break;
            }
        }
    }
   return [number integerValue];
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
