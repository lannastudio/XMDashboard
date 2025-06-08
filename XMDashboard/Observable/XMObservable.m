//
//  XMObervable.m
//  XMDashboard
//
//  Created by lannastudio on 2025/6/3.
//

#import "XMObservable.h"

typedef NS_ENUM(NSUInteger, XMObservableValuePolicy) {
    XMObservableValuePolicyStrong,
    XMObservableValuePolicyCopy
};

@interface XMObservable ()

@property (nonatomic, assign) XMObservableValuePolicy valuePolicy;

@end

@implementation XMObservable {
    NSMapTable<id, XMObservableCallback> *_willChangeObservers;
    NSMapTable<id, XMObservableCallback> *_didChangeObservers;
    NSMapTable<id, XMObservableCallback> *_initObservers;
    id _value;
    BOOL _hasInit;
    NSLock *_lock;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _willChangeObservers = [NSMapTable weakToStrongObjectsMapTable];
        _didChangeObservers = [NSMapTable weakToStrongObjectsMapTable];
        _initObservers = [NSMapTable weakToStrongObjectsMapTable];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

+ (instancetype)strongObservable {
    XMObservable *observable = [[XMObservable alloc] init];
    observable.valuePolicy = XMObservableValuePolicyStrong;
    return observable;
}

+ (instancetype)copyObservable {
    XMObservable *observable = [[XMObservable alloc] init];
    observable.valuePolicy = XMObservableValuePolicyCopy;
    return observable;
}

- (void)addObserver:(id)observer
           forEvent:(XMObservableEventType)type
           callback:(XMObservableCallback)block {
    [_lock lock];
    switch (type) {
        case XMObservableEventDidChange: {
            [_didChangeObservers setObject:[block copy] forKey:observer];
        } break;
        case XMObservableEventWillChange: {
            [_willChangeObservers setObject:[block copy] forKey:observer];
        } break;
        case XMObservableEventInit: {
            [_initObservers setObject:[block copy] forKey:observer];
        } break;
    }
    [_lock unlock];
}

- (void)addObserver:(id)observer callback:(XMObservableCallback)block {
    [self addObserver:observer forEvent:XMObservableEventDidChange callback:block];
}

- (void)xm_setValue:(id)value {
    [_lock lock];
    id newValue = _valuePolicy == XMObservableValuePolicyStrong ? value : [value copy];

    for (id key in _willChangeObservers) {
        XMObservableCallback callback = [_willChangeObservers valueForKey:key];
        SafeBlock(callback, newValue, _value);
    }


    id oldValue = _value;
    _value = newValue;

    if (!_hasInit) {
        _hasInit = YES;
        for (id key in _initObservers) {
            XMObservableCallback callback = [_initObservers valueForKey:key];
            SafeBlock(callback, newValue, nil);
        }
    }
    
    for (id key in _didChangeObservers) {
        XMObservableCallback callback = [_didChangeObservers valueForKey:key];
        SafeBlock(callback, newValue, oldValue);
    }
    [_lock unlock];
}

- (id)xm_getValue {
    return _value;
}

@end
