//
//  TagSelectionComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardComponentConstants.h"
#import "DashboardTopContainerComponent.h"
#import "TagSectionController.h"
#import "TagSelectionComponent.h"
#import "TagSelectionViewModel.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardViewModel.h"
#import "XMEventBus.h"
#import <IGListKit/IGListKit.h>

@interface TagSelectionComponent () <IGListAdapterDataSource, IGListAdapterMoveDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) TagSelectionViewModel *viewModel;
@property (nonatomic,   copy) NSArray *data;

@end

@implementation TagSelectionComponent

- (void)componentDidLoad {
    [super componentDidLoad];

    [self _commonInit];
}

#pragma mark - private

- (void)_commonInit {
    _viewModel = [[TagSelectionViewModel alloc] init];
    WS
    _viewModel.didReorderItemsBlock = ^{
        [weak_self.context.dashboardViewModel updateWhenItemsDidReorder];
    };

    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
    self.adapter.moveDelegate = self;

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPressGesture:)];
    [self.collectionView addGestureRecognizer:longPressGesture];

    [self _registerEvents];
}

- (void)_handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint location = [recognizer locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
            if (indexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            UIView *view = recognizer.view;
            CGPoint point = [recognizer locationInView:view];
            [self.collectionView updateInteractiveMovementTargetPosition:point];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
        } break;
        default: {
            [self.collectionView cancelInteractiveMovement];
        } break;
    }
}

- (void)_registerEvents {
    WS
    [self.context.dashboardViewModel.orderedOriginalItemsObservable addObserver:self callback:^(id newValue, id oldValue) {
        [weak_self.viewModel updateItemsWithOrderedItems:newValue];
    }];

    [self.viewModel.tagItemsObservable addObserver:self callback:^(id newValue, id oldValue) {
        weak_self.data = newValue;
        [weak_self.adapter performUpdatesAnimated:YES completion:nil];
    }];
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return _data;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    TagSectionController *controller = [[TagSectionController alloc] initWithDataSource:_viewModel];
    WS
    controller.selectItemBlock = ^(TagSelectionItem *item) {
        [weak_self.context.dashboardEventBus postOnMainThread:TagDidSelectEventName withObject:item];
    };
    return controller;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - IGListAdapterMoveDelegate

- (void)listAdapter:(IGListAdapter *)listAdapter moveObject:(id)object from:(NSArray *)previousObjects to:(NSArray *)objects {
    [_viewModel reorderItems:objects];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = XMClearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self.context];
    }
    return _adapter;
}

- (UIView *)_topContainerView {
    id<XMDashboardComponent> component = [self.context componentWithClass:DashboardTopContainerComponent.class];
    if ([component respondsToSelector:@selector(componentView)]) {
        return [component componentView];
    }
    return nil;
}

@end

@implementation TagSelectionComponent (ComponentDelegate)

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

+ (NSString *)xm_identifier {
    return NSStringFromClass(self);
}

- (UIView *)componentView {
    return self.collectionView;
}

@end
