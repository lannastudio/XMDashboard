//
//  DashboardCollectionComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardBaseSectionController.h"
#import "DashboardCellAnimationDelegate.h"
#import "DashboardCollectionComponent.h"
#import "DashboardComponentConstants.h"
#import "DashboardInfoListDelegate.h"
#import "DashboardInfosSectionController.h"
#import "DashboardModel.h"
#import "DashboardScrollWrapper.h"
#import "DashboardSingleInfoDelegate.h"
#import "DashboardSingleInfoSectionController.h"
#import "DashboardTitleSectionController.h"
#import "DashboardTopContainerComponent.h"
#import "TagSelectionItem.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardViewModel.h"
#import "XMEventBus.h"
#import <IGListKit/IGListKit.h>

@interface DashboardCollectionComponent () <IGListAdapterDataSource, UIScrollViewDelegate, SingleInfoSectionControllerDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic,   weak) NSArray *dashboardModelList;
@property (nonatomic, assign) CGFloat topContainerHeight;
@property (nonatomic, assign) NSInteger selectedSectionRecently;

@end

@implementation DashboardCollectionComponent

- (void)componentDidLoad {
    [super componentDidLoad];

    [self _commonInit];
}

- (void)componentDidLayoutSubviews {
    [super componentDidLayoutSubviews];

    self.collectionView.frame = self.context.view.bounds;
}

#pragma mark - private

- (void)_commonInit {
    [self.context.view insertSubview:self.collectionView atIndex:0];
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
    self.adapter.scrollViewDelegate = self;

    [self _registerEvents];
}

- (void)_registerEvents {
    WS
    [self.context.dashboardViewModel.dashboardInfoListObservable addObserver:self
                                                                    callback:^(id newValue, id oldValue) {
        weak_self.dashboardModelList = newValue;
        [weak_self.adapter performUpdatesAnimated:YES completion:nil];
    }];

    [self.context.dashboardEventBus subscribeEventName:TagDidSelectEventName
                                                target:self
                                               handler:^(id object) {
        if ([object isKindOfClass:TagSelectionItem.class]) {
            TagSelectionItem *item = (TagSelectionItem *)object;
            [weak_self _scrollToItem:item];
        }
    }];
}

- (void)_scrollToItem:(TagSelectionItem *)item {
    NSInteger section = NSNotFound;
    for (NSInteger index = 0; index < self.dashboardModelList.count; index++) {
        id model = [self.dashboardModelList safe_objectAtIndex:index];
        Class klass = NSClassFromString(item.modelClassString);
        if ([model isKindOfClass:klass]) {
            section = index; break;
        }
    }
    if (section != NSNotFound) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        self.selectedSectionRecently = section;
    }
}

- (DashboardSingleInfoControllerPosition)isLeftPositionForSection:(NSInteger)section {
    if (section < 0 || section >= _dashboardModelList.count) {
        return DashboardSingleInfoControllerPositionUnknown;
    }
    id object = [_dashboardModelList safe_objectAtIndex:section];

    if (!object || ![object conformsToProtocol:@protocol(DashboardSingleInfoDelegate)]) {
        return DashboardSingleInfoControllerPositionUnknown;
    }

    NSInteger start = section;
    while (start > 0) {
        id prev = [_dashboardModelList safe_objectAtIndex:start-1];
        if (prev && [prev conformsToProtocol:@protocol(DashboardSingleInfoDelegate)]) {
            start -= 1;
        } else {
            break;
        }
    }

    NSInteger end = section;
    while (end + 1 < _dashboardModelList.count) {
        id next = [_dashboardModelList safe_objectAtIndex:end+1];
        if (next && [next conformsToProtocol:@protocol(DashboardSingleInfoDelegate)]) {
            end += 1;
        } else {
            break;
        }
    }

    NSInteger singleCount = end - start + 1;
    NSInteger indexInGroup = (section - start);
    if (singleCount == 1) {
        return DashboardSingleInfoControllerPositionLeft;
    } else {
        if (indexInGroup % 2 == 1) {
            return DashboardSingleInfoControllerPositionRight;
        } else {
            return DashboardSingleInfoControllerPositionLeft;
        }
    }

    return DashboardSingleInfoControllerPositionUnknown;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self _showAnimationWhenSelectSection];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    DashboardScrollWrapper *wrapper = [[DashboardScrollWrapper alloc] init];
    wrapper.scrollView = scrollView;
    [self.context.dashboardEventBus post:DashboardCollectionViewDidScrollEventName withObject:wrapper];
}

- (void)_showAnimationWhenSelectSection {
    if (_selectedSectionRecently != NSNotFound) {
        NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visibleIndexPaths) {
            if (indexPath.section == _selectedSectionRecently) {
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                if ([cell conformsToProtocol:@protocol(DashboardCellAnimationDelegate)]) {
                    [(id<DashboardCellAnimationDelegate>)cell showAppearAnimation];
                }
            }
        }
    }
}

#pragma mark - IGListAdapterDelegate

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return CollectionUtils.isNotEmpty(_dashboardModelList) ? _dashboardModelList : @[];
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.topContainerHeight+12, 18, 10, 18);
    if ([object conformsToProtocol:@protocol(DashboardSingleInfoDelegate)]) {
        return [[DashboardSingleInfoSectionController alloc] initWithSectionInsets:insets dataSource:self];
    } else if ([object conformsToProtocol:@protocol(DashboardInfoListDelegate)]) {
        return [[DashboardInfosSectionController alloc] initWithSectionInsets:insets];
    } else {
        return [[DashboardTitleSectionController alloc] initWithSectionInsets:insets];
    }
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[IGListCollectionViewLayout alloc] initWithStickyHeaders:NO topContentInset:0 stretchToEdge:NO]];
        _collectionView.backgroundColor = XMClearColor;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self.context];
    }
    return _adapter;
}

- (CGFloat)topContainerHeight {
    if (_topContainerHeight == 0) {
        id<XMDashboardComponent> topContaierComponent = [self.context componentWithClass:DashboardTopContainerComponent.class];
        if ([topContaierComponent respondsToSelector:@selector(componentView)]) {
            _topContainerHeight = [topContaierComponent componentView].height;
        }
    }
    return _topContainerHeight;
}

@end

@implementation DashboardCollectionComponent (ComponentDelegate)

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

+ (NSString *)xm_identifier {
    return NSStringFromClass(self);
}

@end
