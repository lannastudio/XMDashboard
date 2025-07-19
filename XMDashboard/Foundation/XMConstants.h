//
//  XMConstants.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XMBlock)(void);

#define SafeBlock(block, ...) if (block) { block(__VA_ARGS__); }

#define WEAK_OBJ_REF(obj) __weak __typeof__(obj) weak_##obj = obj;
#define STRONG_OBJ_REF(obj) __strong __typeof__(weak_##obj) obj = weak_##obj;

#define WS WEAK_OBJ_REF(self);

#define SS \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(weak_self) self = weak_self; \
_Pragma("clang diagnostic pop")

#define XMSAFE_CAST(obj, Class)  ({                          \
    Class *castedObject = nil;                               \
    if ([obj isKindOfClass:[Class class]]) {                 \
        castedObject = (Class *)obj;                         \
    }                                                        \
    castedObject;                                            \
})

UIKIT_STATIC_INLINE UIImage * xm_alwaysTemplateImage(NSString *imageName) {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#define KTRGBAColor(r, g, b, a) ([UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)])
#define KTRGBColor(r, g, b) KTRGBAColor(r, g, b, 1.f)

#define XMClearColor [UIColor clearColor]
#define XMBlackColor [UIColor blackColor]
#define XMWhiteColor [UIColor whiteColor]

UIKIT_STATIC_INLINE void xm_impactFeedbackOccured(void) {
    UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [impactFeedback impactOccurred];
}

UIKIT_STATIC_INLINE void xm_impactFeedbackOccurred(UIImpactFeedbackStyle style) {
    UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
    [impactFeedback impactOccurred];
}

UIKIT_STATIC_INLINE void xm_impactFeedbackOccurredWithIntensity(UIImpactFeedbackStyle style, CGFloat intensity) {
    UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
    if (@available(iOS 13.0, *)) {
        [impactFeedback impactOccurredWithIntensity:intensity];
    } else {
        [impactFeedback impactOccurred];
    }
}

#ifdef DEBUG
#define XMLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__)
#else
#define XMLog(fmt, ...)
#endif

#define XMRGBAColor(r, g, b, a) ([UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)])
#define XMRGBColor(r, g, b) KTRGBAColor(r, g, b, 1.f)
