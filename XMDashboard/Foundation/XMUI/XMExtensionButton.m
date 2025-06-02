//
//  XMExtensionButton.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/18.
//

#import "XMExtensionButton.h"

@implementation XMExtensionButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _hitTestEdgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden || self.alpha < 0.01) {
        return [super pointInside:point withEvent:event];
    }

    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

- (CGSize)intrinsicContentSize {
    if (self.currentTitle.length == 0 && self.currentImage == nil && self.currentBackgroundImage == nil && self.currentAttributedTitle == nil) {
        return CGSizeZero;
    }

    return [super intrinsicContentSize];
}

@end
