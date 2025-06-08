//
//  XMDashboardSectionsComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/6/4.
//

#import "XMDashboardComponentEventName.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardDecelerateEvent.h"
#import "XMDashboardScrollEvent.h"
#import "XMDashboardSectionsComponent.h"
#import "XMEventBus.h"
#import "XMTransactionInfoSecitonController.h"
#import <IGListKit/IGListKit.h>

@interface XMDashboardSectionsComponent () <IGListAdapterDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic,   weak) XMEventBus *eventBus;

@end

@implementation XMDashboardSectionsComponent

// 子类必须实现，dyld后mach-o装在Class，会执行所有类的+load，父类+load不会传递到子类
+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

- (void)componentDidLoad {
    [super componentDidLoad];

    [self _commonInit];
}

- (void)componentWillAppear {
    [super componentWillAppear];


}

- (void)componentDidAppear {
    [super componentDidAppear];

}

#pragma mark - private

- (void)_commonInit {
    _eventBus = [XMEventBus shared];

    [self.containerView insertSubview:self.collectionView atIndex:0];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];

    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
    self.adapter.scrollViewDelegate = self;
}

- (void)_postEventWithScrollView:(UIScrollView *)scrollView {
    XMDashboardScrollEvent *event = [[XMDashboardScrollEvent alloc] init];
    event.contentOffset = scrollView.contentOffset;
    event.isDragging = scrollView.isDragging;
    [[XMEventBus shared] postOnMainThread:event];
}

- (void)_postDecelerateEventWithScrollView:(UIScrollView *)scrollView decelerate:(BOOL)decelerate {
    XMDashboardDecelerateEvent *event = [[XMDashboardDecelerateEvent alloc] init];
    event.contentOffset = scrollView.contentOffset;
    event.decelerate = decelerate;
    [[XMEventBus shared] postOnMainThread:event];
}

#pragma mark - adapter delegate

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [[XMTransactionInfoSecitonController alloc] init];
}

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return @[@1, @2, @3, @4, @5, @6];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_eventBus postOnMainThread:XMDashboardSectionCollectionViewDidScrollEventName withObject:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_eventBus postOnMainThread:XMDashboardSectionCollectionViewDidEndDraggingEventName withObject:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_eventBus postOnMainThread:XMDashboardSectionCollectionViewDidEndDeceleratingEventName withObject:scrollView];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.backgroundColor = XMWhiteColor;
    }
    return _collectionView;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:self.container];
    }
    return _adapter;
}

#pragma mark - identifier

+ (NSString *)xm_identifier {
    return XMDashboardSectionsComponentIdentifier;
}

@end
