//
//  DashboardSingleInfoBaseModel.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardInfo.h"
#import "DashboardSingleInfoBaseModel.h"
#import <IGListKit/IGListKit.h>

@interface DashboardSingleInfoBaseModel () <IGListDiffable>

@end

@implementation DashboardSingleInfoBaseModel

- (DashboardInfo *)toDashboardInfo {
    return nil;
}

- (id<NSObject>)diffIdentifier {
    if (self.toDashboardInfo != nil && [self.toDashboardInfo isKindOfClass:DashboardInfo.class]) {
        DashboardInfo *info = (DashboardInfo *)self.toDashboardInfo;
        return [[NSString alloc] initWithFormat:@"%@ %@", info.name, info.info];
    }

    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (self == object) return YES;
    return [[self diffIdentifier] isEqual:[object diffIdentifier]];
}

- (NSString *)tagName {
    return @"";
}

@end
