//
//  DashboardPageInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardPageInfo.h"
#import "DashboardInfo.h"

@implementation DashboardPageInfo {
    NSArray *_infoList;
}

- (NSArray *)toDashboardInfoList {
    if (!_infoList) {
        NSArray *sortedKeys = [self.pageEnterCountMap keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj2 compare:obj1]; // 降序
        }];
        NSMutableArray *result = [NSMutableArray array];
        for (NSString *pageKey in sortedKeys) {
            NSString *pageName = self.pageNameMap[pageKey] ?: pageKey;
            NSString *info = [NSString stringWithFormat:@"%@", self.pageEnterCountMap[pageKey]];
            [result addObject:[[DashboardInfo alloc] initWithName:pageName info:info]];
        }
        _infoList = result.copy;
    }
    return _infoList;
}

- (DashboardSection *)dashboardSection {
    return [DashboardSection sectionWithTitle:@"页面分析"];
}

@end
