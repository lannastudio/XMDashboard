//
//  CollectionUtil.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "CollectionUtil.h"

@implementation CollectionUtil

+ (BOOL (^)(id collection))isEmpty {
    return ^BOOL(id collection) {
        if (!collection) {
            return YES;
        }

        if (![collection respondsToSelector:@selector(count)]) {
            return NO;
        }

        return [collection count] == 0;
    };
}

+ (BOOL (^)(id collection))isNotEmpty {
    return ^BOOL(id collection) {
        return ![self isEmpty](collection);
    };
}

@end
