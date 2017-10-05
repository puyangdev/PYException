//
//  NSDate+PYNSString.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "NSDate+PYNSString.h"

@implementation NSDate (PYNSString)

#pragma mark Constructor
+ (NSDate *)py_dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [ [NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark Public Method
- (NSString *)py_stringValue {
    return [self py_stringValueWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)py_stringValueWithFormat:(NSString *)format {
    return [self py_stringValueWithFormat:format withLocale:nil];
}

- (NSString *)py_stringValueWithFormat:(NSString *)format withLocale:(NSLocale *)locale {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = locale;
    [dateFormatter setDateFormat:format];
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}

@end
