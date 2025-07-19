//
//  XMDateSelectionComponent.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/19.
//

#import "DashboardTopContainerComponent.h"
#import "DateSelectionComponent.h"
#import "XMDashboardComponentFactory.h"
#import "XMDashboardViewModel.h"
#import "XMExtensionButton.h"

@interface DateSelectionComponent ()

@property (nonatomic, strong) XMExtensionButton *dateSelectionButton;
@property (nonatomic, strong) XMExtensionButton *dateButton;

@end

@implementation DateSelectionComponent

- (void)componentDidLoad {
    [super componentDidLoad];


}

#pragma mark - getter

- (UIView *)_topContainerView {
    id<XMDashboardComponent> component = [self.context componentWithClass:DashboardTopContainerComponent.class];
    if ([component respondsToSelector:@selector(componentView)]) {
        UIView *view = [component componentView];
        if ([view isKindOfClass:UIVisualEffectView.class]) {
            UIVisualEffectView *topContainer = (UIVisualEffectView *)view;
            return topContainer.contentView;
        }
        return view;
    }
    return nil;
}

@end


@implementation DateSelectionComponent (ComponentDelegate)

+ (void)load {
    [XMDashboardComponentFactory registerComponentClass:self];
}

+ (NSString *)xm_identifier {
    return NSStringFromClass(self);
}

@end
