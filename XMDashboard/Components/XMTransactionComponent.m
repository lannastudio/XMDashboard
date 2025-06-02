//
//  XMTransactionCountComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMComponentConstants.h"
#import "XMDashboardComponentFactory.h"
#import "XMTransactionComponent.h"

@interface XMTransactionComponent ()

@end

@implementation XMTransactionComponent

// 子类必须实现，dyld后mach-o装在Class，会执行所有类的+load，父类+load不会传递到子类
+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

- (void)componentDidLoad {
    [super componentDidLoad];
}

#pragma mark - component delegate

+ (NSString *)xm_identifier {
    return XMTransactionComponentIdentifier;
}

@end
