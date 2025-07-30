//
//  DashboardSectionManager.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "DashboardModel.h"
#import "DashboardSectionManager.h"
#import "TagSelectionItem.h"

static NSString * kDashboardSectionUserDefaultsKey = @"com.lannastudio.dashboard.kDashboardSectionUserDefaultsKey";
static NSString * kDashboardBlockedItemsUserDefaultsKey = @"com.lannastudio.dashboard.kDashboardBlockedItemsUserDefaultsKey";

@implementation DashboardSectionManager

+ (NSArray *)sortedItemsWithOrderCache:(NSArray *)items {
    NSArray *cache = [self cachedItems];
    if (!cache) {
        return items;
    }

    NSMutableArray *result = [NSMutableArray array];
    for (NSString *classString in cache) {
        Class modelClass = NSClassFromString(classString);
        for (id item in items) {
            if ([item isKindOfClass:modelClass]) {
                [result addObject:item];
            }
        }
    }
    return result;
}

+ (void)cacheItems:(NSArray *)items {
    [[NSUserDefaults standardUserDefaults] setObject:[self _itemsToClassString:items] forKey:kDashboardSectionUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)cachedItems {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDashboardSectionUserDefaultsKey];
}

+ (NSArray *)blockedComponentItems {
    NSArray *blockedItems = [[NSUserDefaults standardUserDefaults] objectForKey:kDashboardBlockedItemsUserDefaultsKey];
    return blockedItems ?: @[];
}

+ (void)blockComponentItems:(NSArray *)items {
    [[NSUserDefaults standardUserDefaults] setObject:[self _itemsToClassString:items] forKey:kDashboardBlockedItemsUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)_itemsToClassString:(NSArray *)items {
    return [items xm_map:^id (TagSelectionItem *item) {
        return item.modelClassString;
    }];
}

@end
