//
//  UIImageView+Theme.m
//  iOSAppFramework
//
//  Created by FanChunxing on 16/9/7.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "UIImageView+Framework.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "UIImage+Framework.h"


static const char *kLoadImageDisposable         = "LoadImageDisposable";

@implementation SDWebImageManager (Theme)

+ (SDImageCache *)themeCircleImageCache {
    static SDImageCache *themeImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!themeImageCache) {
            themeImageCache = [[SDImageCache alloc] initWithNamespace:@"Circle+Theme"];
        }
    });
    return themeImageCache;
}

+ (SDImageCache *)themeCircleGrayImageCache {
    static SDImageCache *themeImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!themeImageCache) {
            themeImageCache = [[SDImageCache alloc] initWithNamespace:@"Circle+Gray+Theme"];
        }
    });
    return themeImageCache;
}

+ (SDImageCache *)themeSquareImageCache {
    static SDImageCache *themeImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!themeImageCache) {
            themeImageCache = [[SDImageCache alloc] initWithNamespace:@"Square+Theme"];
        }
    });
    return themeImageCache;
}

+ (SDImageCache *)themeImageCache {
    static SDImageCache *themeImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!themeImageCache) {
            themeImageCache = [[SDImageCache alloc] initWithNamespace:@"UIImageView+Theme"];
        }
    });
    return themeImageCache;
}

+ (SDImageCache *)obliqueImageCache {
    static SDImageCache *themeImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!themeImageCache) {
            themeImageCache = [[SDImageCache alloc] initWithNamespace:@"Oblique+Theme"];
        }
    });
    return themeImageCache;
}

- (RACSignal *)racDownLoadImageWith:(NSURL *)url imageCache:(SDImageCache *)imageCache beforeCache:(UIImage * (^)(UIImage *image, NSURL *url))beforeCache {
    RACSignal *diskSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSOperation *operation = [imageCache queryCacheOperationForKey:url.absoluteString done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
            if (image) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:nil];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
    
    RACSignal *networkSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        id<SDWebImageOperation> operation = [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *effectImage = nil;
            
            NSAssert([NSThread isMainThread], @"%@ not in main thread!", [UIImageView class]);
            
            if (beforeCache) {
                effectImage = beforeCache(image, imageURL);
            }
            else {
                effectImage = image;
            }
            
            if (!error) {
                [subscriber sendNext:effectImage];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
    __block int retryTime = 0;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [diskSignal subscribeNext:^(id x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [networkSignal subscribeNext:^(id x) {
                [subscriber sendNext:x];
                [subscriber sendCompleted];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            }];
        }];
        return nil;
    }];
}

@end

@implementation UIImageView (Theme)

- (RACSignal *)loadCircleAvatarWith:(NSString *)url placeHolder:(UIImage *)placeHolder {
    return [self loadImageWithUrl:[NSURL URLWithString:url] imageCache:[SDWebImageManager themeCircleImageCache] placeHolder:placeHolder strategy:[[ImageEffectsStrategy alloc] initWithEffects:@[[NSInvocation invocationWithSelector:@selector(makeCircle) prototype:[UIImage class]]]]];
}

- (RACSignal *)loadCircleGrayAvatarWith:(NSString *)url placeHolder:(UIImage *)placeHolder {
    return [self loadImageWithUrl:[NSURL URLWithString:url] imageCache:[SDWebImageManager themeCircleGrayImageCache] placeHolder:placeHolder strategy:[[ImageEffectsStrategy alloc] initWithEffects:@[[NSInvocation invocationWithSelector:@selector(makeCircle) prototype:[UIImage class]], [NSInvocation invocationWithSelector:@selector(makeGray) prototype:[UIImage class]]]]];
}

- (RACSignal *)loadSquareAvatarWith:(NSString *)url placeHolder:(UIImage *)placeHolder {
    return [self loadImageWithUrl:[NSURL URLWithString:url] imageCache:[SDWebImageManager themeSquareImageCache] placeHolder:placeHolder strategy:nil];
}

- (RACSignal *)loadCoverWith:(NSString *)url placeHolder:(UIImage *)placeHolder {
    return [self loadImageWithUrl:[NSURL URLWithString:url] imageCache:[SDWebImageManager themeImageCache] placeHolder:placeHolder strategy:nil];
}

- (RACSignal *)loadObliqueCoverWith:(NSString *)url clipWidth:(CGFloat)clipWidth size:(CGSize)size side:(UIImageObliqueSide)side placeHolder:(UIImage *)placeHolder {
    return [self loadImageWithUrl:[NSURL URLWithString:url] imageCache:[SDWebImageManager obliqueImageCache] placeHolder:placeHolder strategy:[[ImageEffectsStrategy alloc] initWithEffects:@[[NSInvocation invocationWithSelector:@selector(makeOblique:size:side:) prototype:[UIImage class], &clipWidth, &size, &side]]]];
}

- (RACSignal *)loadImageWithUrl:(NSURL *)url
                     imageCache:(SDImageCache *)imageCache
                    placeHolder:(UIImage *)placeHolder
                       strategy:(ImageEffectsStrategy *)strategy {
    [self cancelLoad];
    self.image = placeHolder;
    @weakify(self);
    SDWebImageManager *imageManager;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *disposable = [[[SDWebImageManager sharedManager] racDownLoadImageWith:url imageCache:imageCache beforeCache:^UIImage *(UIImage *image, NSURL *url) {
            for (NSInvocation *invocation in strategy.effects) {
                [invocation invokeWithTarget:image];
                image = [invocation getReturnValue];
            }
            [imageCache storeImage:image forKey:url.absoluteString toDisk:YES completion:nil];
            return image;
        }] subscribeNext:^(UIImage *image) {
            @strongify(self);
            self.image = image;
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        @strongify(self);
        objc_setAssociatedObject(self, kLoadImageDisposable, disposable, OBJC_ASSOCIATION_RETAIN);
        return disposable;
    }];
}

- (void)cancelLoad {
    RACDisposable *disposable = objc_getAssociatedObject(self, kLoadImageDisposable);
    [disposable dispose];
    objc_setAssociatedObject(self, kLoadImageDisposable, nil, OBJC_ASSOCIATION_RETAIN);
}

@end
