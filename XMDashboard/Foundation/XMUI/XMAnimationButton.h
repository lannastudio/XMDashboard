//
//  XMAnimationButton.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/18.
//

#import "XMExtensionButton.h"

typedef NS_OPTIONS(NSUInteger, XMAnimationButtonFeedback) {
    XMAnimationButtonFeedbackNone = 0,
    XMAnimationButtonFeedbackEnd = 1,
    XMAnimationButtonFeedbackBegin = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface XMAnimationButton : XMExtensionButton

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat initialSpringVelocity;

@property (nonatomic, assign) CGFloat usingSpringWithDamping;

@property (nonatomic, assign) XMAnimationButtonFeedback feedbackStyle;

/// 需要同时设置feedbackStyle为end，不然不生效
@property (nonatomic, assign) BOOL impactFeedbackDifferentWhenTouchEnd;

@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, strong) UIColor *kt_backgroundColor;
@property (nonatomic, strong) UIColor *kt_selectionColor;

@end

NS_ASSUME_NONNULL_END
