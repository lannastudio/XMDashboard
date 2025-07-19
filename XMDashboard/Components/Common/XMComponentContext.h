//
//  XMComponentContext.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/1.
//

@class XMDashboardViewModel, XMEventBus;
@protocol XMDashboardComponent;

@protocol XMComponentContext <NSObject>

@property (nonatomic, strong, readonly) XMDashboardViewModel *dashboardViewModel;
@property (nonatomic, strong, readonly) XMEventBus *dashboardEventBus;

- (id<XMDashboardComponent>)componentWithClass:(Class)componentClass;
- (void)reloadData;

@end
