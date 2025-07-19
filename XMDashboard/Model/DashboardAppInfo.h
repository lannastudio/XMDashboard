//
//  DashboardAppInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardInfoListBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardAppInfo : DashboardInfoListBaseModel

@property (nonatomic, assign) int64_t dau;
@property (nonatomic, assign) int64_t wau;
@property (nonatomic, assign) int64_t mau;
@property (nonatomic, assign) int64_t paidUserCount;
@property (nonatomic, assign) BOOL dataUnreliable;

- (NSArray *)toDashboardInfoList;

@end

NS_ASSUME_NONNULL_END
