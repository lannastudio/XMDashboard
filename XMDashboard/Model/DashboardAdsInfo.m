//
//  DashboardAdsInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardAdsInfo.h"
#import "DashboardInfo.h"

@implementation DashboardAdsInfo {
    NSArray *_infoList;
}

- (NSArray *)toDashboardInfoList {
    if (!_infoList) {
        _infoList = @[
            [[DashboardInfo alloc] initWithName:@"广告展示总数" info:@(_count).stringValue],
            [[DashboardInfo alloc] initWithName:@"用户平均" info:@(_avgPerUser).xm_decimalStringWithMax2Digits],
            [[DashboardInfo alloc] initWithName:@"单个用户最多" info:@(_maxCountByUser).stringValue],
        ];
    }
    return _infoList;
}

- (DashboardSection *)dashboardSection {
    return [DashboardSection sectionWithTitle:@"广告"];
}

@end
