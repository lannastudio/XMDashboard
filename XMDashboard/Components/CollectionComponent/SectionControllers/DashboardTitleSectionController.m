//
//  DashboardTitleSectionController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "DashboardSection.h"
#import "DashboardSectionTitleCollectionViewCell.h"
#import "DashboardTitleSectionController.h"

@interface DashboardTitleSectionController ()

@property (nonatomic, strong) DashboardSection *sectionTitle;

@end

@implementation DashboardTitleSectionController

- (void)didUpdateToObject:(id)object {
    _sectionTitle = object;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width; // 容器宽度
    UIEdgeInsets insets = [self inset];
    CGFloat itemWidth = width - insets.left - insets.right;
    return CGSizeMake(itemWidth, 35);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    DashboardSectionTitleCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:DashboardSectionTitleCollectionViewCell.class forSectionController:self atIndex:index];
    [cell updateWithTitle:_sectionTitle.title];
    return cell;
}

- (UIEdgeInsets)inset {
    if (self.isLastSection) {
        return [super inset];
    }
    CGFloat top = self.isFirstSection ? self.sectionInsets.top : 10;
    return UIEdgeInsetsMake(top, self.sectionInsets.left, 0, self.sectionInsets.right);
}

- (BOOL)canMoveItemAtIndex:(NSInteger)index {
    return NO;
}

@end
