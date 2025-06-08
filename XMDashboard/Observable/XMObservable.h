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

NS_ASSUME_NONNULL_BEGIN

typedef void(^XMObservableCallback)(id _Nullable newValue, id _Nullable oldValue);

// objective-c实际上是伪泛型，本质上是一种注释
// 不能在类的实现里直接写 ValueType，也不能定义 block 的参数类型为 ValueType
@interface XMObservable<ValueType> : NSObject

// 不能给值初始化，不然initBlock无法生效，而且语义不明确
+ (instancetype)strongObservable;
+ (instancetype)copyObservable;

- (instancetype)init NS_UNAVAILABLE;

// 注意：首次赋值的时候willChangeBlock会在initBlock之前调用
- (void)addObserver:(id)observer
           forEvent:(XMObservableEventType)type
           callback:(XMObservableCallback)block;
- (void)addObserver:(id)observer
           callback:(XMObservableCallback)block;
- (void)xm_setValue:(ValueType)value;
- (ValueType)xm_getValue;

@end

NS_ASSUME_NONNULL_END
