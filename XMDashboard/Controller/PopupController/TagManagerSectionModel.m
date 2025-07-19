//
//  TagSelectionSectionModel.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "TagManagerSectionModel.h"
#import "TagSelectionItem.h"
#import <IGListKit/IGListKit.h>

@interface TagManagerSectionModel () <IGListDiffable>

@end

@implementation TagManagerSectionModel

- (id<NSObject>)diffIdentifier {
    NSMutableString *identifier = [NSMutableString string];
    [_items xm_each:^(TagSelectionItem *item) {
        [identifier appendString:item.name];
    }];
    return identifier.copy;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (self == object) return YES;
    return [[self diffIdentifier] isEqual:[object diffIdentifier]];
}

@end
