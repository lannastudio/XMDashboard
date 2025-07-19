//
//  DashboardPageInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardInfoListBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardPageInfo : DashboardInfoListBaseModel

@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> *pageEnterCountMap;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *pageNameMap;

- (NSArray *)toDashboardInfoList;

@end

NS_ASSUME_NONNULL_END
