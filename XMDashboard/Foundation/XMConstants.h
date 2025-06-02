//
//  XMConstants.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^KTBlock)(void);

#define SafeBlock(block, ...) if (block) { block(__VA_ARGS__); }

#define WEAK_OBJ_REF(obj) __weak __typeof__(obj) weak_##obj = obj;
#define STRONG_OBJ_REF(obj) __strong __typeof__(weak_##obj) obj = weak_##obj;

#define WS WEAK_OBJ_REF(self);

#define XMSAFE_CAST(obj, Class)  ({                          \
    Class *castedObject = nil;                               \
    if ([obj isKindOfClass:[Class class]]) {                 \
        castedObject = (Class *)obj;                         \
    }                                                        \
    castedObject;                                            \
})

UIKIT_STATIC_INLINE UIImage * kt_alwaysTemplateImage(NSString *imageName) {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#define KTRGBAColor(r, g, b, a) ([UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)])
#define KTRGBColor(r, g, b) KTRGBAColor(r, g, b, 1.f)

#define KTClearColor [UIColor clearColor]
#define KTBlackColor [UIColor blackColor]
#define KTWhiteColor [UIColor whiteColor]


