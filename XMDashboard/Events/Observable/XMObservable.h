//
//  XMObservable.h
//  XMDashboard
//
//  Created by lannastudio on 2025/6/3.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XMObservableEventType) {
    XMObservableEventWillChange,
    XMObservableEventDidChange,
    XMObservableEventInit
};

typedef NS_ENUM(NSUInteger, XMObservableValuePolicy) {
    XMObservableValuePolicyStrong,
    XMObservableValuePolicyCopy
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^XMObservableCallback)(id _Nullable newValue, id _Nullable oldValue);


@protocol XMObservableReadonly <NSObject>

- (void)addObserver:(id)observer
           forEvent:(XMObservableEventType)type
           callback:(XMObservableCallback)block;
- (void)addObserver:(id)observer
           callback:(XMObservableCallback)block;
- (void)removeObserver:(id)observer forEvent:(XMObservableEventType)type;
- (id)xm_getValue;

@end

/**
 @class XMObservable
 @brief 适用于ViewController单向数据流的数据绑定工具
 @warning value的一致性需要业务层自己维护
 */
@interface XMObservable<ValueType> : NSObject <XMObservableReadonly>

// default YES
@property (nonatomic, assign) BOOL callbackOnMainThread;
// default 0.3s
@property (nonatomic, assign) NSTimeInterval debounceTimeInterval;

- (instancetype)initWithPolicy:(XMObservableValuePolicy)policy NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)strongObservable;
+ (instancetype)copyObservable;

/// @warning：首次赋值的时候willChangeBlock会在initBlock之前调用
- (void)addObserver:(id)observer
           forEvent:(XMObservableEventType)type
           callback:(XMObservableCallback)block;
- (void)addObserver:(id)observer
           callback:(XMObservableCallback)block;
- (void)removeObserver:(id)observer forEvent:(XMObservableEventType)type;
- (void)xm_setValue:(ValueType)value;
- (ValueType)xm_getValue;

@end

NS_ASSUME_NONNULL_END
