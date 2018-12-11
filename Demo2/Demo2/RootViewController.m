//
//  RootViewController.m
//  Demo2
//
//  Created by hehaichi on 2018/12/3.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ViewController * vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
