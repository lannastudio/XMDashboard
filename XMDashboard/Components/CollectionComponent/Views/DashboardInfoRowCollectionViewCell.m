//
//  DashboardInfoRowCollectionViewCell.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardCellAnimationDelegate.h"
#import "DashboardInfo.h"
#import "DashboardInfoRowCollectionViewCell.h"

@interface DashboardInfoRowCollectionViewCell () <DashboardCellAnimationDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, assign) DashboardCellPosition position;

@end

@implementation DashboardInfoRowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self _updateCorner];
}

#pragma mark - public

- (void)updateWithInfo:(DashboardInfo *)info position:(DashboardCellPosition)position {
    self.nameLabel.text = info.name;
    self.infoLabel.text = info.info;

    self.position = position;
}

- (void)showAppearAnimation {
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentView.backgroundColor = XMRGBAColor(0, 0, 0, 0.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentView.backgroundColor = XMWhiteColor;
        } completion:nil];
    }];
}

#pragma mark - private

- (void)_commonInit {
    self.backgroundColor = XMClearColor;
    self.contentView.backgroundColor = XMWhiteColor;

    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(18);
    }];

    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
    }];


    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tapGesture];
}


- (void)_handleGesture:(UITapGestureRecognizer *)gesture {
    NSLog(@"%@", gesture);
}


- (void)_updateCorner {
    UIRectCorner rectCorner = UIRectCornerAllCorners;
    CGSize cornerSize = CGSizeMake(14, 14);

    switch (_position) {
        case DashboardCellPositionFirst: {
            rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight;
        } break;
        case DashboardCellPositionLast: {
            rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        } break;
        case DashboardCellPositionMiddle: {
            cornerSize = CGSizeZero;
        } break;
        default: break;
    }

    [self.contentView kt_addCornerRadius:rectCorner
                          withRadiusSize:cornerSize
                                viewRect:self.contentView.bounds];
}

#pragma mark - getter

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = KTRGBColor(66, 66, 66);
        _infoLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:17];
    }
    return _infoLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = KTRGBColor(121, 121, 121);
        _nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _nameLabel;
}

@end
