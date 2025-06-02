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
@property (nonatomic, strong) NSMutableDictionary<Class, NSMutableArray<XMEventWrapper *> *> *subscribers;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation XMEventBus

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
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (XMEventToken *)subscribe:(Class)eventClass target:(id)target handler:(XMEventHandler)handler {
    if (eventClass == nil || target == nil || handler == nil) return nil;

    XMEventToken *token = [[XMEventToken alloc] init];
    XMEventWrapper *wrapper = [[XMEventWrapper alloc] init];
    wrapper.handler = [handler copy];
    wrapper.target = target;
    wrapper.token = token;

    [self.lock lock];
    NSMutableArray *events = _subscribers[eventClass];
    if (events == nil) {
        events = [NSMutableArray array];
        _subscribers[eventClass] = events;
    }
    [events addObject:wrapper];
    [self.lock unlock];

    WS WEAK_OBJ_REF(token);
    objc_setAssociatedObject(token, @"unbind_block", ^{
        [weak_self unsubscribe:weak_token];
    }, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(target, (__bridge const void *)(token), token, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return token;
}

- (void)unsubscribe:(XMEventToken *)token {
    if (!token) return;

    [self.lock lock];
    [_subscribers enumerateKeysAndObjectsUsingBlock:^(Class key, NSMutableArray<XMEventWrapper *> *events, BOOL *stop) {
        events = [events xm_select:^BOOL(XMEventWrapper *wrapper) {
            return wrapper.token != token;
        }].mutableCopy;
    }];
    [self.lock unlock];
}

- (void)post:(id)event {
    if (!event) return;

    Class eventClass = [event class];
    [self.lock lock];
    NSArray *list = _subscribers[eventClass].copy;
    [self.lock unlock];

    [list xm_each:^(XMEventWrapper *wrapper) {
        if (wrapper.target) {
            wrapper.handler(event);
        }
    }];
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
