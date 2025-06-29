//
//  XMAnimationButton.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/18.
//

#import "XMExtensionButton.h"

typedef NS_OPTIONS(NSUInteger, XMAnimationButtonFeedback) {
    XMAnimationButtonFeedbackNone = 0,
    XMAnimationButtonFeedbackEnd = 1 << 1,
    XMAnimationButtonFeedbackBegin = 1 << 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface XMAnimationButton : XMExtensionButton

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat initialSpringVelocity;

@property (nonatomic, assign) CGFloat usingSpringWithDamping;

@property (nonatomic, assign) XMAnimationButtonFeedback feedbackOptions;

@property (nonatomic, assign) CGFloat animationDuration;

@end

NS_ASSUME_NONNULL_END
