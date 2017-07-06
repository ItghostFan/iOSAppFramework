//
//  UIView+Framework.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/3/13.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Framework)

+ (void)keyboardAnimation:(NSNotification *)notification animations:(void (^)(CGRect keyBoardShowFrame))animations completion:(void (^)(BOOL finished))completion;

@end
