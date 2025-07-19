//
//  DashboardInfoRowCollectionViewCell.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import <UIKit/UIKit.h>

@class DashboardInfo;

typedef NS_ENUM(NSInteger, DashboardCellPosition) {
    DashboardCellPositionSingle,
    DashboardCellPositionFirst,
    DashboardCellPositionMiddle,
    DashboardCellPositionLast,
};

NS_ASSUME_NONNULL_BEGIN

@interface DashboardInfoRowCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *infoLabel;

- (void)updateWithInfo:(DashboardInfo *)info position:(DashboardCellPosition)position;

@end

NS_ASSUME_NONNULL_END
