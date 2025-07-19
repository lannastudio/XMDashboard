//
//  DashboardBillInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardBillInfo.h"
#import "DashboardInfo.h"

@implementation DashboardBillInfo {
    NSArray *_infoList;
}

- (NSArray *)toDashboardInfoList {
    if (!_infoList) {
        _infoList = @[
            [[DashboardInfo alloc] initWithName:@"上周平均记账次数" info:@(_lastWeekDailyAvgBillCount).xm_decimalStringWithMax2Digits],
            [[DashboardInfo alloc] initWithName:@"用户最多记账次数" info:@(_maxBillCountByUser).stringValue],
            [[DashboardInfo alloc] initWithName:@"用户平均记账次数" info:@(_perUserAvgBillCount).xm_decimalStringWithMax2Digits],
        ];
    }
    return _infoList;
}

- (DashboardSection *)dashboardSection {
    return [DashboardSection sectionWithTitle:@"账单分析"];
}

@end
