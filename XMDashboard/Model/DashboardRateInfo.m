//
//  DashboardRateInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardRateInfo.h"
#import "DashboardInfo.h"

@implementation DashboardRateInfo {
    DashboardInfo *_info;
}

- (DashboardInfo *)toDashboardInfo {
    if (!_info) {
        _info = [[DashboardInfo alloc] initWithName:@"评论" info:@(_rateCount).stringValue];
    }
    return _info;
}

- (NSString *)tagName {
    return @"评论分析";
}

@end
