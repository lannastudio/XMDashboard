//
//  DashboardSingleInfoCollectionViewCell.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardInfoRowCollectionViewCell.h"

@class DashboardInfo;

NS_ASSUME_NONNULL_BEGIN

@interface DashboardSingleInfoCollectionViewCell : DashboardInfoRowCollectionViewCell

- (void)updateWithInfo:(DashboardInfo *)info;

@end

NS_ASSUME_NONNULL_END
