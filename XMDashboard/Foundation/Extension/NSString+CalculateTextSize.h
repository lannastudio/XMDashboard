//
//  NSString+CalculateTextSize.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CalculateTextSize)

- (CGSize)calculateWithMaxSize:(CGSize)size font:(UIFont *)font;
- (CGSize)calculateWithFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
