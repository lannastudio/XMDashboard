//
//  TagSelectionItem.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "TagSelectionItem.h"
#import <IGListKit/IGListKit.h>

@interface TagSelectionItem () <IGListDiffable>

@end

@implementation TagSelectionItem

- (instancetype)initWithTagSelectionDelegate:(id<TagSelectionItemDelegate>)itemDelegate {
    self = [super init];
    if (self) {
        _name = itemDelegate.tagName;
        _modelClassString = NSStringFromClass(itemDelegate.class);
    }
    return self;
}

- (id<NSObject>)diffIdentifier {
    return [[NSString alloc] initWithFormat:@"%@ %@", self.name, self.modelClassString];
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return self == object ? YES : [[self diffIdentifier] isEqual:[object diffIdentifier]];
}

@end
