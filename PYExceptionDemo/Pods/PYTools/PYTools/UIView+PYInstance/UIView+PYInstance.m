//
//  UIView+PYInstance.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "UIView+PYInstance.h"

@implementation UIView (PYInstance)

#pragma mark Constructor
+ (instancetype)py_viewFromNib {
    return [self py_viewFromNibWithNibName:NSStringFromClass( [self class] ) ];
}

+ (instancetype)py_viewFromNibWithNibName:(NSString *)nibName {
    UIView *instance = [[[self class] alloc] init];
    NSArray *nibViews = [ [NSBundle mainBundle] loadNibNamed:nibName owner:instance options:nil];
    instance = nibViews[0];
    return instance;
}

@end
