//
//  main.m
//  XMDashboard
//
//  Created by lannastudio on 2025/5/17.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }

    NSObject *object = [NSObject new];
    NSInteger val = 1;
    static int a = 1;
    int b = 1;
    __unsafe_unretained dispatch_block_t block = ^{};
    __unsafe_unretained dispatch_block_t unsafeUnretainedBlockRefLocalVar = ^{
        a++;
    };
    __strong dispatch_block_t strongBlock = ^{};
    __strong dispatch_block_t strongBlockRefLocalVar = ^{
        NSLog(@"%@", object);
    };
    __autoreleasing dispatch_block_t autoReleasingBlock = ^{
        NSLog(@"%@", object);
    };
    NSLog(@"%@", block);
    NSLog(@"%@", unsafeUnretainedBlockRefLocalVar);
    NSLog(@"%@", strongBlock);
    NSLog(@"%@", strongBlockRefLocalVar);
    NSLog(@"%@", autoReleasingBlock);
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
