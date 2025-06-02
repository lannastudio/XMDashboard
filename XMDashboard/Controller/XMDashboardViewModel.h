//
//  XMDashboardViewModel.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardViewModel : NSObject

- (void)requestWithCompletion:(void(^)(NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
