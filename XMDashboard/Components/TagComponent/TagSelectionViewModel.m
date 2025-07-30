//
//  TagSelectionViewModel.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "DashboardSectionManager.h"
#import "NSString+CalculateTextSize.h"
#import "TagSelectionItem.h"
#import "TagSelectionViewModel.h"
#import "XMObservable.h"

@interface TagSelectionViewModel ()

@property (nonatomic, strong) XMObservable<NSArray<TagSelectionItem *> *> *tagSectionItems;

@end

@implementation TagSelectionViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tagSectionItems = [XMObservable copyObservable];
    }
    return self;
}

- (void)updateItemsWithOrderedItems:(NSArray *)orderedItems {
    NSMutableArray *result = [NSMutableArray array];

    for (id dashboardModel in orderedItems) {
        if ([dashboardModel conformsToProtocol:@protocol(TagSelectionItemDelegate)]) {
            TagSelectionItem *item = [[TagSelectionItem alloc] initWithTagSelectionDelegate:dashboardModel];
            [result addObject:item];
        }
    }
    [self _updateTextSizes:result];
    [self.tagSectionItems xm_setValue:result];
}

- (id<XMObservableReadonly>)tagItemsObservable {
    return _tagSectionItems;
}

+ (UIFont *)tagFont {
    return [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
}

- (void)reorderItems:(NSArray *)items {
    [DashboardSectionManager cacheItems:items];

    SafeBlock(self.didReorderItemsBlock);
}

#pragma mark - private

- (void)_updateTextSizes:(NSArray<TagSelectionItem *> *)items {
    NSMutableArray *sizes = [NSMutableArray array];

    for (TagSelectionItem *item in items) {
        UIFont *font = [self.class tagFont];
        CGSize size = [item.name calculateWithFont:font];
        [sizes addObject:[NSValue valueWithCGSize:CGSizeMake(size.width + 18, size.height+12)]];
    }
    self.textSizes = [sizes copy];
}

@end
