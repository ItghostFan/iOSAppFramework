//
//  UIImageView+Theme.m
//  yyliveworld
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

- (RACSignal *)racDownLoadImageWith:(NSString *)url imageCache:(SDImageCache *)imageCache beforeCache:(UIImage * (^)(UIImage *image, NSString *url))beforeCache {
    RACSignal *diskSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSOperation *operation = [imageCache queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
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
        id<SDWebImageOperation> operation = [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImage *effectImage = nil;
            
            NSAssert([NSThread isMainThread], @"%@ not in main thread!", [UIImageView class]);
            
            if (beforeCache) {
                effectImage = beforeCache(image, imageURL.absoluteString);
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
//        ++retryTime;
//        if (retryTime == 1) {
//            return [diskSignal subscribeNext:^(id x) {
//                [subscriber sendNext:x];
//                [subscriber sendCompleted];
//            } error:^(NSError *error) {
//                [subscriber sendError:error];
//            }];
//        }
//        if (retryTime == 2) {
//            return [networkSignal subscribeNext:^(id x) {
//                [subscriber sendNext:x];
//                [subscriber sendCompleted];
//            } error:^(NSError *error) {
//                [subscriber sendError:error];
//            }];
//        }
        
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
    [self cancelLoad];
    self.image = placeHolder;
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *disposable = [[[SDWebImageManager sharedManager] racDownLoadImageWith:url imageCache:[SDWebImageManager themeCircleImageCache] beforeCache:^UIImage *(UIImage *image, NSString *url) {
            UIImage *effectImage = [image makeCircle];
            [[SDWebImageManager themeCircleImageCache] storeImage:effectImage forKey:url];
            return effectImage;
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

- (RACSignal *)loadSquareAvatarWith:(NSString *)url placeHolder:(UIImage *)placeHolder {
    @weakify(self);
    self.image = placeHolder;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *disposable = [[[SDWebImageManager sharedManager] racDownLoadImageWith:url imageCache:[SDWebImageManager themeSquareImageCache] beforeCache:nil] subscribeNext:^(UIImage *image) {
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

- (RACSignal *)loadCoverWith:(NSString *)url placeHolder:(UIImage *)placeHolder {
    [self cancelLoad];
    self.image = placeHolder;
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *disposable = [[[SDWebImageManager sharedManager] racDownLoadImageWith:url imageCache:[SDWebImageManager themeImageCache] beforeCache:nil] subscribeNext:^(UIImage *image) {
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

- (RACSignal *)loadObliqueCoverWith:(NSString *)url clipWidth:(CGFloat)clipWidth size:(CGSize)size side:(UIImageObliqueSide)side placeHolder:(UIImage *)placeHolder {
    [self cancelLoad];
    self.image = placeHolder;
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *disposable = [[[SDWebImageManager sharedManager] racDownLoadImageWith:url imageCache:[SDWebImageManager obliqueImageCache] beforeCache:^UIImage *(UIImage *image, NSString *url) {
            UIImage *effectImage = [image makeOblique:clipWidth size:size side:side];
            [[SDWebImageManager obliqueImageCache] storeImage:effectImage forKey:url];
            return effectImage;
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
