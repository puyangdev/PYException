//
//  NSObject+PYClass.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSObject+PYClass.h"

@implementation NSObject (PYClass)

+ (NSString *)py_className {
    return NSStringFromClass(self);
}

- (NSString *)py_className {
     return [[self class] py_className];
}

@end
