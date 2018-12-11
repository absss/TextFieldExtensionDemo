//
//  UITextField+adaptKeyboard.h
//  Demo2
//
//  Created by hehaichi on 2018/12/3.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UITextField (adaptKeyboard)
/**
 适应键盘
 */
- (void)adaptKeyboard;

/**
 适应键盘

 @param offset 输入框底部距离键盘顶部的距离
 */
- (void)adaptKeyboardWithOffset:(float)offset;

/**
 对象销毁时，记得移除观察者
 */
- (void)cancelAdaptKeyboard;
@end
