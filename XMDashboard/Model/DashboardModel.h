//
//  DashboardInfoModel.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import <Foundation/Foundation.h>

@class DashboardAdsInfo, DashboardAppInfo, DashboardBillInfo, DashboardEntityInfo;
@class DashboardLoginOutInfo, DashboardPageInfo, DashboardRateInfo, DashboardRecordInfo;
@class DashboardUserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface DashboardModel : NSObject

@property (nonatomic, strong) DashboardAppInfo *appInfo;
@property (nonatomic, strong) DashboardUserInfo *userInfo;
@property (nonatomic, strong) DashboardBillInfo *billInfo;
@property (nonatomic, strong) DashboardEntityInfo *entityInfo;
@property (nonatomic, strong) DashboardAdsInfo *adsInfo;
@property (nonatomic, strong) DashboardRecordInfo *recordInfo;
@property (nonatomic, strong) DashboardLoginOutInfo *loginOutInfo;
@property (nonatomic, strong) DashboardRateInfo *rateInfo;
@property (nonatomic, strong) DashboardPageInfo *pageInfo;

- (NSArray *)sectionItems;

@end

NS_ASSUME_NONNULL_END
