//
//  DashboardSectionTitleCollectionViewCell.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/4.
//

#import "DashboardSectionTitleCollectionViewCell.h"

@interface DashboardSectionTitleCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation DashboardSectionTitleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XMClearColor;
        self.contentView.backgroundColor = XMClearColor;

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = XMRGBColor(145, 145, 145);
        _nameLabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightSemibold];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)updateWithTitle:(NSString *)title {
    self.nameLabel.text = title;
}

@end
