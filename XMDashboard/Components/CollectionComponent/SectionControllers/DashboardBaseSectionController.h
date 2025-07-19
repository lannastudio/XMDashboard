//
//  DashboardBaseSectionController.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface DashboardBaseSectionController : IGListSectionController

@property (nonatomic, assign, readonly) UIEdgeInsets sectionInsets;

- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
