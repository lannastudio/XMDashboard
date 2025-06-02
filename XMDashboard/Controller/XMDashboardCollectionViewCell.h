//
//  XMDashboardCollectionViewCell.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIView *componentView;

- (void)updateWithComponent:(id<XMDashboardComponent>)component;

@end

NS_ASSUME_NONNULL_END
