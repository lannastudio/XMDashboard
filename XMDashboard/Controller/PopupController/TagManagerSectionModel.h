//
//  TagSelectionSectionModel.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagManagerSectionModel : NSObject

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic,   copy) NSArray *itemSizes;
@property (nonatomic, strong) UIFont *cellFont;

@end

NS_ASSUME_NONNULL_END
