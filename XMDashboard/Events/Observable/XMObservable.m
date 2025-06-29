//
//  XMObervable.m
//  XMDashboard
//
//  Created by lannastudio on 2025/6/3.
//

#import "XMObservable.h"
#import <pthread.h>

@interface XMObservable ()

@property (nonatomic, assign) XMObservableValuePolicy valuePolicy;

@end

@implementation XMObservable {
    NSMapTable<id, XMObservableCallback> *_willChangeObservers;
    NSMapTable<id, XMObservableCallback> *_didChangeObservers;
    NSMapTable<id, XMObservableCallback> *_initObservers;
    id _value;
    BOOL _hasInit;
    pthread_mutex_t _lock;
}

- (void)dealloc
{
    pthread_mutex_destroy(&_lock);
}

- (instancetype)initWithPolicy:(XMObservableValuePolicy)policy {
    self = [super init];
    if (self) {
        _valuePolicy = policy;
        _willChangeObservers = [NSMapTable weakToStrongObjectsMapTable];
        _didChangeObservers = [NSMapTable weakToStrongObjectsMapTable];
        _initObservers = [NSMapTable weakToStrongObjectsMapTable];
        _callbackOnMainThread = YES;
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

+ (instancetype)strongObservable {
    XMObservable *observable = [[XMObservable alloc] initWithPolicy:XMObservableValuePolicyStrong];
    return observable;
}

+ (instancetype)copyObservable {
    XMObservable *observable = [[XMObservable alloc] initWithPolicy:XMObservableValuePolicyCopy];
    return observable;
}

#pragma mark - public

- (void)addObserver:(id)observer
           forEvent:(XMObservableEventType)type
           callback:(XMObservableCallback)block {
    pthread_mutex_lock(&_lock);
    NSMapTable *map = [self _getMapTableWithType:type];
    [map setObject:[block copy] forKey:observer];
    pthread_mutex_unlock(&_lock);
}

- (void)addObserver:(id)observer callback:(XMObservableCallback)block {
    [self addObserver:observer forEvent:XMObservableEventDidChange callback:block];
}

- (void)removeObserver:(id)observer forEvent:(XMObservableEventType)type {
    pthread_mutex_lock(&_lock);
    NSMapTable *map = [self _getMapTableWithType:type];
    [map removeObjectForKey:observer];
    pthread_mutex_unlock(&_lock);
}

- (void)xm_setValue:(id)value {
    pthread_mutex_lock(&_lock);
    if (value == _value) {
        // 必须是新的实例才返回，不使用isEqual:
        pthread_mutex_unlock(&_lock);
        return;
    }

    id newValue = _valuePolicy == XMObservableValuePolicyStrong ? value : [value copy];

    [self _performWillChangeObserverCallback:newValue];

    id oldValue = _value;
    _value = newValue;

    [self _performInitObserverCallbackIfNeeded:newValue];
    
    [self _performDidChangeObserverCallback:newValue oldValue:oldValue];

    pthread_mutex_unlock(&_lock);
}

- (id)xm_getValue {
    return _value;
}

- (void)setCallbackOnMainThread:(BOOL)callbackOnMainThread {
    pthread_mutex_lock(&_lock);
    _callbackOnMainThread = callbackOnMainThread;
    pthread_mutex_unlock(&_lock);
}

#pragma mark - private

- (void)_performWillChangeObserverCallback:(id)newValue {
    XMBlock block = ^ {
        for (id key in self->_willChangeObservers) {
            XMObservableCallback callback = [self->_willChangeObservers valueForKey:key];
            SafeBlock(callback, newValue, self->_value);
        }
    };

    [self _performOnMainThreadIfNeeded:block];
}

- (void)_performInitObserverCallbackIfNeeded:(id)newValue {
    if (_hasInit) return;
    _hasInit = YES;
    XMBlock block = ^{
        for (id key in self->_initObservers) {
            XMObservableCallback callback = [self->_initObservers valueForKey:key];
            SafeBlock(callback, newValue, nil);
        }
    };
    [self _performOnMainThreadIfNeeded:block];
}

- (void)_performDidChangeObserverCallback:(id)newValue oldValue:(id)oldValue {
    XMBlock block = ^{
        for (id key in self->_didChangeObservers) {
            XMObservableCallback callback = [self->_didChangeObservers valueForKey:key];
            SafeBlock(callback, newValue, oldValue);
        }
    };
    [self _performOnMainThreadIfNeeded:block];
}

- (void)_performOnMainThreadIfNeeded:(XMBlock)block {
    if (_callbackOnMainThread) {
        SafeMainThreadDispatch(block);
    } else {
        SafeBlock(block);
    }
}

- (NSMapTable *)_getMapTableWithType:(XMObservableEventType)type {
    switch (type) {
        case XMObservableEventDidChange: return _didChangeObservers;
        case XMObservableEventWillChange: return _willChangeObservers;
        case XMObservableEventInit: return _initObservers;
    }
}

void SafeMainThreadDispatch(XMBlock block) {
    if ([NSThread isMainThread]) {
        SafeBlock(block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@end
