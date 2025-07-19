//
//  DashboardAdsInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardInfoListBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardAdsInfo : DashboardInfoListBaseModel

@property (nonatomic, assign) int64_t count;
@property (nonatomic, assign) double avgPerUser;
@property (nonatomic, assign) int64_t maxCountByUser;

- (NSArray *)toDashboardInfoList;

@end

NS_ASSUME_NONNULL_END
