//
//  TagManagerViewController.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "XMPopupBaseViewController.h"

@protocol TagSelectionItemDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface TagManagerViewController : XMPopupBaseViewController

@property (nonatomic, copy) XMBlock tagsDidChangeBlock;

- (instancetype)initWithItems:(NSArray<id<TagSelectionItemDelegate>> *)items;

@end

NS_ASSUME_NONNULL_END
