//
//  DashboardSingleInfoBaseModel.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardSingleInfoDelegate.h"
#import "TagSelectionItem.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashboardSingleInfoBaseModel : NSObject <DashboardSingleInfoDelegate, TagSelectionItemDelegate>

- (id)toDashboardInfo;
- (NSString *)tagName;

@end

NS_ASSUME_NONNULL_END
