//
//  UIView+Corner.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Corner)

- (void)kt_addCornerRadius:(UIRectCorner)corners
            withRadiusSize:(CGSize)radiusSize
                  viewRect:(CGRect)viewRect;


- (void)kt_addRoundCornerWithCornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
