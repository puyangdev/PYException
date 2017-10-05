//
//  NSObject+PYClass.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PYClass)

#pragma mark Public Method
+ (NSString *)py_className;
- (NSString *)py_className;

@end
