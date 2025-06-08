//
//  XMDashboardDecelerateEvent.h
//  XMDashboard
//
//  Created by lannastudio on 2025/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardDecelerateEvent : NSObject

@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) BOOL decelerate;

@end

NS_ASSUME_NONNULL_END
