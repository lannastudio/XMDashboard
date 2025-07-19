//
//  XMDashboardEventBus.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMEventBus.h"
#import <objc/runtime.h>
#import <pthread.h>

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
    pthread_mutex_t _lock;
}

- (void)dealloc
{
    pthread_mutex_destroy(&_lock);
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
        pthread_mutex_init(&_lock, NULL);
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

    pthread_mutex_lock(&_lock);
    NSMutableArray *events = _subscribers[key];
    if (!events) {
        events = [NSMutableArray array];
        _subscribers[key] = events;
    }
    [events addObject:wrapper];
    pthread_mutex_unlock(&_lock);

    objc_setAssociatedObject(token, @"unbind_block", ^{
        [self unsubscribe:token];
    }, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(target, (__bridge const void *)(token), token, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return token;
}

- (void)unsubscribe:(XMEventToken *)token {
    if (!token) return;

    pthread_mutex_lock(&_lock);
    for (NSString *key in _subscribers.allKeys) {
        NSArray *events = _subscribers[key];
        events = [events xm_select:^BOOL(XMEventWrapper *wrapper) {
            return wrapper.token != token;
        }];
        if (events.count == 0) {
            [_subscribers removeObjectForKey:key];
        } else {
            _subscribers[key] = events.mutableCopy;
        }
    }
    pthread_mutex_unlock(&_lock);
}

- (void)post:(id)event {
    if (!event) return;
    NSString *key = nil;
    if ([event isKindOfClass:[NSString class]]) {
        key = (NSString *)event;
    } else {
        key = NSStringFromClass([event class]);
    }
    pthread_mutex_lock(&_lock);
    NSArray *list = [_subscribers[key] copy];
    pthread_mutex_unlock(&_lock);

    [list enumerateObjectsUsingBlock:^(XMEventWrapper *wrapper, NSUInteger idx, BOOL *stop) {
        if (wrapper.target) {
            wrapper.handler(event);
        }
    }];
}

- (void)post:(NSString *)eventName withObject:(id)object {
    if (!eventName) return;

    pthread_mutex_lock(&_lock);
    NSArray *list = [_subscribers[eventName] copy];
    pthread_mutex_unlock(&_lock);

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
