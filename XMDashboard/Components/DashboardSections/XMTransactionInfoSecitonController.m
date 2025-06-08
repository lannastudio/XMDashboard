//
//  XMTransactionInfoSecitonController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/6/4.
//

#import "XMTransactionInfoSecitonController.h"
#import <IGListKit/IGListKit.h>

@interface XMTransactionInfoSecitonController ()

@property (nonatomic, strong) NSNumber *data;

@end

@implementation XMTransactionInfoSecitonController

- (NSInteger)numberOfItems {
    return 6;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 55);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:UICollectionViewCell.class forSectionController:self atIndex:index];
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UILabel *label = [cell.contentView viewWithTag:999];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.tag = 999;
        label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"内容Cell %@", _data];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    _data = object;
}

@end
