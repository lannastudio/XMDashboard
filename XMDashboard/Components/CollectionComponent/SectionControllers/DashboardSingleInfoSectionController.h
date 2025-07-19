//
//  DashboardSingleInfoSectionController.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardBaseSectionController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DashboardSingleInfoControllerPosition) {
    DashboardSingleInfoControllerPositionLeft,
    DashboardSingleInfoControllerPositionRight,
    DashboardSingleInfoControllerPositionUnknown,
};

@protocol SingleInfoSectionControllerDataSource <NSObject>

- (DashboardSingleInfoControllerPosition)isLeftPositionForSection:(NSInteger)section;

@end

@interface DashboardSingleInfoSectionController : DashboardBaseSectionController

- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets dataSource:(id<SingleInfoSectionControllerDataSource>)dataSource;

@end

NS_ASSUME_NONNULL_END
