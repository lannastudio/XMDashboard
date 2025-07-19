//
//  DashboardInfo.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import <Foundation/Foundation.h>
#import "NSNumber+FormatterString.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, strong, readonly) NSNumberFormatter *formatter;

- (instancetype)initWithName:(NSString *)name info:(NSString *)info;

@end

@interface DashboardInfo (StringFormatter)

+ (NSString *)percentString:(double)value;

@end

NS_ASSUME_NONNULL_END
