//
//  AppTextField.m
//  pandafit
//
//  Created by FanChunxing on 16/2/28.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <objc/runtime.h>

#import "AppTextField.h"

@implementation AppTextField

@end

static const char* APP_TEXT_FIELD_DELGATE_PROPERTY = "AppTextFieldDelegateProperty";

@interface AppTextFieldDelegate()<UITextFieldDelegate>

@end

@implementation AppTextFieldDelegate

#pragma mark - AppTextFieldDelegate public

+ (instancetype)initWith:(UITextField *)textField
{
    AppTextFieldDelegate* appTextFieldDelegate = [AppTextFieldDelegate new];
#ifdef DEBUG
    id associateObject = objc_getAssociatedObject(textField, APP_TEXT_FIELD_DELGATE_PROPERTY);
    NSAssert(!associateObject, @"%s associateObject = %@", __FUNCTION__, associateObject);
#endif
    objc_setAssociatedObject(textField, APP_TEXT_FIELD_DELGATE_PROPERTY, appTextFieldDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    textField.delegate = appTextFieldDelegate;
    return appTextFieldDelegate;
}

#pragma mark - AppTextFieldDelegate private

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_returnBlock) {
        _returnBlock(textField);
    }
    
    return YES;
}

@end
