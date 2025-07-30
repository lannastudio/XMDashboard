//
//  XMObervable.m
//  XMDashboard
//
//  Created by lannastudio on 2025/6/3.
//

#import "XMObservable.h"
#import <pthread.h>

/// TODO: handler 合并/批量通知.
/// 在一个 UI 帧内有大量更新时，可以合并所有变化，在下一个主线程 RunLoop 刷新时批量触发回调，比如用 dispatch_async(dispatch_get_main_queue())
/// 或者用 CADisplayLink、RunLoop observer，在每帧尾部集中处理
@interface XMObservable ()

@property (nonatomic, assign) XMObservableValuePolicy valuePolicy;
@property (nonatomic, copy) XMBlock debounceBlock;
@property (nonatomic, strong) id pendingValue;

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
        _debounceTimeInterval = 0.3;
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
    if (type & XMObservableEventWillChange) {
        [_willChangeObservers setObject:[block copy] forKey:observer];
    }
    if (type & XMObservableEventDidChange) {
        [_didChangeObservers setObject:[block copy] forKey:observer];
    }
    if (type & XMObservableEventInit) {
        [_initObservers setObject:[block copy] forKey:observer];
    }
    pthread_mutex_unlock(&_lock);
}

- (void)addObserver:(id)observer callback:(XMObservableCallback)block {
    [self addObserver:observer forEvent:XMObservableEventDidChange callback:block];
}

- (void)removeObserver:(id)observer forEvent:(XMObservableEventType)type {
    pthread_mutex_lock(&_lock);
    if (type & XMObservableEventWillChange) {
        [_willChangeObservers removeObjectForKey:observer];
    }
    if (type & XMObservableEventDidChange) {
        [_didChangeObservers removeObjectForKey:observer];
    }
    if (type & XMObservableEventInit) {
        [_initObservers removeObjectForKey:observer];
    }
    pthread_mutex_unlock(&_lock);
}

- (void)xm_setValue:(id)value {
    pthread_mutex_lock(&_lock);
    _pendingValue = value;
    if (_debounceBlock) {
        // 取消队列中的block，有无法取消的可能性
        dispatch_block_cancel(_debounceBlock);
        _debounceBlock = nil;
    }
    if (_debounceTimeInterval > 0) {
        WS
        XMBlock block = dispatch_block_create(0, ^{
            [weak_self _commitChange:weak_self.pendingValue];
        });
        _debounceBlock = block;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_debounceTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
        pthread_mutex_unlock(&_lock);
        return;
    }

    pthread_mutex_unlock(&_lock);

    [self _commitChange:value];
}

- (void)_commitChange:(id)value {
    pthread_mutex_lock(&_lock);
    if (value == _value) {
        // 必须是新的实例才返回，不使用isEqual:
        pthread_mutex_unlock(&_lock);
        return;
    }

    id newValue = _valuePolicy == XMObservableValuePolicyStrong ? value : [value copy];

    id oldValue = _value;
    _value = newValue;

    pthread_mutex_unlock(&_lock);

    [self _performWillChangeObserverCallback:newValue];

    [self _performInitObserverCallbackIfNeeded:newValue];

    [self _performDidChangeObserverCallback:newValue oldValue:oldValue];
}

- (id)xm_getValue {
    pthread_mutex_lock(&_lock);
    id value = _value;
    pthread_mutex_unlock(&_lock);
    return value;
}

- (void)setCallbackOnMainThread:(BOOL)callbackOnMainThread {
    pthread_mutex_lock(&_lock);
    _callbackOnMainThread = callbackOnMainThread;
    pthread_mutex_unlock(&_lock);
}

#pragma mark - private

- (void)_performWillChangeObserverCallback:(id)newValue {
    pthread_mutex_lock(&_lock);
    NSArray *callbacks = [_willChangeObservers.objectEnumerator allObjects];
    pthread_mutex_unlock(&_lock);

    XMBlock block = ^ {
        for (XMObservableCallback callback in callbacks) {
            SafeBlock(callback, newValue, self->_value);
        }
    };

    [self _performOnMainThreadIfNeeded:block];
}

- (void)_performInitObserverCallbackIfNeeded:(id)newValue {
    pthread_mutex_lock(&_lock);
    if (_hasInit) {
        pthread_mutex_unlock(&_lock);
        return;
    }
    _hasInit = YES;
    NSArray *callbacks = [_initObservers.objectEnumerator allObjects];
    pthread_mutex_unlock(&_lock);

    XMBlock block = ^{
        for (XMObservableCallback callback in callbacks) {
            SafeBlock(callback, newValue, nil);
        }
    };
    [self _performOnMainThreadIfNeeded:block];
}

- (void)_performDidChangeObserverCallback:(id)newValue oldValue:(id)oldValue {
    pthread_mutex_lock(&_lock);
    NSArray *callbacks = [self->_didChangeObservers.objectEnumerator allObjects];
    pthread_mutex_unlock(&_lock);
    XMBlock block = ^{
        for (XMObservableCallback callback in callbacks) {
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

void SafeMainThreadDispatch(XMBlock block) {
    if ([NSThread isMainThread]) {
        SafeBlock(block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@end
