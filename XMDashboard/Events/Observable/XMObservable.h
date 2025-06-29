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

/**
 @class XMObservable
 @brief 适用于ViewController单向数据流场景的数据绑定工具
 */
@interface XMObservable<ValueType> : NSObject

// default YES
@property (nonatomic, assign) BOOL callbackOnMainThread;

- (instancetype)initWithPolicy:(XMObservableValuePolicy)policy NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)strongObservable;
+ (instancetype)copyObservable;

// 注意：首次赋值的时候willChangeBlock会在initBlock之前调用
- (void)addObserver:(id)observer
           forEvent:(XMObservableEventType)type
           callback:(XMObservableCallback)block;
- (void)addObserver:(id)observer
           callback:(XMObservableCallback)block;
- (void)removeObserver:(id)observer forEvent:(XMObservableEventType)type;
// objective-c实际上是伪泛型，本质上是一种注释
// 不能在类的实现里直接写 ValueType，也不能定义 block 的参数类型为 ValueType
- (void)xm_setValue:(ValueType)value;
- (ValueType)xm_getValue;

@end

NS_ASSUME_NONNULL_END
