//
//  JsonHelper.h
//  pandafit
//
//  Created by Fanchunxing on 15/2/9.
//  Copyright (c) 2015年 pandafit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(NSObject)

- (NSString *)JsonString;

- (NSDictionary *)toDictionary;

+ (id)Json:(NSString *)jsonString;

@end

@interface NSDictionary(JsonHelper)

- (NSString *)JSONString;

@end

