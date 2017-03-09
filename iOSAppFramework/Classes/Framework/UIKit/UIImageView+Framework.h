//
//  UIImageView+Theme.h
//  yyliveworld
//
//  Created by FanChunxing on 16/9/7.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReactiveCocoa/ReactiveCocoa.h"
#import "SDWebImage/UIImageView+WebCache.h"

#import "UIImage+Framework.h"

@interface SDWebImageManager (Framewrok)
+ (SDImageCache *)themeSquareImageCache;
- (RACSignal *)racDownLoadImageWith:(NSString *)url imageCache:(SDImageCache *)imageCache beforeCache:(UIImage * (^)(UIImage *image, NSString *url))beforeCache;
@end

@interface UIImageView (Framewrok)

- (RACSignal *)loadCircleAvatarWith:(NSString *)url placeHolder:(UIImage *)placeHolder;
- (RACSignal *)loadSquareAvatarWith:(NSString *)url placeHolder:(UIImage *)placeHolder;
- (RACSignal *)loadCoverWith:(NSString *)url placeHolder:(UIImage *)placeHolder;
- (RACSignal *)loadObliqueCoverWith:(NSString *)url clipWidth:(CGFloat)clipWidth size:(CGSize)size side:(UIImageObliqueSide)side placeHolder:(UIImage *)placeHolder;
- (void)cancelLoad;

@end
