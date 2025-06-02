//
//  NSMutableArray+Safe.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Safe)

- (void)safe_addObject:(id)object;
- (void)safe_insertObject:(id)object atIndex:(NSUInteger)index;
- (void)safe_removeObjectAtIndex:(NSUInteger)index;
- (id)safe_objectAtIndex:(NSUInteger)index;
- (id)safe_firstObject;
- (id)safe_lastObject;
- (void)safe_removeObject:(id)object;
- (void)safe_removeLastObject;

@end

NS_ASSUME_NONNULL_END
