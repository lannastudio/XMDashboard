//
//  DashboardBillInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardInfoListBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardBillInfo : DashboardInfoListBaseModel

@property (nonatomic, assign) CGFloat lastWeekDailyAvgBillCount;
@property (nonatomic, assign) NSInteger maxBillCountByUser;
@property (nonatomic, assign) CGFloat perUserAvgBillCount;

- (NSArray *)toDashboardInfoList;

@end

NS_ASSUME_NONNULL_END
