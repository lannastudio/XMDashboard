//
//  DashboardSingleInfoSectionController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardInfo.h"
#import "DashboardSingleInfoCollectionViewCell.h"
#import "DashboardSingleInfoDelegate.h"
#import "DashboardSingleInfoSectionController.h"

@interface DashboardSingleInfoSectionController ()

@property (nonatomic, strong) DashboardInfo *info;
@property (nonatomic,   weak) id<SingleInfoSectionControllerDataSource> dashboardDataSource;

@end

@implementation DashboardSingleInfoSectionController

- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets dataSource:(id<SingleInfoSectionControllerDataSource>)dataSource {
    self = [super initWithSectionInsets:sectionInsets];
    if (self) {
        _dashboardDataSource = dataSource;
    }
    return self;
}

- (void)didUpdateToObject:(id)object {
    if ([object conformsToProtocol:@protocol(DashboardSingleInfoDelegate)]) {
        id<DashboardSingleInfoDelegate> info = object;
        _info = info.toDashboardInfo;
    } else {
        _info = nil;
    }
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width; // 容器宽度
    UIEdgeInsets insets = [self inset];
    CGFloat itemWidth = (width - insets.left*2 - insets.right*2)/2;
    return CGSizeMake(itemWidth, itemWidth);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    DashboardSingleInfoCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:DashboardSingleInfoCollectionViewCell.class forSectionController:self atIndex:index];
    [cell updateWithInfo:_info];
    return cell;
}

- (UIEdgeInsets)inset {
    DashboardSingleInfoControllerPosition position = [self.dashboardDataSource isLeftPositionForSection:self.section];
    CGFloat top = self.isFirstSection ? self.sectionInsets.top : 10;
    if (position == DashboardSingleInfoControllerPositionLeft) {
        return UIEdgeInsetsMake(top, 18, 10, 6);
    } else if (position == DashboardSingleInfoControllerPositionRight) {
        return UIEdgeInsetsMake(self.section == 1 ? top : 10, 6, 10, 18);
    }
    return [super inset];
}

@end
