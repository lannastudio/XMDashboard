//
//  XMAnimationButton.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/18.
//

#import "XMAnimationButton.h"

@implementation XMAnimationButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _feedbackOptions = XMAnimationButtonFeedbackBegin | XMAnimationButtonFeedbackEnd;
        _initialSpringVelocity = 6;
        _usingSpringWithDamping = 0.33;
        _scale = 0.95;
        _animationDuration = 0.32;
    }
    return self;
}

#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self _performImpactFeedbackIfNeededForType:XMAnimationButtonFeedbackBegin];

    [self _performScaleAnimation];

    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    if (touch) {
        CGPoint point = [touch locationInView:self];
        if (!CGRectContainsPoint(self.bounds, point)) {
            [self _resetTransformAnimated];
        } else {
            [self _performScaleAnimation];
        }
    }

    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self _performImpactFeedbackIfNeededForType:XMAnimationButtonFeedbackEnd];

    [self _resetTransformAnimated];
    
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.lastObject;
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, point)) {
        [self _performImpactFeedbackIfNeededForType:XMAnimationButtonFeedbackEnd];
    }

    [self _resetTransformAnimated];

    [super touchesEnded:touches withEvent:event];
}

- (void)_resetTransformAnimated {
    xm_springAnimation(self.animationDuration, self.usingSpringWithDamping, self.initialSpringVelocity, ^{
        self.transform = CGAffineTransformIdentity;
    });
}

- (void)_performScaleAnimation {
    xm_animation(_animationDuration, ^{
        self.transform = CGAffineTransformMakeTranslation(self.scale, self.scale);
    });
}

- (void)_performImpactFeedbackIfNeededForType:(XMAnimationButtonFeedback)type {
    if (self.feedbackOptions & type) {
        xm_impactFeedbackOccured();
    }
}

void xm_animation(CGFloat duration, XMBlock animations) {
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:animations
                     completion:nil];
}

void xm_springAnimation(CGFloat duration,
                        CGFloat damping,
                        CGFloat velocity,
                        XMBlock animations) {
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:animations
                     completion:nil];
}

@end
