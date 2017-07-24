//
//  UIImage+Framework.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/3/8.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSInvocation+iOS.h"

typedef NS_ENUM(NSUInteger, UIImageObliqueSide) {
    UIIMAGE_OBLIQUE_TOP_LEFT        = 0,        // clip◤
    UIIMAGE_OBLIQUE_TOP_RIGHT       = 1,        // clip◥
    UIIMAGE_OBLIQUE_BOTTOM_RIGHT    = 2,        // clip◢
    UIIMAGE_OBLIQUE_BOTTOM_LEFT     = 3,        // clip◣
};

@interface ImageEffectsStrategy : NSObject
@property (strong, nonatomic, readonly) NSArray<__kindof NSInvocation *> *effects;

- (instancetype)initWithEffects:(NSArray<__kindof NSInvocation *> *)effects;

@end

@interface UIImage (Framework)

- (UIImage *)makeScale:(CGFloat)scale;
- (UIImage *)makeCircle;
- (UIImage *)makeGray;
- (UIImage *)makeOblique:(CGFloat)clipWidth size:(CGSize)size side:(UIImageObliqueSide)side;

@end
