//
//  XMDashboardEventBus.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

typedef void(^XMEventBusBlock) (NSDictionary * _Nullable info);

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardEventBus : NSObject

+ (instancetype)shared;

- (void)subscribe:(NSString *)event handler:(XMEventBusBlock)handler;
- (void)pulish:(NSString *)event info:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
