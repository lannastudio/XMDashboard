//
//  NSDate+XMDisplay.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/30.
//

#import "NSDate+XMDisplay.h"
#import <DateTools/DateTools.h>

@implementation NSDate (XMDisplay)

- (NSString *)xm_toYMDString {
    return [NSString stringWithFormat:@"%lu-%lu-%lu", self.year, self.month, self.day];
}

- (NSString *)xm_toYMString {
    return [NSString stringWithFormat:@"%ld-%02ld", self.year, self.month];
}

@end
