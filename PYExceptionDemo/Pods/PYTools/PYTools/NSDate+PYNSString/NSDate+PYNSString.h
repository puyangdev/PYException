//
//  NSDate+PYNSString.h
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PYNSString)
#pragma mark Constructor
+ (NSDate *)py_dateFromString:(NSString *)dateString;

#pragma mark Public Method
- (NSString *)py_stringValue;
- (NSString *)py_stringValueWithFormat:(NSString *)format;
- (NSString *)py_stringValueWithFormat:(NSString *)format withLocale:(NSLocale *)locale;
@end
