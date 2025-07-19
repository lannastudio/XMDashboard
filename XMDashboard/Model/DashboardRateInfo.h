//
//  DashboardRateInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardSingleInfoBaseModel.h"

@class DashboardInfo;

NS_ASSUME_NONNULL_BEGIN

@interface DashboardRateInfo : DashboardSingleInfoBaseModel

@property (nonatomic, assign) int64_t rateCount;

- (DashboardInfo *)toDashboardInfo;

@end

NS_ASSUME_NONNULL_END
