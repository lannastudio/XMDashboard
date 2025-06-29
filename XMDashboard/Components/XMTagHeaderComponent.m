//
//  XMTransactionCountComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import "XMComponentConstants.h"
#import "XMDashboardComponentEventName.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardDecelerateEvent.h"
#import "XMDashboardScrollEvent.h"
#import "XMEventBus.h"
#import "XMTagHeaderComponent.h"

@interface XMTagHeaderComponent ()

@property (nonatomic, strong) UICollectionView *tagCollectionView;

@property (nonatomic,   weak) XMEventBus *eventBus;
@property (nonatomic, assign) CGFloat tagHeaderHeight;
@property (nonatomic, assign) BOOL isAnimatingHeader;

@end

@implementation XMTagHeaderComponent

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

- (void)componentDidLoad {
    [super componentDidLoad];

    [self _commonInit];
    [self _registerEvent];
}

#pragma mark - private

- (void)_commonInit {
    self.eventBus = [XMEventBus shared];
    self.tagHeaderHeight = 121; // 根据实际高度
    self.isAnimatingHeader = NO;

    [self.containerView addSubview:self.tagCollectionView];
    // 初始隐藏在顶部外
    self.tagCollectionView.frame = CGRectMake(0, -self.tagHeaderHeight, self.containerView.bounds.size.width, self.tagHeaderHeight);
}

- (void)_registerEvent {
    [self.eventBus subscribeEventName:XMDashboardSectionCollectionViewDidScrollEventName
                               target:self
                              handler:^(UIScrollView *scrollView) {

    }];

    [self.eventBus subscribeEventName:XMDashboardSectionCollectionViewDidEndDraggingEventName
                               target:self
                              handler:^(UIScrollView *scrollView) {

    }];

    [self.eventBus subscribeEventName:XMDashboardSectionCollectionViewDidEndDeceleratingEventName
                               target:self
                              handler:^(UIScrollView *scrollView) {

    }];
}


#pragma mark - getter

- (UICollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        _tagCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        _tagCollectionView.backgroundColor = XMBlackColor;
    }
    return _tagCollectionView;
}

#pragma mark - component delegate

+ (NSString *)xm_identifier {
    return XMTagHeaderComponentIdentifier;
}

@end
