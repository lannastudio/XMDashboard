//
//  TagSelectionViewModel.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "TagSectionControllerDataSource.h"
#import <Foundation/Foundation.h>

@protocol XMObservableReadonly;

NS_ASSUME_NONNULL_BEGIN

@interface TagSelectionViewModel : NSObject <TagSelectionControllerDataSource>

@property (nonatomic, copy) NSArray<NSValue *> *textSizes;
@property (nonatomic, copy) XMBlock didReorderItemsBlock;

- (void)updateItemsWithOrderedItems:(NSArray *)orderedItems;
- (id<XMObservableReadonly>)tagItemsObservable;

- (void)reorderItems:(NSArray *)items;

+ (UIFont *)tagFont;

@end

NS_ASSUME_NONNULL_END
