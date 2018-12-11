//
//  UITextField+inputLimit.h
//  Demo2
//
//  Created by hehaichi on 2018/12/3.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *(^FJKTextFieldFilterBlock)(UITextField *textField);

@interface UITextField (inputLimit)
//根据block输入限制
- (void)limitInputWithFilterBlock:(FJKTextFieldFilterBlock)filter;
- (void)limitInputWithFilterBlock:(FJKTextFieldFilterBlock)filter withWordLimit:(NSInteger)count;

////根据正则输入限制（正则内容代表允许输入内容）
- (void)limitInputWithRegex:(NSString *)regex;
- (void)limitInputWithRegex:(NSString *)regex withWordLimit:(NSInteger )count;

//仅允许数字
- (void)limitOnlyDigitCharWithWordLimit:(NSInteger)count;
//仅允许字母
- (void)limitOnlyLetterCharWithWordLimit:(NSInteger)count;
//允许数字或字母
- (void)limitOnlyLetterAndDigitCharWithWordLimit:(NSInteger)count;
//允许中文输入
- (void)limitOnlyChineseCharWithWordLimit:(NSInteger)count;
//对象销毁时，记得移除观察者
- (void)cancelLimit;
@end

