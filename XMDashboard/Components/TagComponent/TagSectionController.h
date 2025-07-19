//
//  TagSectionController.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import <IGListKit/IGListKit.h>

@class TagSelectionItem;
@protocol TagSelectionControllerDataSource;

NS_ASSUME_NONNULL_BEGIN

@interface TagSectionController : IGListSectionController

@property (nonatomic, copy) void(^selectItemBlock)(TagSelectionItem *item);

- (instancetype)initWithDataSource:(id<TagSelectionControllerDataSource>)dataSource;

@end

NS_ASSUME_NONNULL_END
