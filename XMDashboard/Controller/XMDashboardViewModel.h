//
//  XMDashboardViewModel.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/19.
//

#import <Foundation/Foundation.h>

@class DashboardModel;
@protocol XMObservableReadonly;

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardViewModel : NSObject

- (void)requestWithCompletion:(void(^)(NSError *error))completion;
- (id<XMObservableReadonly>)selectedDateObservable;
- (id<XMObservableReadonly>)dashboardInfoListObservable;
- (id<XMObservableReadonly>)orderedOriginalItemsObservable;
- (void)updateWhenItemsDidReorder;
- (BOOL)isPerformingUpdate;

@end

NS_ASSUME_NONNULL_END
