//
//  UIView+Framework.m
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/3/13.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "UIView+Framework.h"

#import "NSObject+iOS.h"

@implementation UIView (Framework)

+ (void)keyboardAnimation:(NSNotification *)notification animations:(void (^)(CGRect keyBoardShowFrame))animations completion:(void (^)(BOOL finished))completion {
    UIViewAnimationOptions animationOptions = ((NSNumber *)notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]).intValue;
    NSTimeInterval duration = ((NSNumber *)notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]).floatValue;
    CGRect keyBoardShowFrame = ((NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationCurve:animationCurve];
//    [UIView setAnimationDelegate:<#(nullable id)#>]
//    SAFE_INVOKE_BLOCK(animation);
//    [UIView commitAnimations];
    
    
//    ;
//    switch (animationCurve) {
//        case UIViewAnimationCurveEaseInOut:
//            animationOptions = UIViewAnimationOptionCurveEaseInOut;
//        case UIViewAnimationCurveEaseIn:
//            animationOptions = UIViewAnimationOptionCurveEaseIn;
//        case UIViewAnimationCurveEaseOut:
//            animationOptions = UIViewAnimationOptionCurveEaseOut;
//        case UIViewAnimationCurveLinear:
//            animationOptions = UIViewAnimationOptionCurveLinear;
//        default:
//            break;
//    }
    
    [UIView animateWithDuration:duration delay:0.0f options:animationOptions animations:^() {
        animations(keyBoardShowFrame);
    } completion:completion];
}

@end
