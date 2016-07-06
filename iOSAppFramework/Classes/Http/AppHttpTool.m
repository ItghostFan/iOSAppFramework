//
//  HttpLiberty.m
//  pandafit
//
//  Created by Fanchunxing on 15/7/16.
//  Copyright (c) 2015年 pandafit. All rights reserved.
//

#import "AFNetWorking.h"

#import "AppDefine.h"

#import "AppHttpTool.h"

static AppHttpTool* g_globalObject = nil;

@interface AppHttpTool()

@end

@implementation AppHttpTool

+ (AppHttpTool *)globalObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_globalObject = [[AppHttpTool alloc] init];
    });
    
    return g_globalObject;
}

- (AppHttpTool *)init
{
    return self;
}

- (BOOL)request:(nonnull NSDictionary *)httpParameter
     completion:(nullable void (^)(NSError* _Nullable error, id _Nullable result))completion
{
    NSString* protocol = [httpParameter objectForKey:APP_HTTP_KEY(PROTOCOL)];
    NSString* domain = [httpParameter objectForKey:APP_HTTP_KEY(DOMAIN)];
    NSString* path = [httpParameter objectForKey:APP_HTTP_KEY(PATH)];
    NSNumber* port = [httpParameter objectForKey:APP_HTTP_KEY(PORT)];
    NSString* method = [httpParameter objectForKey:APP_HTTP_KEY(METHOD)];
    NSDictionary* body = [httpParameter objectForKey:APP_HTTP_KEY(BODY)];
    NSDictionary* header = [httpParameter objectForKey:APP_HTTP_KEY(HEADER)];
    NSSet* acceptableContentTypes = [httpParameter objectForKey:APP_HTTP_KEY(ACCEPTABLE_CONTENT_TYPES)];
    
    NSString* url;
    if (port) {
        url = [NSString stringWithFormat:@"%@://%@:%@%@", protocol, domain, port, path];
    }
    else {
        url = [NSString stringWithFormat:@"%@://%@%@", protocol, domain, path];
    }
    
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    for (NSString* headerField in header.allKeys) {
        [serializer setValue:header[headerField] forHTTPHeaderField:headerField];
    }
    NSError* error;
    NSMutableURLRequest *request = [serializer requestWithMethod:method
                                                       URLString:url
                                                      parameters:body
                                                           error:&error];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPResponseSerializer* sesponseSerializer = [AFHTTPResponseSerializer serializer];
    
    sesponseSerializer.acceptableContentTypes = acceptableContentTypes;//[NSSet setWithObject:@"text/html"];
    
    manager.responseSerializer = sesponseSerializer;
    
    NSURLSessionDataTask* task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"AppHttp Error: %@", error);
        }
        if (completion) {
            completion(error, responseObject);
        }
    }];
    [task resume];
    
    return true;
}

- (BOOL)request:(nonnull NSString *)url
         method:(nonnull NSString *)method
         header:(nullable NSDictionary *)header
           body:(nullable NSDictionary *)body
acceptableContentTypes:(nullable NSSet *)acceptableContentTypes
     completion:(nullable void (^)(NSError* _Nullable error, id _Nullable result))completion
{
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    for (NSString* headerField in header.allKeys) {
        [serializer setValue:header[headerField] forHTTPHeaderField:headerField];
    }
    NSError* error;
    NSMutableURLRequest *request = [serializer requestWithMethod:method
                                                       URLString:url
                                                      parameters:body
                                                           error:&error];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPResponseSerializer* sesponseSerializer = [AFHTTPResponseSerializer serializer];
    
    sesponseSerializer.acceptableContentTypes = acceptableContentTypes;//[NSSet setWithObject:@"text/html"];
    
    manager.responseSerializer = sesponseSerializer;
    
    NSURLSessionDataTask* task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"AppHttp Error: %@", error);
        }
        if (completion) {
            completion(error, responseObject);
        }
    }];
    [task resume];
    
    return true;
}

@end
