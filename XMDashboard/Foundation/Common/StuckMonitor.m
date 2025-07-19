//
//  StuckMonitor.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/15.
//

#import "StuckMonitor.h"
#import <mach/mach.h>
#import <pthread.h>
#import <execinfo.h>
#import <dlfcn.h>

@implementation StuckMonitor {
    CFRunLoopObserverRef _observer;
    dispatch_semaphore_t _sema;
    BOOL _stopped;
}

- (void)xm_start {
    _stopped = NO;
    _sema = dispatch_semaphore_create(0);

    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
    _observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeSources | kCFRunLoopAfterWaiting, YES, 0, &runLoopCallback, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (!self->_stopped) {
            long st = dispatch_semaphore_wait(self->_sema, dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC)); // 50ms超时
            if (st != 0) {
                // 超时未响应，主线程有卡顿嫌疑
                NSLog(@"检测到主线程卡顿！");
                // 可进一步获取主线程堆栈
                printMainThreadStack();
            }
        }
    });
}

- (void)stop {
    _stopped = YES;
    if (_observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
        CFRelease(_observer);
        _observer = NULL;
    }
}

static void runLoopCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    StuckMonitor *monitor = (__bridge StuckMonitor *)info;
    dispatch_semaphore_t sema = monitor->_sema;
    dispatch_semaphore_signal(sema);
}

void printMainThreadStack(void) {
    thread_act_t main_thread;
    // 1. 获取主线程的 mach port
    task_t this_task = mach_task_self();
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count = 0;
    kern_return_t kr = task_threads(this_task, &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) return;

    // 2. 寻找主线程
    pthread_t main_pthread = pthread_main_np();
    main_thread = mach_thread_self(); // 默认
    for (int i = 0; i < thread_count; i++) {
        pthread_t pt = pthread_from_mach_thread_np(thread_list[i]);
        if (pthread_equal(pt, main_pthread)) {
            main_thread = thread_list[i];
            break;
        }
    }

    // 3. 采集堆栈（方法1：简单backtrace主线程）
    void *backtraceBuffer[128];
    int count = backtrace(backtraceBuffer, 128);
    char **syms = backtrace_symbols(backtraceBuffer, count);
    NSLog(@"======= 主线程调用栈 =======");
    for (int i = 0; i < count; i++) {
        NSLog(@"%s", syms[i]);
    }
    free(syms);

    // 4. 回收
    vm_deallocate(this_task, (vm_address_t)thread_list, sizeof(thread_t) * thread_count);
}

@end
