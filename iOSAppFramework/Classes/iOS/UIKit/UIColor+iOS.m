//
//  UIColor+iOS.m
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/1/17.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "UIColor+iOS.h"

/**
 * @brief 0.0f~1.0f.
 */
#define BYTE_PERCENT_VALUE(byte)    (byte / 255.0f)

@implementation UIColor (iOS)

#pragma mark - self public

+ (UIColor *)colorWithR:(Byte)red G:(Byte)green B:(Byte)blue A:(Byte)alpha {
    return [self colorWithRed:BYTE_PERCENT_VALUE(red) green:BYTE_PERCENT_VALUE(green) blue:BYTE_PERCENT_VALUE(blue) alpha:BYTE_PERCENT_VALUE(alpha)];
}

@end
