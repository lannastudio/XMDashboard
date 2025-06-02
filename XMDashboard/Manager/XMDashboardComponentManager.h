//
//  XMDashboardComponentManager.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardComponentManager : NSObject

@property (nonatomic, copy) KTBlock requestWillBeginBlock;
@property (nonatomic, copy) void(^requestDidEndBlock)(NSError *error);

- (void)triggerEvent:(SEL)selector;
- (NSArray *)allComponents;
- (void)reloadAllComponents;

// 工程化，易拓展，项目复杂化后可动态调整order
- (instancetype)initWithOrder:(NSArray<NSString *> *)order;

@end

NS_ASSUME_NONNULL_END
