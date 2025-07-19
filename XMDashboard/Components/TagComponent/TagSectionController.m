//
//  TagSectionController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "TagCollectionViewCell.h"
#import "TagSectionController.h"
#import "TagSectionControllerDataSource.h"
#import "TagSelectionItem.h"

@interface TagSectionController ()

@property (nonatomic,   weak) id<TagSelectionControllerDataSource> tagDataSource;
@property (nonatomic, strong) TagSelectionItem *item;

@end

@implementation TagSectionController

- (instancetype)initWithDataSource:(id<TagSelectionControllerDataSource>)dataSource {
    self = [super init];
    if (self) {
        _tagDataSource = dataSource;
    }
    return self;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    NSValue *size = [_tagDataSource.textSizes safe_objectAtIndex:self.section];
    return size.CGSizeValue;
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    TagCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:TagCollectionViewCell.class forSectionController:self atIndex:index];
    [cell updateWithItem:_item];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.item = object;
}

- (UIEdgeInsets)inset {
    if (self.isFirstSection) {
        return UIEdgeInsetsMake(0, 12, 0, 5);
    } else if (self.isLastSection) {
        return UIEdgeInsetsMake(0, 5, 0, 12);
    }
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    xm_impactFeedbackOccured();
    SafeBlock(self.selectItemBlock, self.item)
}

- (BOOL)canMoveItemAtIndex:(NSInteger)index {
    return YES;
}

@end
