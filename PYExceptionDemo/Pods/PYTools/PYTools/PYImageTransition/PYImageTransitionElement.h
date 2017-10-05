//
//  PYImageTransitionElement.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface PYImageTransitionElement : NSObject

- (instancetype)initWithController:(UIViewController *)controller isPop:(BOOL)isPop;

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, assign) BOOL isPop;
@property (nonatomic, assign) BOOL isTransitioning;

@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, strong) UIView *fromViewPlaceholderView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect targetFrame;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic, strong) UIView *toViewPlaceholderView;

@property (nonatomic, strong) UIImageView *bePushedPreloadingImageView;

@property (nonatomic, weak) UIViewController *fromController;
@property (nonatomic, weak) UIViewController *toController;

@property (nonatomic, copy) void(^updateAction)(PYImageTransitionElement *element);
@property (nonatomic, copy) void(^beginFromTransitionAction)(PYImageTransitionElement *element);
@property (nonatomic, copy) void(^beginToTransitionAction)(PYImageTransitionElement *element);
@property (nonatomic, copy) void(^endFromTransitionAction)(PYImageTransitionElement *element);
@property (nonatomic, copy) void(^endToTransitionAction)(PYImageTransitionElement *element);

- (void)update;
- (void)beginFromTransition;
- (void)beginToTransition;
- (void)endFromTransition;
- (void)endToTransition;

- (UIImage *)getFromImage;

@end

@interface UIViewController (PYImageTransition)

@property (nonatomic, strong) PYImageTransitionElement *pyPushElement;
@property (nonatomic, strong) PYImageTransitionElement *pyPopElement;

@end
