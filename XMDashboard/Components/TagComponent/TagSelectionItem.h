//
//  TagSelectionItem.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TagSelectionItemDelegate <NSObject>

- (NSString *)tagName;

@end

@interface TagSelectionItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *modelClassString;

- (instancetype)initWithTagSelectionDelegate:(id<TagSelectionItemDelegate>)itemDelegate;

@end

NS_ASSUME_NONNULL_END
