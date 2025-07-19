//
//  DashboardBaseCollectionViewCell.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/2.
//

#import "DashboardBaseCollectionViewCell.h"

@interface DashboardBaseCollectionViewCell ()

@property (nonatomic, strong) UILabel *dataUncompleteLabel;

@end

@implementation DashboardBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XMClearColor;
        self.contentView.backgroundColor = XMWhiteColor;

        _dataUncompleteLabel = [[UILabel alloc] init];
        _dataUncompleteLabel.text = @"该数据不准确";
        _dataUncompleteLabel.textColor = XMRGBColor(169, 169, 169);
        _dataUncompleteLabel.hidden = YES;
        [self.contentView addSubview:_dataUncompleteLabel];
        [_dataUncompleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-5);
            make.right.equalTo(self.contentView).offset(-5);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [self.contentView kt_addRoundCornerWithCornerRadius:12];
}

@end
