//
//  UIViewController+XMContainer.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/5.
//

#import "UIViewController+XMContainer.h"

@implementation UIViewController (XMContainer)

- (void)xm_addChildController:(UIViewController *)viewController
                  layoutViews:(void (^)(UIView *view))layoutViews {
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    if (layoutViews) {
        layoutViews(viewController.view);
    }
    [viewController didMoveToParentViewController:self];
}

- (void)xm_removeFromSuperController {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
