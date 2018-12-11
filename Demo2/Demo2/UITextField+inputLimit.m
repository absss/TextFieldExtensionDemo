//
//  UITextField+inputLimit.m
//  Demo2
//
//  Created by hehaichi on 2018/12/3.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import "UITextField+inputLimit.h"
#import <objc/runtime.h>

@interface UITextField()
@property (nonatomic, copy) FJKTextFieldFilterBlock filter;
@end

static char filterKey;

@implementation UITextField (inputLimit)

- (void)limitInputWithFilterBlock:(FJKTextFieldFilterBlock)filter {
    [self cancelLimit];
    self.filter = filter;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)  name:UITextFieldTextDidChangeNotification object: self];
}

- (void)cancelLimit {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    self.filter = nil;
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    if (self.filter) {
        self.filter(self);
    }
}

- (void)limitInputWithFilterBlock:(FJKTextFieldFilterBlock)filter withWordLimit:(NSInteger)count {
    [self limitInputWithFilterBlock:^NSString *(UITextField *textField) {
        NSString * toBeString = textField.text;
        if (filter) {
             toBeString = filter(textField);
        }
        NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]){
            
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            if (!position) {
                if (toBeString.length > count) {
                    toBeString = [toBeString substringToIndex:count];
                }
                textField.text = toBeString;
            }
        } else {
            if (toBeString.length > count) {
                toBeString = [toBeString substringToIndex:count];
            }
            textField.text = toBeString;
        }
        
        return textField.text;
    }];
}

- (void)limitInputWithRegex:(NSString *)regex {
    [self limitInputWithFilterBlock:^NSString *(UITextField *textField) {
        NSString * toBeString = [self filterCharactor:textField.text withRegex:regex];
        return toBeString;
    }];
}

- (void)limitInputWithRegex:(NSString *)regex withWordLimit:(NSInteger )count {
    [self limitInputWithFilterBlock:^NSString *(UITextField *textField) {
        NSString * toBeString = [self filterCharactor:textField.text withRegex:regex];
        return toBeString;
    } withWordLimit:count];
}

- (void)limitOnlyDigitCharWithWordLimit:(NSInteger)count {
    [self limitInputWithFilterBlock:^NSString *(UITextField *textField) {
        NSString * toBeString = textField.text;
        NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        toBeString = [[toBeString componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
        return toBeString;
        
    } withWordLimit:count];
}

- (void)limitOnlyLetterCharWithWordLimit:(NSInteger)count {
    [self limitInputWithFilterBlock:^NSString *(UITextField *textField) {
        NSString * toBeString = textField.text;
        NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet letterCharacterSet] invertedSet];
        toBeString = [[toBeString componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
        return toBeString;
        
    } withWordLimit:count];
}

- (void)limitOnlyLetterAndDigitCharWithWordLimit:(NSInteger)count {
    [self limitInputWithFilterBlock:^NSString *(UITextField *textField) {
        NSString * toBeString = textField.text;
        NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        toBeString = [[toBeString componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
        return toBeString;
        
    } withWordLimit:count];
}

- (void)limitOnlyChineseCharWithWordLimit:(NSInteger)count {
    return  [self limitInputWithRegex:@"[^\u4e00-\u9fa5]" withWordLimit:count];
}

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

#pragma mark - setter & getter
- (FJKTextFieldFilterBlock)filter {
    return objc_getAssociatedObject(self, &filterKey);
}

- (void)setFilter:(FJKTextFieldFilterBlock)filter {
    objc_setAssociatedObject(self, &filterKey, filter, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
