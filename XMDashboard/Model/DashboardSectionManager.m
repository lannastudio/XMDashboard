//
//  DashboardSectionManager.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "DashboardSectionManager.h"
#import "DashboardModel.h"

static NSString * kDashboardSectionUserDefaultsKey = @"com.lannastudio.dashboard.kDashboardSectionUserDefaultsKey";
static NSString * kDashboardBlockedItemsUserDefaultsKey = @"com.lannastudio.dashboard.kDashboardBlockedItemsUserDefaultsKey";

@implementation DashboardSectionManager

+ (NSArray *)sortedItemsWithOrderCache:(NSArray *)items {
    NSArray *cache = [self cacheSections];
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
    [[NSUserDefaults standardUserDefaults] setValue:items forKey:kDashboardSectionUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)cacheSections {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kDashboardSectionUserDefaultsKey];
}

+ (NSArray *)blockedComponentItems {
    NSArray *blockedItems = [[NSUserDefaults standardUserDefaults] valueForKey:kDashboardBlockedItemsUserDefaultsKey];
    return blockedItems ?: @[];
}

+ (void)blockComponentItems:(NSArray *)items {
    if (CollectionUtils.isEmpty(items)) {
        return;
    }
    NSArray *blockedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kDashboardBlockedItemsUserDefaultsKey];

    NSMutableSet *set = blockedItems ? [NSMutableSet setWithArray:blockedItems] : [NSMutableSet set];
    [set addObjectsFromArray:items];

    [[NSUserDefaults standardUserDefaults] setObject:[set allObjects] forKey:kDashboardBlockedItemsUserDefaultsKey];
}

@end
