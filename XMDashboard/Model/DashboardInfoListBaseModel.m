//
//  DashboardInfoListBaseModel.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardInfo.h"
#import "DashboardInfoListBaseModel.h"
#import <IGListKit/IGListKit.h>

@interface DashboardInfoListBaseModel () <IGListDiffable>

@end

@implementation DashboardInfoListBaseModel

- (NSArray *)toDashboardInfoList {
    return nil;
}

- (id<NSObject>)diffIdentifier {
    if (CollectionUtils.isEmpty(self.toDashboardInfoList)) {
        return self;
    }
    NSMutableString *identifier = [NSMutableString string];
    for (DashboardInfo *info in self.toDashboardInfoList) {
        [identifier appendString:info.name ?: @""];
        [identifier appendString:info.info ?: @""];
    }
    return identifier.copy;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (self == object) return YES;
    return [[self diffIdentifier] isEqual:[object diffIdentifier]];
}

- (DashboardSection *)dashboardSection {
    return nil;
}

- (NSString *)tagName {
    return self.dashboardSection.title;
}

@end
