//
//  TestObject.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/7.
//

#import "TestObject.h"

@implementation TestBaseObject

+ (void)initialize
{
    NSLog(@"%@", self);
}

@end

@interface TestObject ()

@property (nonatomic, assign) NSInteger age;

@end

@implementation TestObject

+ (void)initialize {
    XMLog(@"%@", self);
}

- (void)updateAge:(NSInteger)age {
    self.age = age;
}

@end
