//
//  TagManagerSectionController.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagManagerSectionController : IGListSectionController

@property (nonatomic, copy) void(^userDidClickCellBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void(^didMoveBlock)(NSInteger fromIndex, NSInteger toIndex);

@end

NS_ASSUME_NONNULL_END
