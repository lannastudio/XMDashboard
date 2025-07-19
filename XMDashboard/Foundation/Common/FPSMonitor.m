//
//  FPSMonitor.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/15.
//

#import "FPSMonitor.h"

@interface FPSMonitor ()

@end

@implementation FPSMonitor {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
}

- (void)xm_start {
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(_tick:)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _count = 0;
    _lastTime = 0;
}

- (void)xm_stop {
    [_link invalidate];
    _link = nil;
}

- (void)_tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }

    _count += 1;
    NSTimeInterval delta = _link.timestamp - _lastTime;
    if (delta < 1) return;
    CGFloat fps = _count/delta;
    XMLog(@"当前fps：%f", fps);
    _count = 0;
    _lastTime = _link.timestamp;
}

@end
