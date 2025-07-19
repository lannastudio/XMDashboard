//
//  XMDashboardComponentFactory.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMDashboardComponentFactory.h"

@implementation XMDashboardComponentFactory

static NSMutableDictionary<NSString *, Class> *_factory;
static dispatch_semaphore_t _lock;

+ (void)initialize
{
    _factory = [NSMutableDictionary dictionary];
    _lock = dispatch_semaphore_create(1);
}

+ (void)registerComponentClass:(Class)componentClass {
    if (![componentClass conformsToProtocol:@protocol(XMDashboardComponent)]) {
        return;
    }

    NSString *identifier = [componentClass xm_identifier];
    if (StringUtils.isBlank(identifier)) {
        return;
    }

    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSAssert(!_factory[identifier], @"重复注册 component identifier: %@", identifier);
    _factory[identifier] = componentClass;
    dispatch_semaphore_signal(_lock);
}

+ (id<XMDashboardComponent>)componentWithIdentifier:(NSString *)identifier {
    if (StringUtils.isBlank(identifier)) {
        return nil;
    }
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    Class componentClass = _factory[identifier];
    dispatch_semaphore_signal(_lock);
    return componentClass ? [[componentClass alloc] init] : nil;
}

+ (NSArray<Class> *)allComponents {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSArray *components = _factory.allValues;
    dispatch_semaphore_signal(_lock);
    return components;
}

@end
