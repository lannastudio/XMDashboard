//
//  DashboardLoginOutInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardLoginOutInfo.h"
#import "DashboardInfo.h"

@implementation DashboardLoginOutInfo {
    DashboardInfo *_info;
}

- (DashboardInfo *)toDashboardInfo {
    if (!_info) {
        _info = [[DashboardInfo alloc] initWithName:@"退出登录" info:@(_count).stringValue];
    }
    return _info;
}

- (NSString *)tagName {
    return @"退出登录";
}

@end
