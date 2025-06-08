//
//  NSArray+XMExtension.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (XMExtension)

- (void)xm_each:(void (^)(id obj))block;
- (id)xm_match:(BOOL (^)(id obj))block;
- (NSArray *)xm_select:(BOOL (^)(id obj))block;
- (NSArray *)xm_map:(id (^)(id obj))block;
- (NSArray *)xm_safe_map:(id (^)(id obj))block;

@end

NS_ASSUME_NONNULL_END
