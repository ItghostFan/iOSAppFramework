//
//  UIColor+iOS.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/1/17.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UICOLOR_RGB(rgb) \
    [UIColor colorWithR:rgb >> 16 G:(rgb >> 8) & 0xFF B:rgb & 0xFF A:0xFF]

#define UICOLOR_RGBA(rgba) \
    [UIColor colorWithR:rgba >> 24 G:(rgba >> 16) & 0xFF B:(rgba >> 8) & 0xFF A:rgba & 0xFF]

@interface UIColor (iOS)

+ (UIColor *)colorWithR:(Byte)red G:(Byte)green B:(Byte)blue A:(Byte)alpha;

@end
