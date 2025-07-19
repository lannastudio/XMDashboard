//
//  XMDashboardComponentManager.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardComponentManager : NSObject

// 工程化，易拓展，项目复杂化后可动态调整order
- (instancetype)initWithOrder:(NSArray<NSString *> *)order;

- (void)triggerEvent:(SEL)selector;
- (NSArray *)allComponents;
- (void)reloadAllComponents;
- (id<XMDashboardComponent>)componentWithClass:(Class)componentClass;

@end

NS_ASSUME_NONNULL_END
