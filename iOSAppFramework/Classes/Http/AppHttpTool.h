//
//  HttpLiberty.h
//  pandafit
//
//  Created by Fanchunxing on 15/7/16.
//  Copyright (c) 2015年 pandafit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFINE_APP_HTTP(key) \
static NSString * const _Nonnull APP_HTTP_##key = @"APP_HTTP_"#key;

DEFINE_APP_HTTP(PROTOCOL)                       // NSString
DEFINE_APP_HTTP(METHOD)                         // @"POST"|@"GET"
DEFINE_APP_HTTP(DOMAIN)                         // NSString
DEFINE_APP_HTTP(PORT)                           // NSNumber
DEFINE_APP_HTTP(PATH)                           // NSString
DEFINE_APP_HTTP(BODY)                           // Dictionary
DEFINE_APP_HTTP(HEADER)                         // Dictionary
DEFINE_APP_HTTP(ACCEPTABLE_CONTENT_TYPES)       // NSSet

#define APP_HTTP_KEY(key) APP_HTTP_##key

@interface AppHttpTool : NSObject

+ (nonnull instancetype)globalObject;
//
//- (BOOL)request:(nonnull NSDictionary *)httpParameter
//     completion:(nullable void (^)(NSError* _Nullable error, id _Nullable result))completion;

- (BOOL)request:(nonnull NSString *)url
         method:(nonnull NSString *)method
         header:(nullable NSDictionary *)header
           body:(nullable NSDictionary *)body
acceptableContentTypes:(nullable NSSet *)acceptableContentTypes
     completion:(nullable void (^)(NSError* _Nullable error, id _Nullable result))completion;

@end
