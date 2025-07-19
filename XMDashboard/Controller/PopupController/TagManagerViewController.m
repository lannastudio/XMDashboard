//
//  TagManagerViewController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "DashboardSection.h"
#import "DashboardSectionManager.h"
#import "DashboardTitleSectionController.h"
#import "NSString+CalculateTextSize.h"
#import "TagManagerSectionController.h"
#import "TagManagerSectionModel.h"
#import "TagManagerViewController.h"
#import "TagSelectionItem.h"
#import <IGListKit/IGListKit.h>

@interface TagManagerViewController () <IGListAdapterDataSource, IGListAdapterMoveDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSArray *blockedItems;
@property (nonatomic, copy) NSArray *objects;
@property (nonatomic, strong) TagManagerSectionModel *sectionModel;
@property (nonatomic, strong) TagManagerSectionModel *blockedSectionModel;

@end

@implementation TagManagerViewController

- (instancetype)initWithItems:(NSArray<id<TagSelectionItemDelegate>> *)items {
    self = [super init];
    if (self) {
        NSArray *blockedItems = [[DashboardSectionManager blockedComponentItems] xm_safe_map:^id (NSString *classString) {
            Class klass = NSClassFromString(classString);
            id object = [[klass alloc] init];
            if ([object conformsToProtocol:@protocol(TagSelectionItemDelegate)]) {
                return [[TagSelectionItem alloc] initWithTagSelectionDelegate:object];
            }
            return nil;
        }];
        NSArray *finalItems = [items xm_safe_map:^id (id<TagSelectionItemDelegate> obj) {
            return [[TagSelectionItem alloc] initWithTagSelectionDelegate:obj];
        }];

        _items = [finalItems xm_select:^BOOL(TagSelectionItem *obj) {
            for (TagSelectionItem *blockedItem in blockedItems) {
                if ([blockedItem.modelClassString isEqualToString:obj.modelClassString]) {
                    return NO;
                }
            }
            return YES;
        }];
        _blockedItems = [blockedItems copy];

        NSArray *itemSizes = [_items xm_map:^id (TagSelectionItem *item) {
            return [self _sizeWithItem:item];
        }];
        NSArray *blockedItemSizes = [_blockedItems xm_map:^id (TagSelectionItem *item) {
            return [self _sizeWithItem:item];
        }];
        TagManagerSectionModel *sectionModel = [self _modelWithSizes:itemSizes items:_items deleted:NO];
        TagManagerSectionModel *blockedModels = [self _modelWithSizes:blockedItemSizes items:_blockedItems deleted:YES];
        NSMutableArray *objects = [NSMutableArray arrayWithObject:[DashboardSection sectionWithTitle:@"正在展示"]];
        [objects addObject:sectionModel];
        [objects addObject:[DashboardSection sectionWithTitle:@"已移除"]];
        [objects addObject:blockedModels];
        _objects = objects;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _commonInit];
}

#pragma mark - private

- (void)_commonInit {
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
    self.adapter.moveDelegate = self;

    [self.containerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPressGesture:)];
    [self.collectionView addGestureRecognizer:longPressGesture];
}

- (void)_handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint location = [gesture locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
            if (indexPath && indexPath.section != 0 && indexPath.section != 2) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            UIView *view = gesture.view;
            CGPoint position = [gesture locationInView:view];
            [self.collectionView updateInteractiveMovementTargetPosition:position];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
        } break;
        default: {
            [self.collectionView cancelInteractiveMovement];
        } break;
    }
}

- (NSValue *)_sizeWithItem:(TagSelectionItem *)item {
    CGSize size = [item.name calculateWithFont:[self _cellFont]];
    CGFloat horizontalPadding = 23;
    CGFloat verticalPadding = 12;
    CGFloat imageSize = size.height;
    CGSize result = CGSizeMake(size.width+horizontalPadding+imageSize, size.height+verticalPadding);
    return [NSValue valueWithCGSize:result];
}

- (TagManagerSectionModel *)_modelWithSizes:(NSArray *)sizes items:(NSArray *)items deleted:(BOOL)deleted {
    TagManagerSectionModel *model = [[TagManagerSectionModel alloc] init];
    model.cellFont = [self _cellFont];
    model.items = items;
    model.itemSizes = sizes;
    model.deleted = deleted;
    return model;
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return _objects;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    if ([object isKindOfClass:TagManagerSectionModel.class]) {
        return [[TagManagerSectionController alloc] init];
    }
    return [[DashboardTitleSectionController alloc] initWithSectionInsets:UIEdgeInsetsMake(15, 4, 5, 4)];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - IGListAdapterMoveDelegate

- (void)listAdapter:(IGListAdapter *)listAdapter moveObject:(id)object from:(NSArray *)previousObjects to:(NSArray *)objects {
    NSLog(@"%@", objects);
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.backgroundColor = XMClearColor;
    }
    return _collectionView;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self];
    }
    return _adapter;
}

- (UIFont *)_cellFont {
    return [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
}


@end
