//
//  NSString+CalculateTextSize.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "NSString+CalculateTextSize.h"

@implementation NSString (CalculateTextSize)

- (CGSize)calculateWithFont:(UIFont *)font {
    return [self calculateWithMaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:font];
}

- (CGSize)calculateWithMaxSize:(CGSize)size font:(UIFont *)font {
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    CGFloat width = ceil(rect.size.width);
    CGFloat height = ceil(rect.size.height);
    return CGSizeMake(width, height);
}

@end
