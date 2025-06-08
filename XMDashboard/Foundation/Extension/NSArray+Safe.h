//
//  NSArray+Safe.h
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Safe)

- (id)safe_objectAtIndex:(NSInteger)index;
- (id)safe_firstObject;
- (id)safe_lastObject;

@end

NS_ASSUME_NONNULL_END
