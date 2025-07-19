//
//  DashboardInfosSectionController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardInfo.h"
#import "DashboardInfoListDelegate.h"
#import "DashboardInfoRowCollectionViewCell.h"
#import "DashboardInfosSectionController.h"

@interface DashboardInfosSectionController ()

@property (nonatomic, copy) NSArray *dashboardInfoList;

@end

@implementation DashboardInfosSectionController

- (NSInteger)numberOfItems {
    return _dashboardInfoList.count;
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    DashboardInfoRowCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:DashboardInfoRowCollectionViewCell.class forSectionController:self atIndex:index];
    DashboardInfo *info = [_dashboardInfoList safe_objectAtIndex:index];
    DashboardCellPosition position = (index == 0) ? DashboardCellPositionFirst : DashboardCellPositionMiddle;
    if (index == _dashboardInfoList.count - 1) {
        position = DashboardCellPositionLast;
    }
    [cell updateWithInfo:info position:position];
    return cell;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width; // 容器宽度
    UIEdgeInsets insets = [self inset];
    CGFloat itemWidth = width - insets.left - insets.right;
    return CGSizeMake(itemWidth, 55);
}

- (void)didUpdateToObject:(id)object {
    if ([object conformsToProtocol:@protocol(DashboardInfoListDelegate)]) {
        id<DashboardInfoListDelegate> info = object;
        _dashboardInfoList = info.toDashboardInfoList;
    } else {
        _dashboardInfoList = @[];
    }
}

@end
