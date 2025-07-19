//
//  XMDashboardEventBus.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

typedef void(^XMEventBusBlock) (NSDictionary * _Nullable info);
typedef void(^XMEventHandler) (id _Nullable object);

NS_ASSUME_NONNULL_BEGIN

@interface XMEventToken : NSObject

@end

@interface XMEventWrapper : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, copy) void(^handler)(id);
@property (nonatomic, weak) XMEventToken *token;

@end


/**
 代替NSNotification，管理component直接的通讯
 */
@interface XMEventBus : NSObject

+ (instancetype)shared;

// target销毁时自动解绑
- (XMEventToken *)subscribeEventClass:(Class)eventClass
                               target:(id)target
                              handler:(XMEventHandler)handler;

- (XMEventToken *)subscribeEventName:(NSString *)eventName
                              target:(id)target
                             handler:(XMEventHandler)handler;

- (void)unsubscribe:(XMEventToken *)token;

- (void)post:(id)event;
- (void)post:(NSString *)eventName withObject:(id)object;

- (void)postOnMainThread:(id)event;
- (void)postOnMainThread:(id)eventName withObject:(id)object;

@end

NS_ASSUME_NONNULL_END
