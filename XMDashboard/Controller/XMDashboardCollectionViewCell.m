//
//  XMDashboardCollectionViewCell.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMDashboardCollectionViewCell.h"

@interface XMDashboardCollectionViewCell ()

@end

@implementation XMDashboardCollectionViewCell

- (void)updateWithComponent:(id<XMDashboardComponent>)component {
    [component.xm_view removeFromSuperview];

    [self.contentView addSubview:component.xm_view];
    component.xm_view.frame = self.contentView.bounds;
}

@end
