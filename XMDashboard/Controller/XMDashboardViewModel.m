//
//  XMDashboardViewModel.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/19.
//

#import "XMDashboardViewModel.h"

@interface XMDashboardViewModel ()

@property (nonatomic, strong) XMObservable<NSDate *> *selectedDate;

@end

@implementation XMDashboardViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedDate = [XMObservable strongObservable];
    }
    return self;
}

- (void)requestWithCompletion:(void (^)(NSError *))completion {

}

@end
