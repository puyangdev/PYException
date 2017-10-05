//
//  UIView+PYSubview.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "UIView+PYSubview.h"

@implementation UIView (PYSubview)

- (void)py_removeAllSubviews {
    for (UIView *view in [self.subviews copy]) {
        [view removeFromSuperview];
    }
}

- (void)py_addSubviewSpread:(UIView *)view {
    if (!view
        || [self.subviews containsObject:view]) {
        return;
    }
    
    [self addSubview:view];
    view.frame = self.bounds;
}

- (NSArray *)py_addSubviewSpreadAutoLayout:(UIView *)view {
    if (!view
        || [self.subviews containsObject:view]) {
        return nil;
    }
    
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pysubview]-0-|" options:0 metrics:nil views:@{@"pysubview" : view} ] ];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pysubview]-0-|" options:0 metrics:nil views:@{@"pysubview" : view} ] ];
    NSArray *constraints = [NSArray arrayWithArray:array];
    [self addConstraints:constraints];
    return constraints;
}

@end
