//
//  ViewController.m
//  PYExceptionDemo
//
//  Created by mac on 2017/10/3.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "ViewController.h"
#import <PYException/PYExceptionHeader.h>
#import "PYTest.h"
#import "PushViewController.h"
#import "PYTestViewController.h"
#import "PYZombieMonitor.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *testLabel;
@property (strong, nonatomic) IBOutlet UITextField *testField;
@property (strong, nonatomic) IBOutlet UIButton *testBtn;

@end

@implementation ViewController
- (IBAction)testFirstAction:(UIButton *)sender {
    PushViewController* push = [[PushViewController alloc] init];
    [self presentViewController:push animated:YES completion:nil];
}
- (IBAction)testSecondAction:(UIButton *)sender {
    PYTestViewController *testVC = [[PYTestViewController alloc] init];
    [self presentViewController:testVC animated:YES completion:nil];
//    PYTest *test = [[PYTest alloc] init];
//    [test MissMethod];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [PYZombieMonitor install];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    self.testLabel.text = [NSNull null];
//    self.testField.text = [NSNull null];
//    [self.testBtn setTitle:[NSNull null] forState:UIControlStateNormal];
//     [self.testBtn setTitle:@"ddddd" forState:UIControlStateNormal];
//    self.testLabel.text = nil;
//    self.testField.text = nil;
//    self.testLabel.text = @"jjjjjjjj";
//    self.testField.text = @"kkkkkk";
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSNull null]];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNull null] forKey:@"sfa"];
//    PYTest *test = [NSNull null];
//    [test MissMethod];
    PYTest *test = [[PYTest alloc] init];
    [test missMethodss];
    [test performSelector:@selector(missMet:) withObject:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
