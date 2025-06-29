//
//  UIResponder+EventHandler.h
//  XMDashboard
//
//  Created by lannastudio on 2025/6/23.
//

#import <UIKit/UIKit.h>
#import "XMEventName.h"

#pragma mark - auto register event

#define TO_NSSTRING(x) @#x

#define XM_EVENT_HANDLER(SELECTOR_SUFFIX) \
    - (void)handleEvent_##SELECTOR_SUFFIX:(id)data

#define XM_EVENT_HANDLER_PREFIX_STRING @"handleEvent_"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief 注册事件，沿着UIResponder链传递，自动寻找接收者
 */
@interface UIResponder (EventHandler)

- (void)xm_routerEvent:(NSString *)eventName data:(nullable id)data;

@end

NS_ASSUME_NONNULL_END
