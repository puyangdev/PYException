//
//  UIViewController+PYCategory.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PYCategory)

+ (UIViewController*)py_topViewController;

// 当前controller的最上层的parentViewController, 通常为被present的controller或nav中的controller或tab中的controller
- (UIViewController *)py_superiorViewController;

- (void)py_addChildViewController:(UIViewController *)controller toView:(UIView *)view;

+ (UIViewController*)py_presentingViewController:(UIViewController*)aViewController;
- (void)py_presentTransparentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;

- (UIPopoverPresentationController *)py_popoverFromView:(UIView *)view atDirection:(UIPopoverArrowDirection)direction shouldDisplayArrow:(BOOL)shouldDisplayArrow fromViewController:(UIViewController *)controller;

- (UIPopoverPresentationController *)py_popoverInCenterOfWindowFromViewController:(UIViewController *)controller;

- (void)py_dismiss;
- (void)py_dismissWithAnimation:(BOOL)animated;

+ (void)py_backToRootViewController;
@end
