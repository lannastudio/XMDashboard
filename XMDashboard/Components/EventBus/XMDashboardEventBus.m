//
//  XMDashboardEventBus.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMDashboardEventBus.h"

@interface XMDashboardEventBus ()

// block在objective-c里是NSObject的子类，遵循NSCopying协议
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<XMEventBusBlock> *> *subscribers;

@end

@implementation XMDashboardEventBus

+ (instancetype)shared {
    static XMDashboardEventBus *bus = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bus = [[XMDashboardEventBus alloc] init];
        bus.subscribers = [NSMutableDictionary dictionary];
    });
    return bus;
}

- (void)subscribe:(NSString *)event handler:(XMEventBusBlock)handler {
    if (event == nil || handler == nil) {
        return;
    }

    NSMutableArray *handlers = _subscribers[event];
    if (handlers == nil) {
        handlers = [NSMutableArray array];
        _subscribers[event] = handlers;
    }

    [handlers addObject:handler];
}

- (void)pulish:(NSString *)event info:(NSDictionary *)info {
    NSArray *handlers = _subscribers[event];
    for (XMEventBusBlock handler in handlers) {
        SafeBlock(handler, info);
    }
}


@end
