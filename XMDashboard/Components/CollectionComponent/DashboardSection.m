//
//  DashboardSection.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "DashboardSection.h"
#import <IGListKit/IGListKit.h>

@interface DashboardSection () <IGListDiffable>

@end

@implementation DashboardSection

+ (instancetype)sectionWithTitle:(NSString *)title {
    DashboardSection *section = [[DashboardSection alloc] init];
    section.title = title;
    return section;
}

- (id<NSObject>)diffIdentifier {
    return self.title;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (self == object) return YES;
    return [self.diffIdentifier isEqual:object.diffIdentifier];
}

@end
