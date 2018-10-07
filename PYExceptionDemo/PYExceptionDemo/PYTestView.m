//
//  PYTestView.m
//  PYExceptionDemo
//
//  Created by mac on 2018/10/6.
//  Copyright © 2018年 于浦洋. All rights reserved.
//

#import "PYTestView.h"
#import <objc/runtime.h>
@implementation PYTestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc {
    size_t size = class_getInstanceSize([self class]);
//    NSLog(@"%zu", size);
//    NSLog(@"%s",__func__);
    [super dealloc];
}
@end
