//
//  AppView.m
//  IosStudy
//
//  Created by FanChunxing on 16/1/30.
//  Copyright © 2016年 tt. All rights reserved.
//

#import "AppView.h"

@implementation AppView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation UIView(AppView)

- (void)setLeft:(CGFloat)left
{
    CGRect frame = CGRectMake(left, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = CGRectMake(right - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.width);
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (UIImage *)snapshotImage:(CGRect)snapshotFrame
               scaleFactor:(CGFloat)scaleFactor
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, scaleFactor);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* snapshotImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, snapshotFrame)];
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end