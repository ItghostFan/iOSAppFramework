//
//  NSThread+iOS.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/2/20.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "NSObject+iOS.h"

#define SAFE_INVOKE_BLOCK_IN_MAIN_THREAD(block, ...) \
if ([NSThread isMainThread])\
{ \
    SAFE_INVOKE_BLOCK(block, __VA_ARGS__); \
} \
else \
{ \
    dispatch_async(dispatch_get_main_queue(), ^{ \
        SAFE_INVOKE_BLOCK(block, __VA_ARGS__); \
    }); \
}

@interface NSThread (iOS)

@end
