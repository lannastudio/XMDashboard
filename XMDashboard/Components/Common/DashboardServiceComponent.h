//
//  DashboardComponentService.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/30.
//

#import "XMBaseComponent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @class DashboardServiceComponent
 @brief 服务组件，components公共方法的合集
 */
@interface DashboardServiceComponent : XMBaseComponent

- (void)showDateSelectionPopupViewController;

@end

@interface DashboardServiceComponent (ComponentDelegate)

@end

NS_ASSUME_NONNULL_END
