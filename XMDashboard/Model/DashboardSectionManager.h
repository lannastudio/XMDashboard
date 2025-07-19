//
//  DashboardSectionManager.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import <Foundation/Foundation.h>

@class DashboardModel;

NS_ASSUME_NONNULL_BEGIN

@interface DashboardSectionManager : NSObject

+ (NSArray *)sortedItemsWithOrderCache:(NSArray *)items;
+ (void)cacheItems:(NSArray *)items;
+ (void)blockComponentItems:(NSArray *)items;
+ (NSArray *)blockedComponentItems;

@end

NS_ASSUME_NONNULL_END
