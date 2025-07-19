//
//  XMPopupBaseViewController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/5.
//

#import "UIViewController+XMContainer.h"
#import "XMPopupBaseViewController.h"

@interface XMPopupBaseViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *xm_backgroundView;
@property (nonatomic, strong) UIView *slideBarView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) BOOL panGestureDidChange;
@property (nonatomic, assign) CGPoint panGestureBeganLocation;

@end

@implementation XMPopupBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self popup_commonInit];
}

#pragma mark - public

- (UIScrollView *)xm_scrollView {
    return nil;
}

- (CGFloat)containerViewHeight {
    return 350;
}

- (void)appearWithAnimation {
    self.xm_backgroundView.alpha = 0;
    self.containerView.transform = CGAffineTransformMakeTranslation(0, [self containerViewHeight]);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.xm_backgroundView.alpha = 1;
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)disappearWithAnimation {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.xm_backgroundView.alpha = 0;
        self.containerView.transform = CGAffineTransformMakeTranslation(0, [self containerViewHeight]);
    } completion:^(BOOL finished) {
        [self xm_removeFromSuperController];
    }];
}

#pragma mark - private

- (void)popup_commonInit {
    self.view.backgroundColor = XMClearColor;

    [self.view addSubview:self.xm_backgroundView];
    [self.xm_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@([self containerViewHeight]));
    }];

    [self.containerView addSubview:self.slideBarView];
    [self.slideBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(self.containerView).offset(8);
        make.width.equalTo(@38);
        make.height.equalTo(@5);
    }];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
    [self.containerView addGestureRecognizer:panGesture];
    self.panGesture = panGesture;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearWithAnimation)];
    [self.xm_backgroundView addGestureRecognizer:tapGesture];
}

- (void)_handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.containerView];
    CGFloat velocityY = [recognizer velocityInView:self.containerView].y;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.originY = self.containerView.y;
            self.panGestureBeganLocation = [recognizer locationInView:self.containerView];
        } break;
        case UIGestureRecognizerStateChanged: {
            BOOL gestureShouldChange = (self.xm_scrollView && self.xm_scrollView.contentOffset.y <= 0)
            || velocityY > 0
            || self.panGestureDidChange;
            if (gestureShouldChange) {
                self.xm_scrollView.scrollEnabled = NO;
                self.panGestureDidChange = YES;

                CGFloat offset = 0.f;
                if (translation.y < 0 && self.containerView.y <= self.originY) {
                    offset = translation.y*0.1f;
                } else {
                    offset = translation.y * 0.75f;
                }

                self.containerView.frame = CGRectOffset(self.containerView.frame, 0.f, offset);
                [recognizer setTranslation:CGPointZero inView:self.containerView];
            }
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (self.panGestureDidChange) {
                self.panGestureDidChange = NO;
                self.xm_scrollView.scrollEnabled = YES;
                CGFloat threshold = self.originY + self.containerView.height * 0.3f;
                BOOL shouldClose = (self.containerView.y >= threshold && velocityY > 0.0) || velocityY > 3000;
                if (shouldClose) {
                    [self disappearWithAnimation];
                } else {
                    [UIView animateWithDuration:0.22f animations:^{
                        self.containerView.y = self.originY;
                    }];
                }
            }
        } break;
        default:
            break;
    }
}

#pragma mark - getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 14.5;
        _containerView.backgroundColor = XMWhiteColor;
    }
    return _containerView;
}

- (UIView *)xm_backgroundView {
    if (!_xm_backgroundView) {
        _xm_backgroundView = [[UIView alloc] init];
        _xm_backgroundView.backgroundColor = XMRGBAColor(0, 0, 0, 0.3);
    }
    return _xm_backgroundView;
}

- (UIView *)slideBarView {
    if (!_slideBarView) {
        _slideBarView = [[UIView alloc] init];
        _slideBarView.layer.masksToBounds = YES;
        _slideBarView.layer.cornerRadius = 2.5;
        _slideBarView.backgroundColor = XMRGBColor(192, 192, 192);
    }
    return _slideBarView;
}

@end

@implementation XMPopupBaseViewController (XMShow)

+ (instancetype)showWithContainer:(UIViewController *)container {
    XMPopupBaseViewController *popupController = [[XMPopupBaseViewController alloc] init];
    popupController.container = container;
    WEAK_OBJ_REF(container);
    [container xm_addChildController:popupController layoutViews:^(UIView *view) {
        view.frame = weak_container.view.bounds;
    }];
    [popupController appearWithAnimation];
    return popupController;
}

@end
