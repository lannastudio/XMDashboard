//
//  UIView+Corner.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

- (void)kt_addCornerRadius:(UIRectCorner)corners withRadiusSize:(CGSize)radiusSize viewRect:(CGRect)viewRect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:viewRect byRoundingCorners:corners cornerRadii:radiusSize];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    [shapeLayer setPath:path.CGPath];

    self.layer.mask = shapeLayer;
}

- (void)kt_addRoundCornerWithCornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    self.layer.mask = mask;
}

@end
