//
//  NSNumber+FormatterString.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "NSNumber+FormatterString.h"

@implementation NSNumber (FormatterString)

- (NSString *)xm_decimalStringWithMax2Digits {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    // 保证去除无效的0
    formatter.minimumIntegerDigits = 1;
    return [formatter stringFromNumber:self];
}

@end
