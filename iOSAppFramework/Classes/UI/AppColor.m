//
//  AppColor.m
//  pandafit
//
//  Created by FanChunxing on 16/2/21.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import "AppColor.h"

@implementation AppColor

@end

@implementation UIColor(AppColor)

+ (instancetype)colorWithHex:(UInt32)color
{
    CGFloat alpha = ((color & 0xff000000) >> 24) / 255.0f;
    CGFloat red = ((color & 0x00ff0000) >> 16) / 255.0f;
    CGFloat green = ((color & 0x0000ff00) >> 8) / 255.0f;
    CGFloat blue = (color & 0x000000ff) / 255.0f;
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:alpha];
}

@end