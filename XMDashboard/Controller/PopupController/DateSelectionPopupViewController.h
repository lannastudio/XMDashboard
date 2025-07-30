//
//  DateSelectionPopupViewController.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "XMPopupBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DateSelectionPopupViewController : XMPopupBaseViewController

@property (nonatomic, copy) void (^onDateChangedBlock)(NSDate *date);

+ (instancetype)showWithContainer:(UIViewController *)container
                     selectedDate:(NSDate *)selectedDate;

@end

NS_ASSUME_NONNULL_END
