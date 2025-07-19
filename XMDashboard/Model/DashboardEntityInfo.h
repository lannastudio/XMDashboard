//
//  DashboardEntityInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardInfoListBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardEntityInfo : DashboardInfoListBaseModel

@property (nonatomic, assign) int64_t totalBillCount;
@property (nonatomic, assign) double emptyNotesRatio;
@property (nonatomic, assign) double emptyRemarkRatio;
@property (nonatomic, assign) double emptyLabelIdsRatio;
@property (nonatomic, assign) double billTableSizeMB;

- (NSArray *)toDashboardInfoList;

@end

NS_ASSUME_NONNULL_END
