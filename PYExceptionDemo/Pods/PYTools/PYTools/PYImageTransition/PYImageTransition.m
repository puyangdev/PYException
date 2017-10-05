//
//  PYImageTransition.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "PYImageTransition.h"
#import "PYImageTransitionElement.h"

@interface PYImageTransition ()

@property (nonatomic, strong) UIImageView *transitioningImageView;
@property (nonatomic, assign) BOOL isTransitioning;

@end

@implementation PYImageTransition
+ (instancetype)pushTransition {
    return [[self alloc] initWithPop:NO];
}

+ (instancetype)popTransition {
    return [[self alloc] initWithPop:YES];
}

- (instancetype)initWithPop:(BOOL)isPop {
    self = [super init];
    if (self) {
        _isPop = isPop;
    }
    return self;
}

- (void)dealloc {
    [self clearTransitionImage];
}

- (UIImageView *)transitioningImageView {
    if (!_transitioningImageView) {
        _transitioningImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _transitioningImageView;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    id fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    id toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    if (![self canTransitionFromController:fromController toViewController:toController]) {
        if (!self.isPop) {
            [containerView addSubview:[toController view]];
        }
        else {
            
        }
        return;
    }
    
    UIView *fromView = self.isPop ? [fromController pyPopElement].fromView : [fromController pyPushElement].fromView;
    UIImage *image = self.isPop ? [fromController pyPopElement].image : [fromController pyPushElement].image;
    if (!image && self.isPop) {
        image = [toController pyPushElement].image;
    }
    
    CGRect targetFrame = self.isPop ? [toController pyPopElement].targetFrame : [toController pyPushElement].targetFrame;
    if (self.isPop &&
        CGRectEqualToRect(targetFrame, CGRectZero)) {
        UIView *toViewPlaceholderView = [toController pyPushElement].fromViewPlaceholderView;
        toViewPlaceholderView = toViewPlaceholderView ? : [toController pyPushElement].fromView;
        
        targetFrame = [toViewPlaceholderView convertRect:toViewPlaceholderView.bounds toView:[toController view]];
    }
    
    CGRect originalFrame = [fromView convertRect:fromView.bounds toView:[fromController view]];
    if (!fromView && self.isPop) {
        originalFrame = [fromController pyPushElement].targetFrame;
    }
    
    UIView *toView = self.isPop ? [toController pyPushElement].fromView : nil;
    
    if (!self.isPop) {
        self.isTransitioning = YES;
        
        [containerView addSubview:[toController view]];
        [containerView addSubview:self.transitioningImageView];
        
        // 注释后解决状态栏高度变更时错位问题，之后考虑其它解决方案
        //        targetFrame = [[toController view] convertRect:targetFrame toView:containerView];
        //        originalFrame = [[fromController view] convertRect:originalFrame toView:containerView];
        
        self.transitioningImageView.frame = originalFrame;
        self.transitioningImageView.image = image;
        
        [fromController tabBarController].tabBar.alpha = 0.0f;
        fromView.hidden = YES;
        toView.hidden = YES;
        
        [toController view].alpha = 0.0f;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            [containerView layoutIfNeeded];
            [toController view].alpha = 1.0f;
            self.transitioningImageView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [fromController tabBarController].tabBar.alpha = 1.0f;
            fromView.hidden = NO;
            toView.hidden = NO;
            
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            
            [[fromController pyPushElement] endFromTransition];
            [[toController pyPushElement] endToTransition];
            
            self.isTransitioning = NO;
            
            [self clearTransitionImage];
        }];
        
        [[fromController pyPushElement] beginFromTransition];
        [[toController pyPushElement] beginToTransition];
    }
    else {
        self.isTransitioning = YES;
        
        [containerView insertSubview:[toController view] belowSubview:[fromController view]];
        [containerView addSubview:self.transitioningImageView];
        
        // 注释后解决状态栏高度变更时错位问题，之后考虑其它解决方案
        //        targetFrame = [[toController view] convertRect:targetFrame toView:containerView];
        //        originalFrame = [[fromController view] convertRect:originalFrame toView:containerView];
        
        // 移出屏幕时限制最小y坐标
        if (CGRectGetMinY(originalFrame) < -CGRectGetHeight(originalFrame)) {
            originalFrame.origin.y = -CGRectGetHeight(originalFrame);
        }
        
        // 移出屏幕时限制最大y坐标
        if (CGRectGetMinY(originalFrame) > CGRectGetHeight(containerView.bounds)) {
            originalFrame.origin.y = CGRectGetHeight(containerView.bounds);
        }
        
        self.transitioningImageView.frame = originalFrame;
        self.transitioningImageView.image = image;
        
        fromView.hidden = YES;
        toView.hidden = YES;
        [toController tabBarController].tabBar.alpha = 0.0f;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            [fromController view].alpha = 0.0f;
            self.transitioningImageView.frame = targetFrame;
        } completion:^(BOOL finished) {
            
            fromView.hidden = NO;
            toView.hidden = NO;
            [toController tabBarController].tabBar.alpha = 1.0f;
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
            [[fromController pyPopElement] endFromTransition];
            [[toController pyPopElement] endToTransition];
            
            self.isTransitioning = NO;
            
            [self clearTransitionImage];
        }];
        
        [[fromController pyPopElement] beginFromTransition];
        [[toController pyPopElement] beginToTransition];
    }
}

- (BOOL)canTransitionFromController:(UIViewController *)fromController toViewController:(UIViewController *)toController {
    if (!self.isPop && !toController.view) {
        return NO;
    }
    
    if (self.isPop && ![toController pyPushElement].image) {
        return NO;
    }
    
    UIView *fromView = self.isPop ? [fromController pyPopElement].fromView : [fromController pyPushElement].fromView;
    UIImage *image = self.isPop ? [fromController pyPopElement].image : [fromController pyPushElement].image;
    CGRect targetFrame = self.isPop ? [toController pyPopElement].targetFrame : [toController pyPushElement].targetFrame;
    
    if (!image && self.isPop) {
        image = [toController pyPushElement].image;
    }
    
    if (!image) {
        return NO;
    }
    
    if (!fromView && !self.isPop) {
        return NO;
    }
    
    CGRect originalFrame = [fromView convertRect:fromView.bounds toView:[fromController view]];
    if (!fromView && self.isPop) {
        originalFrame = [fromController pyPushElement].targetFrame;
    }
    
    if (CGRectEqualToRect(originalFrame, CGRectZero)) {
        return NO;
    }
    
    if (self.isPop &&
        CGRectEqualToRect(targetFrame, CGRectZero)) {
        targetFrame = [[toController pyPushElement].fromView convertRect:[toController pyPushElement].fromView.bounds toView:[toController view]];
    }
    
    if (CGRectEqualToRect(targetFrame, CGRectZero)) {
        return NO;
    }
    
    return YES;
}

- (void)clearTransitionImage {
    if (!self.isTransitioning) {
        [self.transitioningImageView removeFromSuperview];
        self.transitioningImageView = nil;
    }
}
@end
