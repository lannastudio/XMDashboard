//
//  XMBaseComponent.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/18.
//

#import <Foundation/Foundation.h>

@class XMDashboardViewModel;

NS_ASSUME_NONNULL_BEGIN

/**
 统一实现协议，简化业务开发
 业务根据需要实现空方法

 便于拓展公共能力，所有子类自动拥有，无需重复工作

 统一类型管理，manager可以根据isKindOfClass:XMBaseComponent.class判断类型


 */
@interface XMBaseComponent : NSObject <XMDashboardComponent>

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) XMDashboardViewModel *dashboardViewModel;

- (UIView *)xm_view;
- (CGSize)xm_size;
- (void)reloadWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
