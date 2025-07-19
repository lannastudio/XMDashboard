//
//  XMDashboardComponent.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

@protocol XMComponentContext;

@protocol XMDashboardComponent <NSObject>

@required
// 单一业务，方便组建和controller通信，所以不使用id
@property (nonatomic, weak) UIViewController<XMComponentContext> *context;

- (void)componentDidLoad;
- (void)componentWillAppear;
- (void)componentDidAppear;
- (void)componentWillDisappear;
- (void)componentDidDisappear;
- (void)componentWillLayoutSubviews;
- (void)componentDidLayoutSubviews;

- (void)reloadData;

+ (NSString *)xm_identifier;

@optional
- (void)reloadWithData:(id)data;
- (UIView *)componentView;

@end
