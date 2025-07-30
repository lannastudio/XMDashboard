//
//  DashboardComponentService.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/30.
//

#import "DashboardServiceComponent.h"
#import "DateSelectionPopupViewController.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardViewModel.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation DashboardServiceComponent

- (void)showDateSelectionPopupViewController {
    WS
    NSDate *date = self.context.dashboardViewModel.selectedDateObservable.xm_getValue;
    DateSelectionPopupViewController *selectionController = [DateSelectionPopupViewController showWithContainer:self.context
                                                                                                   selectedDate:date];
    selectionController.onDateChangedBlock = ^(NSDate *date) {
        [MBProgressHUD showHUDAddedTo:weak_self.context.view animated:YES];
        [weak_self.context.dashboardViewModel updateSelectedDate:date completion:^{
            [MBProgressHUD hideHUDForView:weak_self.context.view animated:YES];
        }];
    };
}

@end

@implementation DashboardServiceComponent (ComponentDelegate)

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

+ (NSString *)xm_identifier {
    return NSStringFromClass(self);
}

@end
