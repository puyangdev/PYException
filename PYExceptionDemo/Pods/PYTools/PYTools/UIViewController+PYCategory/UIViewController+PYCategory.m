//
//  UIViewController+PYCategory.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "UIViewController+PYCategory.h"
#import "PYConstant.h"
#import "UIView+PYSubview.h"

@implementation UIViewController (PYCategory)
+ (UIViewController *)py_topViewController {
    return [self py_topViewControllerWithRootViewController:nil];
}

- (UIViewController *)py_superiorViewController {
    UIViewController *superiorViewController = self;
    while (superiorViewController.parentViewController) {
        if (!superiorViewController.parentViewController.parentViewController
            && ([superiorViewController.parentViewController isKindOfClass:[UINavigationController class]]
                || [superiorViewController.parentViewController isKindOfClass:[UITabBarController class]])) {
                break;
            }
        
        superiorViewController = superiorViewController.parentViewController;
    }
    
    return superiorViewController;
}

- (void)py_addChildViewController:(UIViewController *)controller toView:(UIView *)view {
    [self addChildViewController:controller];
    [view py_addSubviewSpreadAutoLayout:controller.view];
}

#pragma mark Private Method
+ (UIViewController *)py_topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if (!rootViewController) {
        rootViewController = PY_WINDOW.rootViewController;
    }
    
    if (rootViewController.presentedViewController) {
        UIViewController *controller = rootViewController.presentedViewController;
        if (!controller ||
            controller == rootViewController) {
            return rootViewController;
        }
        return [self py_topViewControllerWithRootViewController:controller];
    }
    else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *) rootViewController;
        UIViewController *controller = tabBarController.selectedViewController ? : tabBarController.viewControllers.firstObject;
        if (!controller ||
            controller == rootViewController) {
            return rootViewController;
        }
        return [self py_topViewControllerWithRootViewController:controller];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) rootViewController;
        UIViewController *controller = navigationController.visibleViewController ? : navigationController.viewControllers.firstObject;
        if (!controller ||
            controller == rootViewController) {
            return rootViewController;
        }
        return [self py_topViewControllerWithRootViewController:controller];
    }
    else {
        return rootViewController;
    }
}

+ (UIViewController*)py_presentingViewController:(UIViewController*)aViewController {
    if (!aViewController) {
        PYLog(@"viewController is nil");
        return nil;
    }
    UIViewController *presentingViewCtrl=nil;
    if ([aViewController parentViewController]) {
        //ios4
        presentingViewCtrl = aViewController.parentViewController;
    }else if([aViewController respondsToSelector:@selector(presentingViewController)]) {
        //ios5
        if ([aViewController performSelector:@selector(presentingViewController)]) {
            presentingViewCtrl = [aViewController performSelector:@selector(presentingViewController)];
        }else{
            PYLog(@"No presentingViewController");
        }
    }else{
        PYLog(@"No presentingViewController");
    }
    return presentingViewCtrl;
}

- (void)py_presentTransparentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    UIGraphicsBeginImageContext(self.view.window.frame.size);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    modalViewController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:screenshot];
    [self presentViewController:modalViewController animated:YES completion:nil];
}

- (UIPopoverPresentationController *)py_popoverFromView:(UIView *)view atDirection:(UIPopoverArrowDirection)direction shouldDisplayArrow:(BOOL)shouldDisplayArrow fromViewController:(UIViewController *)controller {
    self.modalPresentationStyle = UIModalPresentationPopover;
    
    [controller presentViewController:self animated:YES completion:nil];
    UIPopoverPresentationController *popoverPresentationController = self.popoverPresentationController;
    popoverPresentationController.sourceView = view;
    
    if (shouldDisplayArrow) {
        popoverPresentationController.sourceRect = view.bounds;
        popoverPresentationController.permittedArrowDirections = direction;
    }
    else {
        CGFloat PopoverVerticalOffset = 7.0f;
        
        switch (direction) {
            case UIPopoverArrowDirectionUp:
            case UIPopoverArrowDirectionAny:
            case UIPopoverArrowDirectionUnknown:
                popoverPresentationController.sourceRect = CGRectMake(0.0f, (self.preferredContentSize.height + view.bounds.size.height) / 2.0f + PopoverVerticalOffset, view.bounds.size.width, view.bounds.size.height);
                break;
            case UIPopoverArrowDirectionDown:
                popoverPresentationController.sourceRect = CGRectMake(0.0f, -(self.preferredContentSize.height + view.bounds.size.height) / 2.0f + PopoverVerticalOffset, view.bounds.size.width, view.bounds.size.height);
                break;
            case UIPopoverArrowDirectionLeft:
                popoverPresentationController.sourceRect = CGRectMake( (self.preferredContentSize.width + view.bounds.size.width) / 2.0f, PopoverVerticalOffset, view.bounds.size.width, view.bounds.size.height);
                break;
            case UIPopoverArrowDirectionRight:
                popoverPresentationController.sourceRect = CGRectMake(-(self.preferredContentSize.width + view.bounds.size.width) / 2.0f, PopoverVerticalOffset, view.bounds.size.width, view.bounds.size.height);
                break;
                
            default:
                break;
        }
        popoverPresentationController.permittedArrowDirections = 0;
    }
    
    return popoverPresentationController;
}

- (UIPopoverPresentationController *)py_popoverInCenterOfWindowFromViewController:(UIViewController *)controller {
    self.modalPresentationStyle = UIModalPresentationPopover;
    [controller presentViewController:self animated:YES completion:NULL];
    UIPopoverPresentationController *popoverPresentationController = self.popoverPresentationController;
    popoverPresentationController.sourceView = PY_WINDOW;
    popoverPresentationController.sourceRect = PY_WINDOW.bounds;
    popoverPresentationController.permittedArrowDirections = 0;
    
    return popoverPresentationController;
}


- (void)py_dismiss {
    [self py_dismissWithAnimation:YES];
}

- (void)py_dismissWithAnimation:(BOOL)animated {
    if (self == PY_WINDOW.rootViewController) {
        return;
    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
    else if (self.navigationController && self.navigationController.viewControllers.firstObject == self) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }
    else if (self.navigationController && self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:animated];
    }
    else if (self.parentViewController) {
        [self.parentViewController py_dismissWithAnimation:animated];
    }
}

+ (void)py_backToRootViewController {
    UIViewController *rootViewController = PY_WINDOW.rootViewController;
    UIViewController *presentedViewController = rootViewController;
    while (presentedViewController.presentedViewController) {
        presentedViewController = presentedViewController.presentedViewController;
    }
    
    UIViewController *presentingViewController;
    while (presentedViewController != rootViewController) {
        presentingViewController = presentedViewController.presentingViewController;
        [presentedViewController dismissViewControllerAnimated:NO completion:nil];
        presentedViewController = presentingViewController;
    }
    
    if ( [rootViewController isKindOfClass:[UINavigationController class] ] ) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        [navigationController popToRootViewControllerAnimated:NO];
    }
}
@end
