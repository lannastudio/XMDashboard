//
//  XMStringUtil.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMStringUtil.h"

@implementation XMStringUtil

+ (BOOL (^)(NSString *string))isNotBlank {
    return ^BOOL(NSString *string) {
        // 确保字符串非 nil 且非空
        return (string && ![string isKindOfClass:[NSNull class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0);
    };
}

+ (BOOL (^)(NSString *string))isBlank {
    return ^BOOL(NSString *string) {
        return !XMStringUtil.isNotBlank(string);
    };
}

@end
