//
//  NSMutableArray+Safe.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)

- (void)safe_addObject:(id)object {
    if (object != nil) {
        [self addObject:object];
    } else {
        XMLog(@"[NSMutableArray (Safe)] Trying to add a nil object");
    }
}

- (void)safe_insertObject:(id)object atIndex:(NSUInteger)index {
    if (object != nil && index <= self.count) {
        [self insertObject:object atIndex:index];
    } else {
        XMLog(@"[NSMutableArray (Safe)] Trying to insert a nil object or index out of bounds");
    }
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    } else {
        XMLog(@"[NSMutableArray (Safe)] Trying to remove object at an invalid index");
    }
}

- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    } else {
        XMLog(@"[NSMutableArray (Safe)] Trying to access object at an invalid index");
        return nil;
    }
}

- (id)safe_firstObject {
    if (self.count > 0) {
        return [self objectAtIndex:0];
    } else {
        XMLog(@"[NSMutableArray (Safe)] Trying to access first object in an empty array");
        return nil;
    }
}

- (id)safe_lastObject {
    if (self.count > 0) {
        return [self lastObject];
    } else {
        XMLog(@"[NSMutableArray (Safe)] Trying to access last object in an empty array");
        return nil;
    }
}

- (void)safe_removeObject:(id)object {
    if (object && [self containsObject:object]) {
        [self removeObject:object];
    }
}

- (void)safe_removeLastObject {
    if (self.count > 0) {
        [self removeLastObject];
    }
}

@end
