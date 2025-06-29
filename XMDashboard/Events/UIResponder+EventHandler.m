//
//  UIResponder+EventHandler.m
//  XMDashboard
//
//  Created by lannastudio on 2025/6/23.
//

#import "UIResponder+EventHandler.h"
#import <objc/runtime.h>

@implementation UIResponder (EventHandler)

- (void)xm_routerEvent:(NSString *)eventName data:(id)data {
    NSInvocation *invocation = self.eventStrategy[eventName];
    if (invocation) {
        [invocation setArgument:&data atIndex:2];
        [invocation invoke];
        return;
    }
    [[self nextResponder] xm_routerEvent:eventName data:data];
}

- (NSInvocation *)xm_invocationWithSelector:(SEL)selector {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    return invocation;
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
            NSLog(@"[EVENTHANDLER] %@", methodName);
            if ([methodName hasPrefix:XM_EVENT_HANDLER_PREFIX_STRING]) {
                NSString *eventName = [methodName substringFromIndex:XM_EVENT_HANDLER_PREFIX_STRING.length];
                if ([eventName hasSuffix:@":"]) {
                    eventName = [eventName substringToIndex:eventName.length-1];
                }
                NSInvocation *invocation = [self xm_invocationWithSelector:sel];
                result[eventName] = invocation;
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

@end
