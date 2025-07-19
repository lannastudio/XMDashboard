//
//  UIView+Toast.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Toast)

- (void)showToastWithText:(NSString *)text;

+ (void)swizzleHitTest;

@end

NS_ASSUME_NONNULL_END
