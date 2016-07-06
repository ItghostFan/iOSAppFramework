//
//  AppDefine.h
//  pandafit
//
//  Created by FanChunxing on 16/1/30.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#pragma once

#define UNUSED(object) (void)object;

#pragma mark - App Singletion

#define APP_SINGLETON_CLASS(class) \
static class* g_shareInstance;

#define APP_SINGLETON_CLASS_IMPLEMENT(class) \
+ (instancetype)shareInstance\
{\
NSString* format = [[NSString alloc] initWithFormat:@"%@ shareInstance is %%@.", @#class];\
UNUSED(format)\
NSAssert(g_shareInstance != nil, format, g_shareInstance);\
return g_shareInstance;\
}\
\
- (instancetype)init\
{\
self = [super init];\
NSString* format = [[NSString alloc] initWithFormat:@"%@ has an instance %%@.", @#class];\
UNUSED(format)\
NSAssert(g_shareInstance == nil, format, g_shareInstance);\
g_shareInstance = self;\
return self;\
}

#pragma mark - Block weak reference

#define WeakSelf(name) __weak typeof(self) name = self;

#pragma mark - Debug

#ifdef DEBUG
#define DEBUG_DEALLOC() \
- (void)dealloc \
{ \
    NSLog(@"%s %@", __FUNCTION__, self); \
}
#else
#define DEBUG_DEALLOC()
#endif
