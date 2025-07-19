//
//  DashboardUserInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardUserInfo.h"
#import "DashboardInfo.h"

@implementation DashboardUserInfo {
    NSArray *_infoList;
}

- (NSArray *)toDashboardInfoList {
    if (!_infoList) {
        NSMutableArray *result = [NSMutableArray array];
        [result addObject:[[DashboardInfo alloc] initWithName:@"用户总数" info:@(_userCount).stringValue]];
        [result addObject:[[DashboardInfo alloc] initWithName:@"埋点覆盖人数" info:@(_eventLogUserCount).stringValue]];
        [self.versionMap enumerateKeysAndObjectsUsingBlock:^(NSString *pageKey, NSNumber *count, BOOL *stop) {
            DashboardInfo *item = [[DashboardInfo alloc] initWithName:pageKey info:count.stringValue];
            [result addObject:item];
        }];
        _infoList = result.copy;
    }
    return _infoList;
}

- (DashboardSection *)dashboardSection {
    return [DashboardSection sectionWithTitle:@"用户与版本"];
}

@end
