//
//  TagManagerCollectionViewCell.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagManagerCollectionViewCell : UICollectionViewCell

- (void)updateWithItemName:(NSString *)name font:(UIFont *)font deleted:(BOOL)deleted;

@end

NS_ASSUME_NONNULL_END
