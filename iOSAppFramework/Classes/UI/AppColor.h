//
//  AppColor.h
//  pandafit
//
//  Created by FanChunxing on 16/2/21.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppColor : NSObject

@end

@interface UIColor(AppColor)

+ (instancetype)colorWithHex:(UInt32)color;

@end
