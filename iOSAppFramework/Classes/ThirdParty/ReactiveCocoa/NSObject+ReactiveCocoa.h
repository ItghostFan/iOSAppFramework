//
//  NSObject+ReactiveCocoa.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/1/17.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveCocoa/ReactiveCocoa.h"

#define UN_USED_OBJ(index, context, object) \
(void)object;

#define UN_USED(...) \
metamacro_foreach_cxt(UN_USED_OBJ, , , __VA_ARGS__)

@interface NSObject (ReactiveCocoa)

- (RACDisposable *)racObserveNotification:(NSString *)notificationName object:(id)object action:(void (^)(NSNotification *notification))action;
- (RACDisposable *)racObserveNotification:(NSString *)notificationName object:(id)object selector:(SEL)selector;
- (RACDisposable *)racObserveSelector:(SEL)selector object:(id)object next:(void (^)(RACTuple *tuple))next;
- (RACDisposable *)racObserveSelector:(SEL)selector fromProtocol:(Protocol *)fromProtocol object:(id)object next:(void (^)(RACTuple *tuple))next;
- (RACSignal *)racSelectorSignal:(SEL)selector;

@end
