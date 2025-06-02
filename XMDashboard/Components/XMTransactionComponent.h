//
//  XMTransactionCountComponent.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMTransactionComponent : NSObject <XMDashboardComponent>

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, weak) UIView *containerView;

@end

NS_ASSUME_NONNULL_END
