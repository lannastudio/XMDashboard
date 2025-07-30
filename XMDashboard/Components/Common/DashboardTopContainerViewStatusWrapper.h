//
//  DashboardTopContainerViewStatusWrapper.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashboardTopContainerViewStatusWrapper : NSObject

@property (nonatomic, assign) BOOL willHide;

+ (instancetype)wrapperWithStatus:(BOOL)willHide;

@end

NS_ASSUME_NONNULL_END
