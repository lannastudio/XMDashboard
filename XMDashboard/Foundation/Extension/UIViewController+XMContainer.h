//
//  UIViewController+XMContainer.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XMContainer)

- (void)xm_addChildController:(UIViewController *)viewController layoutViews:(nullable void(^)(UIView *view))layoutViews;
- (void)xm_removeFromSuperController;

@end

NS_ASSUME_NONNULL_END
