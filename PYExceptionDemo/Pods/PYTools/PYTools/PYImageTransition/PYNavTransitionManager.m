//
//  PYNavTransitionManager.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "PYNavTransitionManager.h"
#import "PYImageTransition.h"
#import "PYImageTransitionElement.h"
#import "PYConstant.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface PYNavTransitionManager()

@property (nonatomic, weak) id<UINavigationControllerDelegate> originalDelegate;
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> originalGestureRecognizerDelegate;

@property (nonatomic, weak) UINavigationController *target;

@property (nonatomic, strong) PYImageTransition *currentTransition;
@property (nonatomic, strong) UIImageView *currentTransitionImageView;

@end

@implementation PYNavTransitionManager

- (instancetype)initWithNavigationController:(UINavigationController *)controller {
    self = [super init];
    if (self) {
        _target = controller;
        _originalDelegate = _target.delegate;
        _originalGestureRecognizerDelegate = _target.interactivePopGestureRecognizer.delegate;
        
        _target.delegate = self;
        _target.interactivePopGestureRecognizer.delegate = self;
        
        PY_WEAK_SELF;
        [RACObserve(_target, delegate) subscribeNext:^(id x) {
            PY_STRONG_SELF;
            if (pyStrongSelf.target.delegate != pyStrongSelf) {
                pyStrongSelf.originalDelegate = pyStrongSelf.target.delegate;
                pyStrongSelf.target.delegate = pyStrongSelf;
            }
        }];
        [RACObserve(_target.interactivePopGestureRecognizer, delegate) subscribeNext:^(id x) {
            PY_STRONG_SELF;
            if (pyStrongSelf.target.interactivePopGestureRecognizer.delegate != pyStrongSelf) {
                pyStrongSelf.originalGestureRecognizerDelegate = pyStrongSelf.target.interactivePopGestureRecognizer.delegate;
                pyStrongSelf.target.interactivePopGestureRecognizer.delegate = pyStrongSelf;
            }
        }];
    }
    return self;
}

- (BOOL)canTransitionFromController:(UIViewController *)fromController toViewController:(UIViewController *)toController forPop:(BOOL)isPop {
    if (isPop) {
        PYImageTransition *popTransition = [PYImageTransition popTransition];
        return [popTransition canTransitionFromController:fromController toViewController:toController];
    }
    else {
        PYImageTransition *pushTransition = [PYImageTransition pushTransition];
        return [pushTransition canTransitionFromController:fromController toViewController:toController];
    }
}

- (id<UINavigationControllerDelegate>)originalDelegate {
    if (_originalDelegate == self) {
        return nil;
    }
    
    return _originalDelegate;
}

- (id<UIGestureRecognizerDelegate>)originalGestureRecognizerDelegate {
    if (_originalGestureRecognizerDelegate == self) {
        return nil;
    }
    
    return _originalGestureRecognizerDelegate;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated; {
    if (self.originalDelegate &&
        [self.originalDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.originalDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.originalDelegate &&
        [self.originalDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.originalDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    
    // push或pop完成时调用
    // push完成时因viewController的push动画相关参数必然为空，置空也无妨
    // pop完成时移除前一次push动画相关参数
    viewController.pyPushElement.fromView = nil;
    viewController.pyPushElement.image = nil;
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
    if (self.originalDelegate &&
        [self.originalDelegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.originalDelegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
    if (self.originalDelegate &&
        [self.originalDelegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.originalDelegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    
    return UIInterfaceOrientationPortrait;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0) {
    if (self.originalDelegate &&
        [self.originalDelegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.originalDelegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (self.originalDelegate &&
        [self.originalDelegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.originalDelegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    
    [fromVC.pyPushElement update];
    [fromVC.pyPopElement update];
    [toVC.pyPushElement update];
    [toVC.pyPopElement update];
    
    if (operation == UINavigationControllerOperationPush) {
        PYImageTransition *pushTransition = [PYImageTransition pushTransition];
        if ([pushTransition canTransitionFromController:fromVC toViewController:toVC]) {
            fromVC.pyPushElement.toController = toVC;
            toVC.pyPushElement.fromController = fromVC;
            
            self.currentTransition = pushTransition;
            return pushTransition;
        }
    }
    else if (operation == UINavigationControllerOperationPop) {
        PYImageTransition *popTransition = [PYImageTransition popTransition];
        if ([popTransition canTransitionFromController:fromVC toViewController:toVC]) {
            fromVC.pyPushElement.toController = toVC;
            toVC.pyPushElement.fromController = fromVC;
            
            self.currentTransition = popTransition;
            return popTransition;
        }
        else {
            toVC.pyPushElement.fromView = nil;
            toVC.pyPushElement.image = nil;
        }
    }
    
    self.currentTransition = nil;
    
    return nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.originalGestureRecognizerDelegate &&
        [self.originalGestureRecognizerDelegate respondsToSelector:@selector(gestureRecognizerShouldBegin:)]) {
        return [self.originalGestureRecognizerDelegate gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}
@end
