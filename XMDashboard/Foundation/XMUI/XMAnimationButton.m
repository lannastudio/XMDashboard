//
//  XMAnimationButton.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/18.
//

#import "XMAnimationButton.h"

@implementation XMAnimationButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        _impactFeedbackDifferentWhenTouchEnd = YES;
    }
    return self;
}

- (CGFloat)initialSpringVelocity {
    if (!_initialSpringVelocity) {
        return 6.f;
    }
    return _initialSpringVelocity;
}

- (CGFloat)usingSpringWithDamping {
    if (!_usingSpringWithDamping) {
        return 0.33;
    }
    return _usingSpringWithDamping;
}

- (CGFloat)scale {
    if (!_scale) {
        return 0.94;
    }
    return _scale;
}

- (CGFloat)animationDuration {
    if (!_animationDuration) {
        return 0.33;
    }
    return _animationDuration;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.feedbackStyle == XMAnimationButtonFeedbackBegin) {

    }

    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformMakeScale(self.scale, self.scale);
    } completion:nil];

    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.impactFeedbackDifferentWhenTouchEnd && self.feedbackStyle == XMAnimationButtonFeedbackEnd) {
        UITouch *touch = touches.allObjects.lastObject;
        if (touch) {
            CGPoint point = [touch locationInView:self];
            if (self.feedbackStyle != XMAnimationButtonFeedbackNone) {
                if (!CGRectContainsPoint(self.bounds, point)) {


                } else {

                }
            }
        }
    }

    WS
    [UIView animateWithDuration:self.animationDuration
                          delay:0.f
         usingSpringWithDamping:self.usingSpringWithDamping
          initialSpringVelocity:self.initialSpringVelocity
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        weak_self.transform = CGAffineTransformIdentity;
    } completion:nil];

    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    if (touch) {
        CGPoint point = [touch locationInView:self];
        if (!CGRectContainsPoint(self.bounds, point)) {
            WS
            [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                weak_self.transform = CGAffineTransformIdentity;
            } completion:nil];
        } else {
            WS
            [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                weak_self.transform = CGAffineTransformMakeScale(weak_self.scale, weak_self.scale);
            } completion:nil];
        }
    }

    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.feedbackStyle != XMAnimationButtonFeedbackNone) {

    }

    WS
    [UIView animateWithDuration:self.animationDuration
                          delay:0.f
         usingSpringWithDamping:self.usingSpringWithDamping
          initialSpringVelocity:self.initialSpringVelocity
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        weak_self.transform = CGAffineTransformIdentity;
    } completion:nil];

    [super touchesCancelled:touches withEvent:event];
}

@end
