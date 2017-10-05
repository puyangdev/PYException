//
//  NSObject+PYPerform.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PYPerform)

#pragma mark Public Method
- (void)py_performActionDelay:(NSTimeInterval)second action:(void (^)(void) )action;
+ (void)py_performActionDelay:(NSTimeInterval)second action:(void (^)(void) )action;

@end
