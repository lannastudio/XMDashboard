//
//  XMDashboardScrollEvent.h
//  XMDashboard
//
//  Created by lannastudio on 2025/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMDashboardScrollEvent : NSObject

@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) BOOL isDragging;

@end

NS_ASSUME_NONNULL_END
