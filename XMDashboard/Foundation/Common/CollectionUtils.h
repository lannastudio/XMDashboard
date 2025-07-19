//
//  CollectionUtil.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionUtils : NSObject

+ (BOOL (^)(id collection))isEmpty;
+ (BOOL (^)(id collection))isNotEmpty;

@end

NS_ASSUME_NONNULL_END
