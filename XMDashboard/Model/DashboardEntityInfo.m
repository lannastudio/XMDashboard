//
//  DashboardEntityInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardEntityInfo.h"
#import "DashboardInfo.h"

@implementation DashboardEntityInfo {
    NSArray *_infoList;
}

- (NSArray *)toDashboardInfoList {
    if (!_infoList) {
        NSString *ramString = [NSString stringWithFormat:@"%@ MB", @(_billTableSizeMB).xm_decimalStringWithMax2Digits];
        _infoList = @[
            [[DashboardInfo alloc] initWithName:@"记账总数" info:@(_totalBillCount).stringValue],
            [[DashboardInfo alloc] initWithName:@"名称为空概率" info:[DashboardInfo percentString:_emptyNotesRatio*100]],
            [[DashboardInfo alloc] initWithName:@"备注为空概率" info:[DashboardInfo percentString:_emptyRemarkRatio*100]],
            [[DashboardInfo alloc] initWithName:@"标签为空概率" info:[DashboardInfo percentString:_emptyLabelIdsRatio*100]],
            [[DashboardInfo alloc] initWithName:@"账单占内存" info:ramString],
        ];
    }
    return _infoList;
}

- (DashboardSection *)dashboardSection {
    return [DashboardSection sectionWithTitle:@"数据分析"];
}

@end
