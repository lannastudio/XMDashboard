//
//  DashboardBottomBarComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardBottomBarComponent.h"
#import "DashboardServiceComponent.h"
#import "TagManagerViewController.h"
#import "UIView+Toast.h"
#import "UIViewController+XMContainer.h"
#import "XMAnimationButton.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardViewModel.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface DashboardBottomBarComponent ()

@property (nonatomic, strong) XMAnimationButton *reloadButton;
@property (nonatomic, strong) XMAnimationButton *tagSelectionButton;
@property (nonatomic, strong) XMAnimationButton *dateSelectionButton;
@property (nonatomic, strong) UIVisualEffectView *barView;

@property (nonatomic,   copy) NSArray *items;

@end

@implementation DashboardBottomBarComponent

- (void)componentDidLoad {
    [super componentDidLoad];

    [self _commonInit];
}

#pragma mark - private

- (void)_commonInit {
    [self.context.view addSubview:self.barView];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.context.view);
        make.bottom.equalTo(self.context.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        make.width.equalTo(@192);
        make.height.equalTo(@45);
    }];

    [self.barView.contentView addSubview:self.reloadButton];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.barView);
        make.width.height.equalTo(@45);
    }];

    [self.barView.contentView addSubview:self.dateSelectionButton];
    [self.dateSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.barView);
        make.right.equalTo(self.barView).offset(-15);
        make.width.height.equalTo(@45);
    }];

    [self.barView.contentView addSubview:self.tagSelectionButton];
    [self.tagSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.barView);
        make.left.equalTo(self.barView).offset(15);
        make.width.height.equalTo(@45);
    }];

    WS
    [self.context.dashboardViewModel.orderedOriginalItemsObservable addObserver:self callback:^(id newValue, id oldValue) {
        if ([newValue conformsToProtocol:@protocol(NSCopying)]) {
            weak_self.items = [newValue copy];
        }
    }];
}

- (void)_update:(XMAnimationButton *)sender {
    if (self.context.dashboardViewModel.isPerformingUpdate) {
        [self.context.view showToastWithText:@"正在刷新中，请稍后"];
        return;
    }
    [self.context reloadData];
}

- (void)_showTagManagerController:(XMAnimationButton *)sender {
    if (self.context.dashboardViewModel.isPerformingUpdate) {
        [self.context.view showToastWithText:@"正在刷新中，请稍后"];
        return;
    }
    TagManagerViewController *tagManagerController = [[TagManagerViewController alloc] initWithItems:_items];
    WS
    [self.context xm_addChildController:tagManagerController layoutViews:^(UIView *view) {
        view.frame = weak_self.context.view.bounds;
    }];
    tagManagerController.tagsDidChangeBlock = ^{
        [weak_self.context.dashboardViewModel updateWhenItemsDidReorder];
    };
    [tagManagerController appearWithAnimation];
}

- (void)_showDatePickerController:(XMAnimationButton *)sender {
    id<XMDashboardComponent> component = [self.context componentWithClass:DashboardServiceComponent.class];
    DashboardServiceComponent *serviceComponent = XMSAFE_CAST(component, DashboardServiceComponent);
    [serviceComponent showDateSelectionPopupViewController];
}

#pragma mark - getter

- (UIVisualEffectView *)barView {
    if (!_barView) {
        _barView = [[UIVisualEffectView alloc] init];
        _barView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark];
        _barView.layer.masksToBounds = YES;
        _barView.layer.cornerRadius = 22;
    }
    return _barView;
}

- (XMAnimationButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [self _commonButtonWithSystemImageName:@"arrow.clockwise"];
        [_reloadButton addTarget:self action:@selector(_update:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (XMAnimationButton *)tagSelectionButton {
    if (!_tagSelectionButton) {
        _tagSelectionButton = [self _commonButtonWithSystemImageName:@"tag"];
        [_tagSelectionButton addTarget:self action:@selector(_showTagManagerController:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tagSelectionButton;
}

- (XMAnimationButton *)dateSelectionButton {
    if (!_dateSelectionButton) {
        _dateSelectionButton = [self _commonButtonWithSystemImageName:@"calendar"];
        [_dateSelectionButton addTarget:self action:@selector(_showDatePickerController:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateSelectionButton;
}

- (XMAnimationButton *)_commonButtonWithSystemImageName:(NSString *)imageName {
    XMAnimationButton *button = [[XMAnimationButton alloc] init];
    UIImage *image = [[UIImage systemImageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateNormal];
    button.tintColor = XMWhiteColor;
    button.backgroundColor = XMClearColor;
    return button;
}

@end

@implementation DashboardBottomBarComponent (ComponentDelegate)

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

+ (NSString *)xm_identifier {
    return NSStringFromClass(self);
}

@end
