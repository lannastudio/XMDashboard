//
//  DashboardInfoModel.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardModel.h"
#import <MJExtension/MJExtension.h>

@implementation DashboardModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"appInfo": @"appInfo",
        @"userInfo": @"userInfo",
        @"billInfo": @"billInfo",
        @"entityInfo": @"entityInfoDTO",
        @"adsInfo": @"adsInfoDTO",
        @"recordInfo": @"recordDTO",
        @"loginOutInfo": @"loginOutDTO",
        @"rateInfo": @"rateDTO",
        @"pageInfo": @"pageInfoDTO"
    };
}

- (NSArray *)sectionItems {
    NSMutableArray *array = [NSMutableArray array];
    if (self.appInfo)         [array addObject:self.appInfo];
    if (self.userInfo)        [array addObject:self.userInfo];
    if (self.billInfo)        [array addObject:self.billInfo];
    if (self.entityInfo)      [array addObject:self.entityInfo];
    if (self.adsInfo)         [array addObject:self.adsInfo];
    if (self.recordInfo)      [array addObject:self.recordInfo];
    if (self.loginOutInfo)    [array addObject:self.loginOutInfo];
    if (self.rateInfo)        [array addObject:self.rateInfo];
    if (self.pageInfo)        [array addObject:self.pageInfo];
    return [array copy];
}

@end
