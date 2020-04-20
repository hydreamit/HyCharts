//
//  UIView+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/11.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIView+HyExtension.h"
#import "HyRunTimeMethods.h"

@implementation UIView (HyExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hy_swizzleInstanceMethodToBlock([self class],
                                        @selector(snapshotViewAfterScreenUpdates:),
                                        ^id(SEL sel, IMP (^impBlock)(void)) {
            
            return ^UIView *(UIView *_self, BOOL afterUpdates) {
                
                if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
                    UIGraphicsBeginImageContext(_self.frame.size);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    [_self.layer renderInContext:context];
                    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                    
                    UIGraphicsEndImageContext();
                    UIView *newView = [[UIView alloc] initWithFrame:_self.frame];
                    newView.layer.contents = (id)image.CGImage;
                    return newView;
                }
                
                return HyObjectImpFuctoin(_self, sel, afterUpdates);
            };
        });

        hy_swizzleInstanceMethodToBlock([self class],
                                        @selector(hitTest:withEvent:),
                                        ^id(SEL sel, IMP (^impBlock)(void)) {
                                            
            return ^UIView *(UIView *_self, CGPoint point, UIEvent *event){
                
                NSMutableArray<UIView *> *allBeyondViews = _self.hy_allBeyondViews;
                __block UIView *responder = nil;
                if (allBeyondViews.count) {
                    [allBeyondViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                        CGPoint hitP = [_self hy_convertPoint:point toView:obj];
                        if ([obj pointInside:hitP withEvent:event]) {
//                            responder = HyObjectMsgSend(obj, sel, hitP, event);
                            responder = obj;
                            *stop = YES;
                        }
                    }];
                } else if (objc_getAssociatedObject(_self, sel_registerName("hy_addResponderForBeyondInsets:"))) {
                    NSValue *value = objc_getAssociatedObject(_self, sel_registerName("hy_addResponderForBeyondInsets:"));
                    UIEdgeInsets insets = [value UIEdgeInsetsValue];
                    CGFloat top = - insets.top;
                    CGFloat bottom = _self.height + insets.bottom;
                    CGFloat left = - insets.left;
                    CGFloat right = _self.width + insets.right;
                    if (point.x >= left && point.x <= right && point.y >= top && point.y <= bottom) {
                        responder = _self;
                    }
                }
                
                if (responder) {
                    return responder;
                } else {
                    IMP imp = impBlock();
                    if (imp != NULL) {
                       return ((UIView *(*)(id, SEL, CGPoint, UIEvent *))imp)(_self, sel, point, event);
                    }
                    return nil;
                }
//                return responder ?: HyObjectImpFuctoin(_self, sel, point, event);
            };
        });
    });
}

- (void)hy_addResponderForBeyondView:(UIView *)view {
    if (![view isKindOfClass:UIView.class]) {
        return;
    }
    NSMutableArray *array = self.hy_allBeyondViews;
    if (![array containsObject:view]) {
        [array addObject:view];
    }
}

- (void)hy_addResponderForBeyondInsets:(UIEdgeInsets)insets {
    objc_setAssociatedObject(self, _cmd, [NSValue valueWithUIEdgeInsets:insets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<UIView *> *)hy_allBeyondViews {
    NSMutableArray<UIView *> *beyondViews = objc_getAssociatedObject(self, _cmd);
    if (!beyondViews) {
        beyondViews = @[].mutableCopy;
        objc_setAssociatedObject(self, _cmd, beyondViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return beyondViews;
}

- (BOOL)hy_visible {
    if (!self.superview || self.hidden || self.alpha <= 0.01) {
        return NO;
    }
    return YES;
}

- (UIViewController *)hy_viewController {
    return [self hy_controllerWithClass:UIViewController.class];
}

- (UINavigationController *)hy_navigationController {
    return [self hy_controllerWithClass:UINavigationController.class];
}

- (UITabBarController *)hy_tabBarController {
    return [self hy_controllerWithClass:UITabBarController.class];
}

- (UIImage *)hy_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)hy_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self hy_snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (NSData *)hy_snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)hy_removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (CGPoint)hy_convertPoint:(CGPoint)point toView:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)hy_convertPoint:(CGPoint)point fromView:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)hy_convertRect:(CGRect)rect toView:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)hy_convertRect:(CGRect)rect fromView:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}

- (void)hy_setLayerCornerRadius:(CGFloat)cornerRadius
                     rectCorner:(UIRectCorner)rectCorner {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:rectCorner
                                                     cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = path.CGPath;
    self.layer.mask = shaperLayer;
}

- (void)hy_setLayerShadowWithColor:(UIColor*)color
                            offset:(CGSize)offset
                            radius:(CGFloat)radius
                           opacity:(CGFloat)opacity {
    
    self.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (id)hy_controllerWithClass:(Class)class {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:class]) {
            return next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}


- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)middlePoint {
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
}

- (UIView *(^)(CGFloat left, CGFloat top, CGFloat width, CGFloat heigth))rectValue {
    return ^(CGFloat left, CGFloat top, CGFloat width, CGFloat heigth) {
        self.frame = CGRectMake(left, top, width, heigth);
        return self;
    };
}

- (UIView *(^)(CGFloat value))widthValue {
    return ^(CGFloat value){
        self.width = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))heightValue {
    return ^(CGFloat value){
        self.height = value;
        return self;
    };
}

- (UIView *(^)(CGFloat width, CGFloat height))sizeValue {
    return ^(CGFloat width, CGFloat height) {
        self.size = CGSizeMake(width, height);
        return self;
    };
}

- (UIView *(^)(CGFloat value))leftValue {
    return ^(CGFloat value){
        self.left = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))topValue {
    return ^(CGFloat value){
        self.top = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))rightValue {
    return ^(CGFloat value){
        self.right = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))bottomValue {
    return ^(CGFloat value){
        self.bottom = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))centerXValue {
    return ^(CGFloat value){
        self.centerX = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))centerYValue {
    return ^(CGFloat value){
        self.centerY = value;
        return self;
    };
}

- (UIView *(^)(CGFloat left, CGFloat top))originValue {
    return ^(CGFloat left, CGFloat top) {
        self.origin = CGPointMake(left, top);
        return self;
    };
}

- (UIView *(^)(UIView *value))widthIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.width = value.width;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))heightIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.height = value.height;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))sizeIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.size = value.size;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))leftIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.left = value.left;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))topIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.top = value.top;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))rightIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.right = value.right;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))bottomIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.bottom = value.bottom;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))centerXIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.centerX = value.centerX;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))centerYIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.centerY = value.centerY;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))originIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.origin = value.origin;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))containTo {
    return ^(UIView *value){
        if (value) {
            self.frame = value.bounds;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))centerTo {
    return ^(UIView *value){
        if (value) {
            self.centerX = value.width / 2;
            self.centerY = value.height / 2;
        }
        return self;
    };
}

- (CGFloat)scaleX {
    return self.transform.a;
}

- (CGFloat)scaleY {
    return self.transform.d;
}

- (CGFloat)translationX {
    return self.transform.tx;
}

- (CGFloat)translationY {
    return self.transform.ty;
}

@end
