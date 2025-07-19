//
//  XMDashboardViewModel.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/19.
//

#import "DashboardModel.h"
#import "DashboardSection.h"
#import "DashboardSectionManager.h"
#import "XMDashboardViewModel.h"
#import "XMNetworkingManager.h"
#import <MJExtension/MJExtension.h>

static NSString * const kDashboardRequestPath = @"/api/events/dashboard";

@interface XMDashboardViewModel ()

@property (nonatomic, strong) XMObservable<NSDate *> *selectedDate;
@property (nonatomic, strong) XMObservable<NSArray *> *dashboardInfoList;
@property (nonatomic, strong) XMObservable<NSArray *> *orderedOriginalItems;
@property (nonatomic, assign, getter=isPerformingUpdate) BOOL performingUpdate;

@end

@implementation XMDashboardViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedDate = [XMObservable strongObservable];
        _dashboardInfoList = [XMObservable copyObservable];
        _orderedOriginalItems = [XMObservable copyObservable];
        _orderedOriginalItems.debounceTimeInterval = 0;

        WS
        [_orderedOriginalItems addObserver:self callback:^(id newValue, id oldValue) {
            [weak_self _updateDashboardSectionItems];
        }];
    }
    return self;
}

- (void)requestWithCompletion:(void (^)(NSError *))completion {
    self.performingUpdate = YES;
    [XMNetworkingManager requestWithPath:kDashboardRequestPath
                                  params:@{@"password": @123}
                              completion:^(id respone, BaseResponseObject *responseObject, NSError *error) {
        if (responseObject.code == CommonResponseResultSuccess) {
            DashboardModel *model = [DashboardModel mj_objectWithKeyValues:responseObject.data];
            [self _updateOrderedOriginalItems:model.sectionItems];
        }
        self.performingUpdate = NO;
        SafeBlock(completion, error);
    }];
}

- (id<XMObservableReadonly>)selectedDateObservable {
    return _selectedDate;
}

- (id<XMObservableReadonly>)dashboardInfoListObservable {
    return _dashboardInfoList;
}

- (id<XMObservableReadonly>)orderedOriginalItemsObservable {
    return _orderedOriginalItems;
}

- (void)updateWhenItemsDidReorder {
    [self _updateOrderedOriginalItems:_orderedOriginalItems.xm_getValue];
}

#pragma mark - private

- (void)_updateOrderedOriginalItems:(NSArray *)items {
    NSArray *cache = [DashboardSectionManager sortedItemsWithOrderCache:items];
    [self.orderedOriginalItems xm_setValue:cache];
}

- (void)_updateDashboardSectionItems {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *orderedItems = _orderedOriginalItems.xm_getValue;

    for (id object in orderedItems) {
        if ([object conformsToProtocol:@protocol(DashboardSectionDelegate)]) {
            DashboardSection *section = [object dashboardSection];
            [result addObject:section];
        }
        [result addObject:object];
    }

    [self.dashboardInfoList xm_setValue:result];
}

@end
