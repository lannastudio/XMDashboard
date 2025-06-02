//
//  XMDashboardComponentFactory.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardComponentFactory : NSObject

+ (id<XMDashboardComponent>)componentWithIdentifier:(NSString *)identifier;
+ (void)registerComponentClass:(Class)componentClass;
// 职责分离原则：Factory 专注于创建实例，Manager 负责持有/释放/复用/管理生命周期
// 让 Factory 返回实例集合容易混乱实例的归属、生命周期和重复实例化问题
+ (NSArray<Class> *)allComponents;

@end

NS_ASSUME_NONNULL_END
