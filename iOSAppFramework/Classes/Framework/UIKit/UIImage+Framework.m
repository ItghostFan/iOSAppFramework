//
//  UIImage+Framework.m
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/3/8.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "UIImage+Framework.h"

@interface ImageEffectsStrategy ()
@property (strong, nonatomic, readwrite) NSArray<__kindof NSInvocation *> *effects;
@end

@implementation ImageEffectsStrategy

- (instancetype)initWithEffects:(NSArray<__kindof NSInvocation *> *)effects {
    if (self = [super init]) {
        self.effects = effects;
    }
    return self;
}

@end

@implementation UIImage (Framework)

- (UIImage *)makeScale:(CGFloat)scale {
    CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)makeCircle {
    CGSize imageSize = CGSizeMake(MIN(self.size.height, self.size.width), MIN(self.size.height, self.size.width));
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, YES);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [self drawInRect:rect];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}

- (UIImage *)makeGray {
    CGSize imageSize = CGSizeMake(MIN(self.size.height, self.size.width), MIN(self.size.height, self.size.width));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, imageSize.width, imageSize.height, 8, 0, colorSpace,kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height), self.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    return grayImage;
}

- (UIImage *)makeOblique:(CGFloat)clipWidth size:(CGSize)size side:(UIImageObliqueSide)side {
    // @nX convert
    size = CGSizeMake(size.width * self.scale, size.height * self.scale);
    clipWidth *= self.scale;
    CGSize originSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    
    CGSize innerTargetSize = originSize;
    CGFloat leftClip = 0.0f;
    CGFloat topClip = 0.0f;
    if ((originSize.width / size.width) >= (originSize.height / size.height)) {
        CGFloat widthNew = originSize.height / size.height * size.width;
        innerTargetSize.width = widthNew;
        leftClip = (originSize.width - widthNew) / 2.0;
    } else {
        CGFloat heigthNew = originSize.width / size.width * size.height;
        innerTargetSize.height = heigthNew;
        topClip = (originSize.height - heigthNew) / 2.0;
    }
    CGFloat innerClipWidth = clipWidth * innerTargetSize.width / size.width;
    
    CGImageRef subImgRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(leftClip, topClip, innerTargetSize.width, innerTargetSize.height));
    
    UIGraphicsBeginImageContext(innerTargetSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint points[4];
    // top-left
    points[0] = CGPointMake(side == UIIMAGE_OBLIQUE_TOP_LEFT ? innerClipWidth : 0.0f, 0.0f);
    // top-right
    points[1] = CGPointMake(side == UIIMAGE_OBLIQUE_TOP_RIGHT ? innerTargetSize.width - innerClipWidth : innerTargetSize.width, 0.0f);
    // bottom-right
    points[2] = CGPointMake(side == UIIMAGE_OBLIQUE_BOTTOM_RIGHT ? innerTargetSize.width - innerClipWidth : innerTargetSize.width, innerTargetSize.height);
    // bottom-left
    points[3] = CGPointMake(side == UIIMAGE_OBLIQUE_BOTTOM_LEFT ? innerClipWidth : 0.0f, innerTargetSize.height);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLines(context, points, 4);
    CGContextClip(context);
    
    CGContextTranslateCTM(context, 0, originSize.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, innerTargetSize.width, innerTargetSize.height), subImgRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // @nX convert
    return [image makeScale:1.0f / self.scale];
}

@end
