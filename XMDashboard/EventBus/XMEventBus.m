//
//  XMDashboardEventBus.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMEventBus.h"
#import <objc/runtime.h>

@implementation XMEventToken

- (void)dealloc
{
    XMBlock unbind = objc_getAssociatedObject(self, @"unbind_block");
    SafeBlock(unbind);
}

@end

@implementation XMEventWrapper

@end

@interface XMEventBus ()

// block在objective-c里是NSObject的子类，遵循NSCopying协议
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<XMEventWrapper *> *> *subscribers;

@end

@implementation XMEventBus {
    // 不用nslock，保证性能
    dispatch_semaphore_t _lock;
}

+ (instancetype)shared {
    static XMEventBus *bus = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bus = [[XMEventBus alloc] init];
    });
    return bus;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _subscribers = [NSMutableDictionary dictionary];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - 1. 用事件 Class 订阅（强类型）
- (XMEventToken *)subscribeEventClass:(Class)eventClass
                              target:(id)target
                             handler:(XMEventHandler)handler
{
    if (!eventClass || !target || !handler) return nil;
    NSString *key = NSStringFromClass(eventClass);
    return [self subscribeEventKey:key target:target handler:handler];
}

#pragma mark - 2. 用字符串事件名订阅（灵活）
- (XMEventToken *)subscribeEventName:(NSString *)eventName
                             target:(id)target
                            handler:(XMEventHandler)handler
{
    if (!eventName || !target || !handler) return nil;
    return [self subscribeEventKey:eventName target:target handler:handler];
}

#pragma mark - 3. 内部统一实现（支持任何 key）
- (XMEventToken *)subscribeEventKey:(NSString *)key
                            target:(id)target
                           handler:(XMEventHandler)handler
{
    if (!key || !target || !handler) return nil;

    XMEventToken *token = [[XMEventToken alloc] init];
    XMEventWrapper *wrapper = [[XMEventWrapper alloc] init];
    wrapper.handler = [handler copy];
    wrapper.target = target;
    wrapper.token = token;

    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSMutableArray *events = _subscribers[key];
    if (!events) {
        events = [NSMutableArray array];
        _subscribers[key] = events;
    }
    [events addObject:wrapper];
    dispatch_semaphore_signal(_lock);

    objc_setAssociatedObject(token, @"unbind_block", ^{
        [self unsubscribe:token];
    }, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(target, (__bridge const void *)(token), token, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return token;
}

- (void)unsubscribe:(XMEventToken *)token {
    if (!token) return;

    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_subscribers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray<XMEventWrapper *> *events, BOOL *stop) {
        events = [events xm_select:^BOOL(XMEventWrapper *wrapper) {
            return wrapper.token != token;
        }].mutableCopy;
    }];
    dispatch_semaphore_signal(_lock);
}

- (void)post:(id)event {
    if (!event) return;
    NSString *key = nil;
    if ([event isKindOfClass:[NSString class]]) {
        key = (NSString *)event;
    } else {
        key = NSStringFromClass([event class]);
    }
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSArray *list = [_subscribers[key] copy];
    dispatch_semaphore_signal(_lock);

    [list enumerateObjectsUsingBlock:^(XMEventWrapper *wrapper, NSUInteger idx, BOOL *stop) {
        if (wrapper.target) {
            wrapper.handler(event);
        }
    }];
}

- (void)post:(NSString *)eventName withObject:(id)object {
    if (!eventName) return;

    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSArray *list = [_subscribers[eventName] copy];
    dispatch_semaphore_signal(_lock);

    [list enumerateObjectsUsingBlock:^(XMEventWrapper *wrapper, NSUInteger idx, BOOL *stop) {
        if (wrapper.target) {
            wrapper.handler(object);
        }
    }];
}

- (void)postOnMainThread:(id)eventName withObject:(id)object {
    if ([NSThread isMainThread]) {
        [self post:eventName withObject:object];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self post:eventName withObject:object];
        });
    }
}

- (void)postOnMainThread:(id)event {
    if ([NSThread isMainThread]) {
        [self post:event];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self post:event];
        });
    }
}

@end
