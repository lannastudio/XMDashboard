//
//  XMDashboardEventBus.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

typedef void(^XMEventBusBlock) (NSDictionary * _Nullable info);

NS_ASSUME_NONNULL_BEGIN

@interface XMEventToken : NSObject

@end


/**
 代替NSNotification，管理component直接的通讯
 */
@interface XMEventBus : NSObject

+ (instancetype)shared;

// target销毁时自动解绑
- (void)subscribe:(NSString *)event target:(id)target handler:(XMEventBusBlock)handler;

@end

NS_ASSUME_NONNULL_END
