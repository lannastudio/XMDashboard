//
//  XMDashboardComponent.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

@protocol XMDashboardComponent <NSObject>

@required
@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) id dashboardViewModel;

- (void)componentDidLoad;
- (void)componentWillAppear;
- (void)componentDidAppear;
- (void)componentWillDisappear;
- (void)componentDidDisappear;

- (void)reloadData;

+ (NSString *)xm_identifier;

@optional
- (UIView *)xm_view;
- (CGSize)xm_size;
- (void)reloadWithData:(id)data;

@end
