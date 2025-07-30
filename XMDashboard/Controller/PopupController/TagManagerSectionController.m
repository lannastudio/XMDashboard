//
//  TagManagerSectionController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "TagManagerCollectionViewCell.h"
#import "TagManagerSectionController.h"
#import "TagSelectionItem.h"
#import "TagManagerSectionModel.h"

@interface TagManagerSectionController ()

@property (nonatomic, strong) TagManagerSectionModel *model;

@end

@implementation TagManagerSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    NSValue *size = [_model.itemSizes safe_objectAtIndex:index];
    return size.CGSizeValue;
}

- (void)didUpdateToObject:(id)object {
    _model = object;
}

- (NSInteger)numberOfItems {
    return _model.items.count;
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    TagManagerCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:TagManagerCollectionViewCell.class forSectionController:self atIndex:index];
    TagSelectionItem *item = [_model.items safe_objectAtIndex:index];
    [cell updateWithItemName:item.name font:_model.cellFont deleted:_model.deleted];
    WS
    cell.toggleBlock = ^{
        SafeBlock(weak_self.userDidClickCellBlock, [NSIndexPath indexPathForItem:index inSection:weak_self.section]);
    };
    return cell;
}

- (UIEdgeInsets)inset {
    return UIEdgeInsetsMake(10, 12, 10, 12);
}

- (CGFloat)minimumLineSpacing {
    return 6;
}

- (CGFloat)minimumInteritemSpacing {
    return 6;
}

- (BOOL)canMoveItemAtIndex:(NSInteger)index {
    return YES;
}

- (void)moveObjectFromIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex {
    SafeBlock(self.didMoveBlock, sourceIndex, destinationIndex);
}

@end
