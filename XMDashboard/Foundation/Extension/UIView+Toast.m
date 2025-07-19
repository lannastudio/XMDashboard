//
//  UIView+Toast.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "NSString+CalculateTextSize.h"
#import "UIView+Toast.h"
#import <objc/runtime.h>

@implementation UIView (Toast)

- (void)showToastWithText:(NSString *)text {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    __block UILabel *label = [self _toastLabel];
    label.text = text;

    CGSize size = [text calculateWithMaxSize:CGSizeMake(screenWidth-40, CGFLOAT_MAX)
                                        font:label.font ?: [UIFont systemFontOfSize:17]];

    __block UIVisualEffectView *visualEffectView = [self _toastVisualEffectViewWithSize:size];

    [visualEffectView.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(visualEffectView);
    }];

    [UIView animateWithDuration:0.33f animations:^{
        visualEffectView.transform = CGAffineTransformIdentity;
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.33f animations:^{
            label.alpha = 0.f;
            visualEffectView.effect = nil;
            visualEffectView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15f animations:^{
                visualEffectView.alpha = 0.f;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
                label = nil;
                [visualEffectView removeFromSuperview];
                visualEffectView = nil;
            }];
        }];
    });
}

- (UIVisualEffectView *)_toastVisualEffectViewWithSize:(CGSize)size {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.layer.masksToBounds = YES;
    [self addSubview:visualEffectView];
    visualEffectView.size = CGSizeMake(size.width + 32, size.height + 14);
    visualEffectView.centerX = self.centerX;
    CGFloat topOffset = self.safeAreaInsets.top + 20;
    visualEffectView.top = topOffset;
    visualEffectView.layer.cornerRadius = visualEffectView.height/2;
    visualEffectView.transform = CGAffineTransformMakeTranslation(0.f, -topOffset);
    return visualEffectView;
}

- (UILabel *)_toastLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = XMWhiteColor;
    label.font = [UIFont systemFontOfSize:14.5 weight:UIFontWeightMedium];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = XMClearColor;
    return label;
}


//
//
//+ (void)load {
//    // 确保只 swizzle 一次
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleHitTest];
//    });
//}
//
//
//+ (void)swizzleHitTest {
//    Class class = [self class];
//
//    SEL originalSelector = @selector(hitTest:withEvent:);
//    SEL swizzledSelector = @selector(xm_swizzled_hitTest:withEvent:);
//
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//    BOOL didAddMethod =
//    class_addMethod(class,
//                    originalSelector,
//                    method_getImplementation(swizzledMethod),
//                    method_getTypeEncoding(swizzledMethod));
//
//    if (didAddMethod) {
//        class_replaceMethod(class,
//                            swizzledSelector,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//- (UIView *)xm_swizzled_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"HitTest: %@", self.class);
//    NSLog(@"NextResponder: %@", self.nextResponder.class);
//    return [self xm_swizzled_hitTest:point withEvent:event];
//}

@end
