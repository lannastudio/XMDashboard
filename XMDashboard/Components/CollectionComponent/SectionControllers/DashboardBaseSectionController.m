//
//  DashboardBaseSectionController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardBaseSectionController.h"

@interface DashboardBaseSectionController ()

@property (nonatomic, assign) UIEdgeInsets sectionInsets;

@end

@implementation DashboardBaseSectionController

- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets {
    self = [super init];
    if (self) {
        _sectionInsets = sectionInsets;
    }
    return self;
}

- (UIEdgeInsets)inset {
    if (self.isFirstSection) {
        return _sectionInsets;
    } else if (self.isLastSection) {
        return UIEdgeInsetsMake(10, 18, 100, 18);
    }
    return UIEdgeInsetsMake(10, 18, 10, 18);
}

@end
