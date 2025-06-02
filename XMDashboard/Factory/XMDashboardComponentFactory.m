//
//  XMDashboardComponentFactory.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMDashboardComponentFactory.h"

@implementation XMDashboardComponentFactory

// 静态变量，进程不销毁就一直存在
static NSMutableDictionary<NSString *, Class> *_factory;

+ (void)registerComponentClass:(Class)componentClass {
    if (![componentClass conformsToProtocol:@protocol(XMDashboardComponent)]) {
        return;
    }

    NSString *identifier = [componentClass xm_identifier];
    if (XMStringUtil.isBlank(identifier)) {
        return;
    }

    // 保证只创建一次
    // 线程安全单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _factory = [NSMutableDictionary dictionary];
    });
    _factory[identifier] = componentClass;
}

+ (id<XMDashboardComponent>)componentWithIdentifier:(NSString *)identifier {
    if (XMStringUtil.isBlank(identifier)) {
        return nil;
    }
    Class componentClass = _factory[identifier];
    return componentClass ? [[componentClass alloc] init] : nil;
}

+ (NSArray<Class> *)allComponents {
    return _factory.allValues;
}

@end
