//
//  PYTestViewController.m
//  PYExceptionDemo
//
//  Created by mac on 2018/10/6.
//  Copyright © 2018年 于浦洋. All rights reserved.
//

#import "PYTestViewController.h"
#import "PYTestView.h"
#import <objc/runtime.h>
#import <PYException/PYExceptionHandle.h>

@interface PYTestViewController ()

@end

@implementation PYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[PYExceptionHandle sharedExceptionHandle] setDidCatchExceptionBlock:^(NSString * _Nonnull errorMsg) {
        NSLog(@"%@",errorMsg);
    }];
    
    PYTestView *testView = [[PYTestView alloc] init];
    [testView retain];
//    NSLog(@"===== %lu",(unsigned long)testView.retainCount);
    PYTestView *testV = testView;
//    NSLog(@"===== %lu",(unsigned long)testV.retainCount);
    [testView release];
    testView = nil;
//    NSLog(@"===== %lu",(unsigned long)testView.retainCount);
    [testV setBackgroundColor:[UIColor redColor]];
    [testV performSelector:@selector(testVAction:) withObject:nil];
//    NSLog(@"%@",testV);
    [testV release];
//    size_t size = class_getInstanceSize([testV class]);
//    memset(self, 0, size);
    
//    NSLog(@"%@",testV);
    NSLog(@"===================================");
//    [testV setAccessibilityIdentifier:@"yupuyang"];
//    [testV setBackgroundColor:[UIColor redColor]];
//    NSLog(@"%@",testV);
    
    // Do any additional setup after loading the view.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
