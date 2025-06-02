//
//  NSArray+XMExtension.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "NSArray+XMExtension.h"

@implementation NSArray (XMExtension)

- (void)xm_each:(void (^)(id obj))block {
    NSParameterAssert(block != nil);

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (id)xm_match:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);

    __block id found = nil;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) {
            found = obj;
            *stop = YES;
        }
    }];
    return found;
}

- (NSArray *)xm_select:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);

    NSMutableArray *array = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (NSArray *)xm_map:(id (^)(id obj))block {
    NSParameterAssert(block != nil);

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id newObj = block(obj);
        if (newObj) {
            [array addObject:newObj];
        } else {
            [array addObject:[NSNull null]];
        }
    }];
    return array;
}

- (NSArray *)xm_safe_map:(id  _Nonnull (^)(id obj))block {
    NSParameterAssert(block != nil);

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id newObj = block(obj);
        [array safe_addObject:newObj];
    }];
    return array;
}

@end
