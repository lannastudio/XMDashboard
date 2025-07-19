//
//  XMBaseComponent.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/18.
//

#import <Foundation/Foundation.h>

@protocol XMComponentContext;

NS_ASSUME_NONNULL_BEGIN

/**
 统一实现协议，简化业务开发
 业务根据需要实现空方法
 便于拓展公共能力，所有子类自动拥有，无需重复工作
 */
@interface XMBaseComponent : NSObject <XMDashboardComponent>

@property (nonatomic, weak) UIViewController<XMComponentContext> *context;

- (void)reloadWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
