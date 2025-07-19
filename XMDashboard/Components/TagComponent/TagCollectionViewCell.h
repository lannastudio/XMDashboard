//
//  TagCollectionViewCell.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import <UIKit/UIKit.h>

@class TagSelectionItem;

NS_ASSUME_NONNULL_BEGIN

@interface TagCollectionViewCell : UICollectionViewCell

- (void)updateWithItem:(TagSelectionItem *)item;

@end

NS_ASSUME_NONNULL_END
