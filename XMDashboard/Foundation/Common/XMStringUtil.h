//
//  XMStringUtil.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMStringUtil : NSObject

+ (BOOL (^)(NSString *string))isNotBlank;
+ (BOOL (^)(NSString *string))isBlank;

@end

NS_ASSUME_NONNULL_END
