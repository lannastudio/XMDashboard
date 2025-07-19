//
//  ViewController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "FPSMonitor.h"
#import "TestObject.h"
#import "XMDashboardComponentManager.h"
#import "XMDashboardViewController.h"
#import "XMDashboardViewModel.h"
#import "XMEventBus.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/runtime.h>

@interface XMDashboardViewController ()

@property (nonatomic, strong) XMDashboardComponentManager *componentManager;
@property (nonatomic, strong) XMDashboardViewModel *viewModel;
@property (nonatomic, strong) XMEventBus *eventBus;
@property (nonatomic, strong) FPSMonitor *fpsMonitor;

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
    [self _componentsWillAppear];
    [self _startFPSMonitor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self _componentsDidAppear];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [self _componentsWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self _componentDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self _componentsWillDisappear];
    [self _stopFPSMonitor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self _componentsDidDisappear];
}

#pragma mark - private

- (void)commonInit {
    _viewModel = [[XMDashboardViewModel alloc] init];
    _eventBus = [[XMEventBus alloc] init];

    [self _setupComponentManager];
    [self _setupSubviews];
    [self _reloadData];

    TestObject *object = [[TestObject alloc] init];
    [object addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld context:nil];


    [object addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld context:nil];

    [object updateAge:1];

    [object removeObserver:self forKeyPath:@"age"];
    [object removeObserver:self forKeyPath:@"age"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"observe");
}

- (void)_setupComponentManager {
    _componentManager = [[XMDashboardComponentManager alloc] init];

    [[_componentManager allComponents] xm_each:^(id<XMDashboardComponent> component) {
        component.context = self;
    }];
}

- (void)_setupSubviews {
    self.view.backgroundColor = XMRGBColor(245, 245, 245);
}

- (void)_reloadData {
    WS
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.viewModel requestWithCompletion:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
    }];
}

- (void)_startFPSMonitor {
    _fpsMonitor = [[FPSMonitor alloc] init];
    [_fpsMonitor xm_start];
}

- (void)_stopFPSMonitor {
    [_fpsMonitor xm_stop];
}

- (void)_componentsDidLoad {
    [_componentManager triggerEvent:@selector(componentDidLoad)];
}

- (void)_componentsWillAppear {
    [_componentManager triggerEvent:@selector(componentWillAppear)];
}

- (void)_componentsWillLayoutSubviews {
    [_componentManager triggerEvent:@selector(componentWillLayoutSubviews)];
}

- (void)_componentsDidAppear {
    [_componentManager triggerEvent:@selector(componentDidAppear)];
}

- (void)_componentDidLayoutSubviews {
    [_componentManager triggerEvent:@selector(componentDidLayoutSubviews)];
}

- (void)_componentsWillDisappear {
    [_componentManager triggerEvent:@selector(componentWillDisappear)];
}

- (void)_componentsDidDisappear {
    [_componentManager triggerEvent:@selector(componentDidDisappear)];
}

@end

@implementation XMDashboardViewController (Context)

- (XMDashboardViewModel *)dashboardViewModel {
    return _viewModel;
}

- (id<XMDashboardComponent>)componentWithClass:(Class)componentClass {
    return [_componentManager componentWithClass:componentClass];
}

- (XMEventBus *)dashboardEventBus {
    return _eventBus;
}

- (void)reloadData {
    [self _reloadData];
}

@end
