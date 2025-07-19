//
//  DashboardAppInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardAppInfo.h"
#import "DashboardInfo.h"

@interface DashboardAppInfo ()

@end

@implementation DashboardAppInfo {
    NSArray *_infoList;
}

- (NSArray *)toDashboardInfoList {
    if (!_infoList) {
        _infoList = @[
            [[DashboardInfo alloc] initWithName:@"dau" info:@(_dau).stringValue],
            [[DashboardInfo alloc] initWithName:@"wau" info:@(_mau).stringValue],
            [[DashboardInfo alloc] initWithName:@"mau" info:@(_mau).stringValue],
            [[DashboardInfo alloc] initWithName:@"会员人数" info:@(_paidUserCount).stringValue],
        ];
    }
    return _infoList;
}

- (DashboardSection *)dashboardSection {
    return [DashboardSection sectionWithTitle:@"用户"];
}

@end
