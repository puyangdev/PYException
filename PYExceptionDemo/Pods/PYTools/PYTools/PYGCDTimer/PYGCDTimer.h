//
//  PYGCDTimer.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PYGCDTimer;

@interface PYGCDTimer : NSObject

#pragma mark Public Method
+ (instancetype)timerWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats fireOnMainThread:(BOOL)isFireOnMainThread action:(void(^)(PYGCDTimer *timer))action;
- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats fireOnMainThread:(BOOL)isFireOnMainThread action:(void(^)(PYGCDTimer *timer))action;

- (void)fire;
- (void)fireOnMainThread;
- (void)start;
- (void)startNow:(BOOL)isFireNow;
- (void)stop;

#pragma mark Properties
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, assign) BOOL isFireOnMainThread;
@property (nonatomic, copy) void(^action)(PYGCDTimer *timer);

@property (nonatomic, assign) NSInteger firedCount;

@property (nonatomic, assign, readonly) BOOL isRunning;

@end
