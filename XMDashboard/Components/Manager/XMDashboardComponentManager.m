//
//  XMDashboardComponentManager.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMComponentConstants.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardComponentManager.h"

@interface XMDashboardComponentManager ()

// 可变数组易于后期拓展
@property (nonatomic, strong) NSMutableArray *orderIdentifiers;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<XMDashboardComponent>> *componentMap;

@end

@implementation XMDashboardComponentManager

// 全局唯一，无状态的服务类才使用单例
// 创建实例，多个页面使用，方便拓展
- (instancetype)init {
    return [self initWithOrder:@[
        XMDashboardSectionsComponentIdentifier,
        XMTagHeaderComponentIdentifier,
    ]];
}

- (instancetype)initWithOrder:(NSArray<NSString *> *)order {
    self = [super init];
    if (self) {
        _orderIdentifiers = order.mutableCopy;

        _componentMap = [NSMutableDictionary dictionary];
        [[XMDashboardComponentFactory allComponents] xm_each:^(Class componentClass) {
            id<XMDashboardComponent> component = [[componentClass alloc] init];
            [self _registerComponent:component identifier:[componentClass xm_identifier]];
        }];
    }
    return self;
}

#pragma mark - private

- (void)_registerComponent:(id<XMDashboardComponent>)component identifier:(NSString *)identifier {
    if (StringUtil.isNotBlank(identifier)) {
        _componentMap[identifier] = component;
    }
}

#pragma mark - public

- (void)triggerEvent:(SEL)selector {
    [_componentMap.allValues xm_each:^(id<XMDashboardComponent> component) {
        if ([component respondsToSelector:selector]) {
            // push/pop 只对这一段代码生效
            // ignored 忽略警告
            // 警告是因为, 当方法有返回值的时候ARC不知道如何管理引用计数
            // 当方法有返回值的时候，ARC无法retain/release，所以存在内存泄露风险
            // 这里方法没有返回值
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [component performSelector:selector];
#pragma clang diagnostic pop
        }
    }];
}

- (NSArray *)allComponents {
    return [_orderIdentifiers xm_safe_map:^id (NSString *identifier) {
        return self.componentMap[identifier];
    }];
}

- (void)reloadAllComponents {
    [self.allComponents xm_each:^(id<XMDashboardComponent> component) {
        [component reloadData];
    }];
}

@end
