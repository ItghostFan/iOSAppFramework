//
//  JsonHelper.m
//  pandafit
//
//  Created by Fanchunxing on 15/2/9.
//  Copyright (c) 2015年 pandafit. All rights reserved.
//

#import <objc/runtime.h>

#import "JsonHelper.h"

@implementation NSObject(JsonHelper)

- (NSString *)JsonString:(id)object
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)toDictionary;
{
    NSMutableDictionary* objectDictionary = [NSMutableDictionary dictionary];
    
    unsigned propertyCount;
    objc_property_t* properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i = 0; i < propertyCount; ++i) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [objectDictionary setObject:[self valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:objectDictionary];
}

+ (id)Json:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

@end


@implementation NSDictionary(JsonHelper)

- (NSString *)JSONString;
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

@end