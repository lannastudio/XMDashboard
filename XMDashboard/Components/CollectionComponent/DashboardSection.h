//
//  DashboardSection.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import <Foundation/Foundation.h>

@class DashboardInfo, DashboardSection;

NS_ASSUME_NONNULL_BEGIN

@protocol DashboardSectionDelegate <NSObject>

- (DashboardSection *)dashboardSection;

@end

@interface DashboardSection : NSObject

@property (nonatomic, copy) NSString *title;

+ (instancetype)sectionWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
