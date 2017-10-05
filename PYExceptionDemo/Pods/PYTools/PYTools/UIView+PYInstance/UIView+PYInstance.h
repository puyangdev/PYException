//
//  UIView+PYInstance.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PYInstance)

#pragma mark Constructor
+ (instancetype)py_viewFromNib;
+ (instancetype)py_viewFromNibWithNibName:(NSString *)nibName;

@end
