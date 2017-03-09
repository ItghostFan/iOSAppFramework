//
//  UIImage+Framework.h
//  Pods
//
//  Created by FanChunxing on 2017/3/8.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIImageObliqueSide) {
    UIIMAGE_OBLIQUE_TOP_LEFT        = 0,        // clip◤
    UIIMAGE_OBLIQUE_TOP_RIGHT       = 1,        // clip◥
    UIIMAGE_OBLIQUE_BOTTOM_RIGHT    = 2,        // clip◢
    UIIMAGE_OBLIQUE_BOTTOM_LEFT     = 3,        // clip◣
};

@interface UIImage (Framework)

- (UIImage *)makeScale:(CGFloat)scale;
- (UIImage *)makeCircle;
- (UIImage *)makeOblique:(CGFloat)clipWidth size:(CGSize)size side:(UIImageObliqueSide)side;

@end
