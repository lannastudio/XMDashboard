//
//  XMDateSelectionComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/19.
//

#import "DashboardComponentConstants.h"
#import "DashboardServiceComponent.h"
#import "DashboardTopContainerComponent.h"
#import "DashboardTopContainerViewStatusWrapper.h"
#import "DateSelectionComponent.h"
#import "NSDate+XMDisplay.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardViewModel.h"
#import "XMEventBus.h"
#import "XMExtensionButton.h"
#import <DateTools/DateTools.h>

@interface DateSelectionComponent ()

@property (nonatomic, strong) XMExtensionButton *dateSelectionButton;

@end

@implementation DateSelectionComponent

- (void)componentDidLoad {
    [super componentDidLoad];

    [self _commonInit];
}

#pragma mark - private

- (void)_commonInit {
    UIView *containerView = self.context.view;
    [containerView addSubview:self.dateSelectionButton];
    [self.dateSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_safeAreaLayoutGuideTop);
        make.right.equalTo(containerView).offset(-20);
    }];

    [self _registerEvents];
}

- (void)_registerEvents {
    WS
    [self.context.dashboardEventBus subscribeEventName:DashboardTopContainerViewWillHideEventName
                                                target:self
                                               handler:^(DashboardTopContainerViewStatusWrapper *object) {
        [UIView animateWithDuration:0.32
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            weak_self.dateSelectionButton.hidden = !object.willHide;
        } completion:nil];
    }];

    [self.context.dashboardViewModel.selectedDateObservable addObserver:self callback:^(NSDate *newValue, id oldValue) {
        [weak_self _updateDate:newValue];
    }];
}

- (void)_updateDate:(NSDate *)date {
    [_dateSelectionButton setTitle:date.xm_toYMString forState:UIControlStateNormal];
}

- (void)_showDateSelectionController:(XMExtensionButton *)sender {
    id<XMDashboardComponent> component = [self.context componentWithClass:DashboardServiceComponent.class];
    DashboardServiceComponent *serviceComponent = XMSAFE_CAST(component, DashboardServiceComponent);
    [serviceComponent showDateSelectionPopupViewController];
}

#pragma mark - getter

- (UIView *)_topContainerView {
    id<XMDashboardComponent> component = [self.context componentWithClass:DashboardTopContainerComponent.class];
    if ([component respondsToSelector:@selector(componentView)]) {
        UIView *view = [component componentView];
        if ([view isKindOfClass:UIVisualEffectView.class]) {
            UIVisualEffectView *topContainer = (UIVisualEffectView *)view;
            return topContainer.contentView;
        }
        return view;
    }
    return nil;
}

- (XMExtensionButton *)dateSelectionButton {
    if (!_dateSelectionButton) {
        _dateSelectionButton = [[XMExtensionButton alloc] init];
        _dateSelectionButton.backgroundColor = XMClearColor;
        _dateSelectionButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        [_dateSelectionButton setTitleColor:XMRGBColor(66, 66, 66) forState:UIControlStateNormal];
        _dateSelectionButton.hidden = YES;
        [self _updateDate:[NSDate date]];
        [_dateSelectionButton addTarget:self action:@selector(_showDateSelectionController:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateSelectionButton;
}

@end


@implementation DateSelectionComponent (ComponentDelegate)

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

+ (NSString *)xm_identifier {
    return NSStringFromClass(self);
}

@end
