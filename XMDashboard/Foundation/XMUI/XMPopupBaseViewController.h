//
//  XMPopupBaseViewController.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMPopupBaseViewController : UIViewController

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGesture;

- (UIScrollView *)xm_scrollView;
- (UIView *)containerView;
- (UIView *)xm_backgroundView;
- (UIView *)slideBarView;
- (void)appearWithAnimation;
- (void)disappearWithAnimation;

@end

@interface XMPopupBaseViewController (XMShow)

+ (instancetype)showWithContainer:(UIViewController *)container;

@end

NS_ASSUME_NONNULL_END
