//
//  TagManagerCollectionViewCell.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "TagManagerCollectionViewCell.h"
#import "UIView+Corner.h"
#import "XMExtensionButton.h"

@interface TagManagerCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) XMExtensionButton *toggleButton;

@end

@implementation TagManagerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = KTRGBColor(66, 66, 66);
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(6);
        }];

        _toggleButton = [[XMExtensionButton alloc] init];
        [self.contentView addSubview:_toggleButton];
        [_toggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-2-1);
            make.width.height.equalTo(self.contentView.mas_height);
        }];

        self.backgroundColor = XMClearColor;
        self.contentView.backgroundColor = XMRGBColor(245, 245, 245);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView kt_addRoundCornerWithCornerRadius:12];
}

#pragma mark - public

- (void)updateWithItemName:(NSString *)name
                      font:(UIFont *)font
                   deleted:(BOOL)deleted {
    self.nameLabel.text = name;
    self.nameLabel.font = font;
    self.toggleButton.tintColor = deleted ? [UIColor systemYellowColor] : [UIColor systemRedColor];
    UIImage *image = deleted ? [UIImage systemImageNamed:@"plus.circle"] : [UIImage systemImageNamed:@"minus.circle"];
    [self.toggleButton setImage:image forState:UIControlStateNormal];
}

@end
