//
//  DashboardTopContainerComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardComponentConstants.h"
#import "DashboardScrollWrapper.h"
#import "DashboardTopContainerComponent.h"
#import "TagSelectionComponent.h"
#import "XMDashboardComponentFactory.h"
#import "XMEventBus.h"

@interface DashboardTopContainerComponent ()

@property (nonatomic, strong) UIVisualEffectView *topContainerView;
@property (nonatomic, strong) UILabel *appNameLabel;

@end

@implementation DashboardTopContainerComponent

- (void)componentDidLoad {
    [super componentDidLoad];

    [self _commonInit];
    [self _registerEvents];
}

#pragma mark - private

- (void)_commonInit {
    [self.context.view addSubview:self.topContainerView];
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.context.view);
        make.height.equalTo(@145);
    }];

    if (self.tagComponentView) {
        [self.topContainerView.contentView addSubview:self.tagComponentView];
        [self.tagComponentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.topContainerView);
            make.height.equalTo(@45);
        }];
    }

    [self.topContainerView.contentView addSubview:self.appNameLabel];
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topContainerView);
        if (self.tagComponentView) {
            make.bottom.equalTo(self.tagComponentView.mas_top).offset(-5);
        } else {
            make.bottom.equalTo(self.topContainerView).offset(-5);
        }
    }];
}

- (void)_registerEvents {
    [self.context.dashboardEventBus subscribeEventName:DashboardCollectionViewDidScrollEventName
                                                target:self
                                               handler:^(DashboardScrollWrapper *wrapper) {
        BOOL shouldHideTopContainerView = wrapper.scrollView.contentOffset.y > 100;
        if (shouldHideTopContainerView && self.topContainerView.alpha == 0) {
            return;
        }
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (shouldHideTopContainerView) {
            transform = CGAffineTransformMakeTranslation(0, -self.topContainerView.height);
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.topContainerView.transform = transform;
            self.topContainerView.alpha = shouldHideTopContainerView ? 0 : 1;
        } completion:nil];
    }];
}

#pragma mark - getter

- (UIVisualEffectView *)topContainerView {
    if (!_topContainerView) {
        _topContainerView = [[UIVisualEffectView alloc] init];
        _topContainerView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return _topContainerView;
}

- (UILabel *)appNameLabel {
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc] init];
        _appNameLabel.text = @"寻梦记账看板";
        _appNameLabel.textColor = XMRGBColor(33, 33, 33);
        _appNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }
    return _appNameLabel;
}

- (UIView *)componentView {
    return self.topContainerView;
}

- (UIView *)tagComponentView {
    id<XMDashboardComponent> component = [self.context componentWithClass:TagSelectionComponent.class];
    if ([component respondsToSelector:@selector(componentView)]) {
        return [component componentView];
    }
    return nil;
}

@end

@implementation DashboardTopContainerComponent (ComponentDelegate)

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

+ (NSString *)xm_identifier {
    return NSStringFromClass(self);
}

@end
