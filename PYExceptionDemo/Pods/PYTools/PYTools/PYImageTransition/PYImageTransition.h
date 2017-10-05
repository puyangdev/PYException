//
//  PYImageTransition.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PYImageTransition : NSObject  <UIViewControllerAnimatedTransitioning>

+ (instancetype)pushTransition;
+ (instancetype)popTransition;
- (instancetype)initWithPop:(BOOL)isPop;

@property (nonatomic, assign) BOOL isPop; // default is no, means push

- (BOOL)canTransitionFromController:(UIViewController *)fromController toViewController:(UIViewController *)toController;
- (void)clearTransitionImage;

@end
