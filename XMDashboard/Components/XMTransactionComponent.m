//
//  XMTransactionCountComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMDashboardComponentFactory.h"
#import "XMTransactionComponent.h"

@interface XMTransactionComponent ()

@end

@implementation XMTransactionComponent

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

- (void)componentDidAppear { 

}

- (void)componentDidDisappear { 

}

- (void)componentDidLoad { 

}

- (void)componentWillAppear { 

}

- (void)componentWillDisappear { 

}

- (void)reloadData { 
    
}

+ (NSString *)xm_identifier { 
    return @"transaction_count_component";
}

@end
