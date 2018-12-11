//
//  ViewController.m
//  Demo2
//
//  Created by hehaichi on 2018/12/3.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+adaptKeyboard.h"
#import "UITextField+inputLimit.h"

@interface ViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 30)];
    self.label.text = @"labellabellabellabellabellabellabellabel";
    [self.view addSubview:self.label];
    self.view.backgroundColor = [UIColor brownColor];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 600, self.view.frame.size.width, 30)];
    [self.textField limitInputWithFilterBlock:nil withWordLimit:5];
    [self.textField limitInputWithFilterBlock:nil withWordLimit:10];
    [self.textField limitInputWithFilterBlock:^NSString *(UITextField *textField) {
        NSMutableString * str = textField.text.mutableCopy;
        [str replaceOccurrencesOfString:@"我" withString:@"**" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
        return str.copy;
    } withWordLimit:10];
    [self.textField limitOnlyChineseCharWithWordLimit:10];
    [self.textField adaptKeyboardWithOffset:-15];
    [self.view addSubview:self.textField];
    self.textField.backgroundColor = [UIColor redColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [self.textField cancelAdaptKeyboard];
    [self.textField cancelLimit];
}
@end
