//
//  AppTextField.h
//  pandafit
//
//  Created by FanChunxing on 16/2/28.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppTextField : UITextField

@end

@interface AppTextFieldDelegate : NSObject

@property (strong, nonatomic) void (^returnBlock)(UITextField* textField);

+ (instancetype)initWith:(UITextField *)textField;

@end