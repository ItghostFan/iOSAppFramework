//
//  NSInvocation+iOS.h
//  Pods
//
//  Created by FanChunxing on 2017/7/6.
//
//

#import <Foundation/Foundation.h>

@interface NSInvocation (iOS)

+ (instancetype)invocationWithSelector:(SEL)selector prototype:(Class)prototype, ...;

- (id)getReturnValue;

@end
