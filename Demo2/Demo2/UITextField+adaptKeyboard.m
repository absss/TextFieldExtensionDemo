//
//  UITextField+adaptKeyboard.m
//  Demo2
//
//  Created by hehaichi on 2018/12/3.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import "UITextField+adaptKeyboard.h"

static float _moveDistance = 0;
static float _offset = 0;

@implementation UITextField (adaptKeyboard)
- (void)adaptKeyboard {
    [self adaptKeyboardWithOffset:0];
}

- (void)adaptKeyboardWithOffset:(float)offset {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _offset = offset;
}


- (void)cancelAdaptKeyboard {
    _offset = 0;
    _moveDistance = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)sender {
    if (self.isFirstResponder == NO) return;
    if (self.superview == nil) return;
    
    CGFloat scren_height = [UIScreen mainScreen].bounds.size.height;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect= [self convertRect: self.bounds toView:window];
    
    CGFloat textFieldBottom = scren_height - CGRectGetMaxY(rect);
    
    CGFloat duration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardF = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    
    if (keyboardH > textFieldBottom) {
        _moveDistance = (textFieldBottom - keyboardH);
        _moveDistance += _offset;
        
        UIView * controllerView = [self viewController].view;
        CGRect frame = controllerView.frame;
        frame.origin.y += _moveDistance;
        
        [UIView animateWithDuration:duration animations:^{
            controllerView.frame = frame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)sender {
    if (self.isFirstResponder == NO) return;
    if (self.superview == nil) return;
    
    CGFloat duration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (_moveDistance != 0) {
        UIView * controllerView = [self viewController].view;
        CGRect frame = controllerView.frame;
        frame.origin.y -= _moveDistance;
        
        [UIView animateWithDuration:duration animations:^{
            controllerView.frame = frame;
        }];
        _moveDistance = 0;
    }
}

//获取控制器
- (UIViewController * )viewController{
    UIResponder * next = [self nextResponder];
    while (next!=nil) {
        if([next isKindOfClass:[UIViewController class]]){
            return (UIViewController * )next;
        }
        next = [next nextResponder];
    }
    return nil;
}

@end
