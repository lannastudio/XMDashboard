//
//  DashboardRecordInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardRecordInfo.h"
#import "DashboardInfo.h"

@implementation DashboardRecordInfo {
    DashboardInfo *_info;
}

- (DashboardInfo *)toDashboardInfo {
    if (!_info) {
        _info = [[DashboardInfo alloc] initWithName:@"记账页面停留时间" info:@(_avgBillDuration).xm_decimalStringWithMax2Digits];
    }
    return _info;
}

- (NSString *)tagName {
    return @"记账时长";
}

@end
