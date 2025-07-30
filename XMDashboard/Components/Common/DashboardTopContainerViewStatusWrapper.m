//
//  DashboardTopContainerViewStatusWrapper.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/30.
//

#import "DashboardTopContainerViewStatusWrapper.h"

@implementation DashboardTopContainerViewStatusWrapper

+ (instancetype)wrapperWithStatus:(BOOL)willHide {
    DashboardTopContainerViewStatusWrapper *wrapper = [[DashboardTopContainerViewStatusWrapper alloc] init];
    wrapper.willHide = willHide;
    return wrapper;
}

@end
