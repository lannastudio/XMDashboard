//
//  DashboardInfoListBaseModel.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardInfoListDelegate.h"
#import "DashboardSection.h"
#import "TagSelectionItem.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashboardInfoListBaseModel : NSObject <DashboardInfoListDelegate, DashboardSectionDelegate, TagSelectionItemDelegate>

- (NSArray *)toDashboardInfoList;
- (DashboardSection *)dashboardSection;
- (NSString *)tagName;

@end

NS_ASSUME_NONNULL_END
