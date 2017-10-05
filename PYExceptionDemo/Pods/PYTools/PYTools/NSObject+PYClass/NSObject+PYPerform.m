//
//  NSObject+PYPerform.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSObject+PYPerform.h"

@implementation NSObject (PYPerform)

#pragma mark Public Method
- (void)py_performActionDelay:(NSTimeInterval)second action:(void (^)(void))action {
    [[self class] py_performActionDelay:second
                                 action:action];
}

+ (void)py_performActionDelay:(NSTimeInterval)second action:(void (^)(void))action {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * second);
    dispatch_after(delay, dispatch_get_main_queue(), [action copy]);
}


@end
