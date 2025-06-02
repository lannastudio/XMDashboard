//
//  ViewController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMDashboardViewController.h"
#import "XMDashboardComponentManager.h"
#import "XMDashboardCollectionViewCell.h"

static NSString * const XMDashboardCollectionViewCellId = @"com.lannastudio.dashboard.XMDashboardCollectionViewCellId";

@interface XMDashboardViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) XMDashboardComponentManager *componentManager;

@end

@implementation XMDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 主动分发而不是自动Hook
    // 使用method swizzling风险较高，而且没必要
    [_componentManager triggerEvent:@selector(componentWillAppear)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_componentManager triggerEvent:@selector(componentWillDisappear)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [_componentManager triggerEvent:@selector(componentDidDisappear)];
}

#pragma mark - private

- (void)commonInit {
    [self _setupComponentManager];
    [self _setupSubviews];
}

- (void)_setupComponentManager {
    _componentManager = [[XMDashboardComponentManager alloc] init];

    [_componentManager triggerEvent:@selector(componentDidLoad)];

    WS
    [[_componentManager allComponents] xm_each:^(id<XMDashboardComponent> component) {
        component.container = weak_self;
        component.containerView = weak_self.collectionView;
    }];
}

- (void)_setupSubviews {
    self.view.backgroundColor = XMBlackColor;

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _componentManager.allComponents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMDashboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XMDashboardCollectionViewCellId forIndexPath:indexPath];
    id<XMDashboardComponent> component = [_componentManager.allComponents safe_objectAtIndex:indexPath.item];
    [cell updateWithComponent:component];
    return cell;
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self _collectionViewFlowLayout]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = XMClearColor;
        [_collectionView registerClass:XMDashboardCollectionViewCell.class forCellWithReuseIdentifier:XMDashboardCollectionViewCellId];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)_collectionViewFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    return flowLayout;
}

@end
