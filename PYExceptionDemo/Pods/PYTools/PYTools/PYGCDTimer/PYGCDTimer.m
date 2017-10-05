//
//  PYGCDTimer.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "PYGCDTimer.h"

dispatch_source_t PYCreateDispatchTimer(NSTimeInterval interval, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

@interface PYGCDTimer ()

@property (nonatomic, assign, readwrite) BOOL isRunning;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation PYGCDTimer

#pragma mark Public Method
+ (instancetype)timerWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats fireOnMainThread:(BOOL)isFireOnMainThread action:(void(^)(PYGCDTimer *timer))action {
    return [[self alloc] initWithInterval:interval repeats:repeats fireOnMainThread:isFireOnMainThread action:action];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats fireOnMainThread:(BOOL)isFireOnMainThread action:(void(^)(PYGCDTimer *timer))action {
   
    self = [super init];
    _interval = interval;
    _repeats = repeats;
    _isFireOnMainThread = isFireOnMainThread;
    _action = action;
    
    _firedCount = 0;
    
    return self;
}

- (void)fire {
    if (self.action) {
        self.action(self);
    }
}

- (void)fireOnMainThread {
    if ([NSThread isMainThread]) {
        [self fire];
    }
    else {
        if (self.action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fire];
            });
        }
    }
}

- (void)start {
    [self startNow:NO];
}

- (void)startNow:(BOOL)isFireNow {
    if (!self.isRunning) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timer = PYCreateDispatchTimer(self.interval, queue, ^{
            self.firedCount++;
            if (self.isFireOnMainThread) {
                [self fireOnMainThread];
            }
            else {
                [self fire];
            }
            if (!self.repeats) {
                [self stop];
            }
        });
        if (self.timer) {
            self.isRunning = YES;
        }
        
        if (isFireNow) {
            if (self.isFireOnMainThread) {
                [self fireOnMainThread];
            }
            else {
                [self fire];
            }
        }
    }
}

- (void)stop {
    if (self.isRunning) {
        if (self.timer) {
            dispatch_source_cancel(self.timer);
            self.timer = nil;
        }
        self.isRunning = NO;
    }
}

#pragma Overrides
- (void)dealloc {
    [self stop];
}

@end
