//
//  NSObject+iOS.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/1/17.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SAFE_INVOKE_BLOCK(block, ...) \
if(block) { \
    block(__VA_ARGS__); \
}

@interface NSObject (iOS)

+ (NSString *)className;

@end
