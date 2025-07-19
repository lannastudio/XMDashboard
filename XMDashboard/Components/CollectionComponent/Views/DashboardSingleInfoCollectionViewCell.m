//
//  DashboardSingleInfoCollectionViewCell.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardInfo.h"
#import "DashboardSingleInfoCollectionViewCell.h"

@implementation DashboardSingleInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

#pragma mark - public

- (void)updateWithInfo:(DashboardInfo *)info {
    [self updateWithInfo:info position:DashboardCellPositionSingle];
}

#pragma mark - private

- (void)_commonInit {
    self.backgroundColor = XMClearColor;
    self.contentView.backgroundColor = XMWhiteColor;

    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(18);
    }];

    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(18);
    }];

    self.infoLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:55];
}

@end
