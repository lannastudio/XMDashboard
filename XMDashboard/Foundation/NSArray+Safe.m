//
//  NSArray+Safe.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)safe_objectAtIndex:(NSInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    } else {
        NSLog(@"[NSArray (Safe)] Trying to access object at an invalid index");
        return nil;
    }
}

- (id)safe_firstObject {
    if (self.count > 0) {
        return [self objectAtIndex:0];
    } else {
        NSLog(@"[NSArray (Safe)] Trying to access first object in an empty array");
        return nil;
    }
}

- (id)safe_lastObject {
    if (self.count > 0) {
        return [self lastObject];
    } else {
        NSLog(@"[NSArray (Safe)] Trying to access last object in an empty array");
        return nil;
    }
}

@end
