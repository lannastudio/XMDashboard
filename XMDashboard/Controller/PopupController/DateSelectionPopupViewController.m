//
//  DateSelectionPopupViewController.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/6.
//

#import "DateSelectionPopupViewController.h"
#import "UIViewController+XMContainer.h"
#import "XMAnimationButton.h"
#import <DateTools/DateTools.h>

#define XM_MONTH_REPEAT 100
#define XM_MONTH_COUNT 12

@interface DateSelectionPopupViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) UIPickerView *pickerView;
@property (nonatomic, strong) XMAnimationButton *cancelButton;
@property (nonatomic, strong) XMAnimationButton *doneButton;
@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSArray<NSNumber *> *years;

@end

@implementation DateSelectionPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _commonInit];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat width = self.containerView.width - 100;
    CGFloat height = self.containerView.height - 50;
    _pickerView.frame = CGRectMake(50, 0, width, height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _selectedDate = _selectedDate ?: [NSDate date];
        [self _setYear:_selectedDate.year month:_selectedDate.month animated:NO];
    });
}

+ (instancetype)showWithContainer:(UIViewController *)container selectedDate:(NSDate *)selectedDate {
    DateSelectionPopupViewController *popupController = [[DateSelectionPopupViewController alloc] init];
    popupController.container = container;
    
    WEAK_OBJ_REF(container);
    [container xm_addChildController:popupController layoutViews:^(UIView *view) {
        view.frame = weak_container.view.bounds;
    }];
    [popupController appearWithAnimation];
    [popupController setSelectedDate:selectedDate];
    [popupController _setYear:selectedDate.year month:selectedDate.month animated:NO];
    return popupController;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) return self.years.count;
    return XM_MONTH_COUNT * XM_MONTH_REPEAT;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
           attributedTitleForRow:(NSInteger)row
                    forComponent:(NSInteger)component {
    NSString *title = nil;
    if (component == 0) {
        title = [NSString stringWithFormat:@"%ld年", (long)self.years[row].integerValue];
    } else {
        NSInteger month = row % XM_MONTH_COUNT + 1;
        title = [NSString stringWithFormat:@"%02ld月", (long)month];
    }

    UIColor *color = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:18];

    NSInteger selectedRow = [pickerView selectedRowInComponent:component];
    if (row == selectedRow) {
        color = [UIColor blackColor];
        font = [UIFont boldSystemFontOfSize:18];
    } else {
        color = [UIColor darkGrayColor];
        font = [UIFont systemFontOfSize:18];
    }

    NSDictionary *attrs = @{
        NSForegroundColorAttributeName: color,
        NSFontAttributeName: font
    };
    return [[NSAttributedString alloc] initWithString:title attributes:attrs];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 1) {
        NSInteger current = [pickerView selectedRowInComponent:1];
        NSInteger month = current % XM_MONTH_COUNT + 1;
        NSInteger middle = XM_MONTH_COUNT * (XM_MONTH_REPEAT/2) + (month-1);
        if (current != middle) {
            [pickerView selectRow:middle inComponent:1 animated:NO];
        }
    }
    NSInteger year = self.years[[pickerView selectedRowInComponent:0]].integerValue;
    NSInteger month = ([pickerView selectedRowInComponent:1] % XM_MONTH_COUNT) + 1;
    NSDate *date = [NSDate dateWithYear:year month:month day:1];
    _selectedDate = date;
}

#pragma mark - private

- (void)_commonInit {
    _minYear = 1970;
    _maxYear = 2070;
    NSMutableArray *years = [NSMutableArray array];
    for (NSInteger y = _minYear; y <= _maxYear; y++) {
        [years addObject:@(y)];
    }
    _years = years.copy;

    _pickerView = [[UIPickerView alloc] init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self.containerView addSubview:_pickerView];

    [self.containerView addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_centerX).offset(10);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.width.equalTo(@132);
        make.height.equalTo(@38);
    }];

    [self.containerView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_centerX).offset(-10);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.width.equalTo(@132);
        make.height.equalTo(@38);
    }];
}

- (void)_setYear:(NSInteger)year month:(NSInteger)month animated:(BOOL)animated {
    NSInteger yearIndex = [self.years indexOfObject:@(year)];
    if (yearIndex == NSNotFound) yearIndex = 0;
    [_pickerView selectRow:yearIndex inComponent:0 animated:animated];
    NSInteger base = XM_MONTH_COUNT * (XM_MONTH_REPEAT/2);
    [_pickerView selectRow:base + (month - 1) inComponent:1 animated:animated];
}

- (void)_cancel:(XMAnimationButton *)sender {
    [self disappearWithAnimation];
}

- (void)_done:(XMAnimationButton *)sender {
    SafeBlock(self.onDateChangedBlock, self.selectedDate);
    [self disappearWithAnimation];
}

#pragma mark - getter

- (XMAnimationButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [self _commonButton];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (XMAnimationButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [self _commonButton];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(_done:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (XMAnimationButton *)_commonButton {
    XMAnimationButton *button = [[XMAnimationButton alloc] init];
    [button setTitleColor:XMWhiteColor forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 8;
    button.backgroundColor = XMBlackColor;
    button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    return button;
}

@end
