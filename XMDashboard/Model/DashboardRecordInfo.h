//
//  DashboardRecordInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardSingleInfoBaseModel.h"

@class DashboardInfo;

NS_ASSUME_NONNULL_BEGIN

@interface DashboardRecordInfo : DashboardSingleInfoBaseModel

@property (nonatomic, assign) NSTimeInterval avgBillDuration;

- (DashboardInfo *)toDashboardInfo;

@end

NS_ASSUME_NONNULL_END
