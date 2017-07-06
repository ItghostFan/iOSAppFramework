//
//  NSObject+ReactiveCocoa.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/1/17.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveCocoa/ReactiveCocoa.h"

@interface NSObject (ReactiveCocoa)

- (RACDisposable *)racObserveNotification:(NSString *)notificationName object:(id)object action:(void (^)(NSNotification *notification))action;
- (RACDisposable *)racObserveNotification:(NSString *)notificationName object:(id)object selector:(SEL)selector;
- (RACDisposable *)racObserveSelector:(SEL)selector object:(id)object next:(void (^)(RACTuple *tuple))next;

@end
