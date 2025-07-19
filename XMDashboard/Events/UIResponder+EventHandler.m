//
//  UIResponder+EventHandler.m
//  XMDashboard
//
//  Created by lannastudio on 2025/6/23.
//

#import "UIResponder+EventHandler.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIResponder (EventHandler)

- (void)xm_routerEvent:(NSString *)eventName data:(id)data {
    SEL sel = [self.eventStrategy[eventName] pointerValue];
    if (sel && [self respondsToSelector:sel]) {
        ((void (*)(id, SEL, id))objc_msgSend)(self, sel, data);
        return;
    }
    [[self nextResponder] xm_routerEvent:eventName data:data];
}

- (NSDictionary *)eventStrategy {
    NSDictionary *dict = objc_getAssociatedObject(self, @selector(eventStrategy));
    if (!dict) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        unsigned int methodCount = 0;
        Method *methodList = class_copyMethodList([self class], &methodCount);
        for (unsigned int i = 0; i < methodCount; i++) {
            SEL sel = method_getName(methodList[i]);
            NSString *methodName = NSStringFromSelector(sel);
            if ([methodName hasPrefix:XM_EVENT_HANDLER_PREFIX_STRING]) {
                NSString *eventName = [methodName substringFromIndex:XM_EVENT_HANDLER_PREFIX_STRING.length];
                if ([eventName hasSuffix:@":"]) {
                    eventName = [eventName substringToIndex:eventName.length-1];
                }
                result[eventName] = [NSValue valueWithPointer:sel];
            }
        }
        free(methodList);
        dict = result.copy;
        objc_setAssociatedObject(self, @selector(eventStrategy), dict, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return dict;
}

- (void)setEventStrategy:(NSDictionary *)eventStrategy {
    objc_setAssociatedObject(self, @selector(eventStrategy), eventStrategy, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleTouchesMethods];
//    });
//}
//
//
//+ (void)swizzleTouchesMethods {
//    Class class = [self class];
//    NSArray *selectors = @[
//        @"touchesBegan:withEvent:",
//        @"touchesEnded:withEvent:",
//        @"touchesMoved:withEvent:",
//        @"touchesCancelled:withEvent:"
//    ];
//    NSArray *swizzleds = @[
//        @"xm_swizzled_touchesBegan:withEvent:",
//        @"xm_swizzled_touchesEnded:withEvent:",
//        @"xm_swizzled_touchesMoved:withEvent:",
//        @"xm_swizzled_touchesCancelled:withEvent:"
//    ];
//
//    for (NSInteger i = 0; i < selectors.count; i++) {
//        SEL originalSelector = NSSelectorFromString(selectors[i]);
//        SEL swizzledSelector = NSSelectorFromString(swizzleds[i]);
//
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//        if (!originalMethod || !swizzledMethod) continue;
//
//        BOOL didAddMethod =
//        class_addMethod(class,
//                        originalSelector,
//                        method_getImplementation(swizzledMethod),
//                        method_getTypeEncoding(swizzledMethod));
//        if (didAddMethod) {
//            class_replaceMethod(class,
//                                swizzledSelector,
//                                method_getImplementation(originalMethod),
//                                method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    }
//}
//
//// 实现四个 swizzled 方法
//- (void)xm_swizzled_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touches Began: %@", self);
//    [self xm_swizzled_touchesBegan:touches withEvent:event];
//}
//- (void)xm_swizzled_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touches Ended: %@", self);
//    [self xm_swizzled_touchesEnded:touches withEvent:event];
//}
//- (void)xm_swizzled_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touches Moved: %@", self);
//    [self xm_swizzled_touchesMoved:touches withEvent:event];
//}
//- (void)xm_swizzled_touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touches Cancelled: %@", self);
//    [self xm_swizzled_touchesCancelled:touches withEvent:event];
//}


@end
