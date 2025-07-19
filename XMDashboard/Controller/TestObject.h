//
//  TestObject.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestBaseObject : NSObject

@end

@interface TestObject : TestBaseObject

- (void)updateAge:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
