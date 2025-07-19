//
//  DashboardUserInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardInfoListBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardUserInfo : DashboardInfoListBaseModel

@property (nonatomic, assign) int64_t userCount;
@property (nonatomic, assign) int64_t eventLogUserCount;
@property (nonatomic,   copy) NSDictionary *versionMap;

- (NSArray *)toDashboardInfoList;

@end

NS_ASSUME_NONNULL_END
