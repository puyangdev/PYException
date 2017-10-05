//
//  UIView+PYSubview.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PYSubview)

/**
 *  移除所有子view
 */
- (void)py_removeAllSubviews;

/**
 *  添加填充子view，利用KVO实现
 */
- (void)py_addSubviewSpread:(UIView *)view;

/**
 *  添加填充子view，利用AutoLayout实现
 *
 *  @return constraints
 */
- (NSArray *)py_addSubviewSpreadAutoLayout:(UIView *)view;

@end
