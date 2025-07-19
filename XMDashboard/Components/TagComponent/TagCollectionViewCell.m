//
//  TagCollectionViewCell.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "TagCollectionViewCell.h"
#import "TagSelectionItem.h"
#import "TagSelectionViewModel.h"

@interface TagCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation TagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XMClearColor;
        self.contentView.backgroundColor = XMRGBColor(235, 235, 235);

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = XMRGBColor(66, 66, 66);
        _nameLabel.font = [TagSelectionViewModel tagFont];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView kt_addRoundCornerWithCornerRadius:self.contentView.height/2];
}

#pragma mark - public

- (void)updateWithItem:(TagSelectionItem *)item {
    self.nameLabel.text = item.name;
}

@end
