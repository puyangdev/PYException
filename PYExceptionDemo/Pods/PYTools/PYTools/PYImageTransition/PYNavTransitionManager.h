//
//  PYNavTransitionManager.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PYNavTransitionManager : NSObject <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

- (instancetype)initWithNavigationController:(UINavigationController *)controller;
- (BOOL)canTransitionFromController:(UIViewController *)fromController toViewController:(UIViewController *)toController forPop:(BOOL)isPop;

@end

@interface UINavigationController (PYNavTransition)

@property (nonatomic, strong) PYNavTransitionManager *pyNavTransitionManager;

// 启用转场动画，一个UINavigationController调用一次即可
- (void)setupPYNavTransition;

@end
