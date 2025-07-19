//
//  DashboardInfo.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/3.
//

#import "DashboardInfo.h"
#import <IGListKit/IGListKit.h>

@interface DashboardInfo () <IGListDiffable>

@property (nonatomic, strong) NSNumberFormatter *formatter;

@end

@implementation DashboardInfo

- (instancetype)initWithName:(NSString *)name info:(NSString *)info {
    self = [super init];
    if (self) {
        _name = name;
        _info = info;
    }
    return self;
}

- (id<NSObject>)diffIdentifier {
    return [[NSString alloc] initWithFormat:@"%@, %@", self.name, self.info];
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (self == object) return YES;
    return [[self diffIdentifier] isEqual:[object diffIdentifier]];
}

- (NSNumberFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSNumberFormatter alloc] init];
        _formatter.minimumFractionDigits = 0;
        _formatter.maximumFractionDigits = 2;
        _formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return _formatter;
}

@end

@implementation DashboardInfo (StringFormatter)

+ (NSString *)percentString:(double)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [NSString stringWithFormat:@"%@ %%", [formatter stringFromNumber:@(value)]];
}

@end
