//
//  ViewController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMDashboardComponentManager.h"
#import "XMDashboardViewController.h"
#import "XMDashboardViewModel.h"

static NSString * const XMDashboardCollectionViewCellId = @"com.lannastudio.dashboard.XMDashboardCollectionViewCellId";

@interface XMDashboardViewController ()

@property (nonatomic, strong) XMDashboardComponentManager *componentManager;
@property (nonatomic, strong) XMDashboardViewModel *viewModel;

@end

@implementation XMDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self commonInit];
    [self _componentsDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 主动分发而不是自动Hook
    // 使用method swizzling风险较高，而且没必要
    [self _componentsWillAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self _componentsDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self _componentsWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self _componentsDidDisappear];
}

#pragma mark - private

- (void)commonInit {
    _viewModel = [[XMDashboardViewModel alloc] init];

    [self _setupComponentManager];
    [self _setupSubviews];
}

- (void)_setupComponentManager {
    _componentManager = [[XMDashboardComponentManager alloc] init];

    WS
    [[_componentManager allComponents] xm_each:^(id<XMDashboardComponent> component) {
        component.container = weak_self;
        component.containerView = weak_self.view;
        component.dashboardViewModel = weak_self.viewModel;
    }];
}

- (void)_setupSubviews {
    self.view.backgroundColor = XMWhiteColor;
}

- (void)_setupObservers {
    WS
    [self.viewModel.selectedDate addObserver:self callback:^(NSDate *newValue, NSDate * oldValue) {

    }];
}

- (void)reloadData {
    WS
    [self.viewModel requestWithCompletion:^(NSError *error) {
        // end loading animation
        [weak_self.componentManager reloadAllComponents];
    }];
}

- (void)_componentsDidLoad {
    [_componentManager triggerEvent:@selector(componentDidLoad)];
}

- (void)_componentsWillAppear {
    [_componentManager triggerEvent:@selector(componentWillAppear)];
}

- (void)_componentsDidAppear {
    [_componentManager triggerEvent:@selector(componentDidAppear)];
}

- (void)_componentsWillDisappear {
    [_componentManager triggerEvent:@selector(componentWillDisappear)];
}

- (void)_componentsDidDisappear {
    [_componentManager triggerEvent:@selector(componentDidDisappear)];
}


#pragma mark - getter


@end
