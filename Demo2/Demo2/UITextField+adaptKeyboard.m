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
static BOOL _isShow = NO;


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

#pragma mark - 键盘通知的方法

- (void)keyboardWillShow:(NSNotification *)sender {
    if (self.isFirstResponder == NO) {
        return;
    }
    if (self.superview == nil) {
        return;
    }
    if (_isShow) {
        return;
    }
    
    CGFloat scren_height = [UIScreen mainScreen].bounds.size.height;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect= [self convertRect: self.bounds toView:window];
    CGFloat textFieldBottom = scren_height - CGRectGetMaxY(rect);
    
    CGRect beginRect = [[sender.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardH = endRect.size.height;
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y > 0)){
        
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
    _isShow = YES;
}


- (void)keyboardWillHide:(NSNotification *)sender {
    if (self.isFirstResponder == NO) {
         return;
    }
    if (self.superview == nil) {
        return;
    }
    if (!_isShow) {
        return;
    }
    
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
    _isShow = NO;
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
