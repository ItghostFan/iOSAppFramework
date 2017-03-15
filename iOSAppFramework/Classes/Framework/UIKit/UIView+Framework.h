//
//  UIView+Framework.h
//  Pods
//
//  Created by FanChunxing on 2017/3/13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Framework)

+ (void)keyboardAnimation:(NSNotification *)notification animations:(void (^)(CGRect keyBoardShowFrame))animations completion:(void (^)(BOOL finished))completion;

@end
