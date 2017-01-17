//
//  NSObject+ReactiveCocoa.m
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/1/17.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "NSObject+ReactiveCocoa.h"

#import <objc/runtime.h>
#import <objc/message.h>

static const char *kSelectorDisposables = "SelectorDisposables";
static const char *kNotificationDisposables = "NotificationDisposables";

@implementation NSObject (ReactiveCocoa)

- (RACDisposable *)racObserveNotification:(NSString *)notificationName object:(id)object action:(void (^)(NSNotification *notification))action {
    
    RACDisposable *disposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:notificationName object:object] subscribeNext:action];
    RACCompoundDisposable *notificationDisposables = objc_getAssociatedObject(self, kNotificationDisposables);
    if (notificationDisposables == nil) {
        notificationDisposables = [RACCompoundDisposable compoundDisposable];
        objc_setAssociatedObject(self, kNotificationDisposables, notificationDisposables, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.rac_willDeallocSignal subscribeCompleted:^{
            if (!notificationDisposables.disposed) {
                [notificationDisposables dispose];
            }
        }];
    }
    [notificationDisposables addDisposable:disposable];
    return disposable;
}

- (RACDisposable *)racObserveNotification:(NSString *)notificationName object:(id)object selector:(SEL)selector {
    @weakify(self);
    return [self racObserveNotification:notificationName object:object action:^(NSNotification *notification) {
        @strongify(self);
        IMP selectorImp = [self methodForSelector:selector];
        NSAssert(selectorImp, @"%@.%s not exist!", NSStringFromClass([self class]), sel_getName(selector));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:notification];
#pragma clang diagnostic pop
    }];
}

- (RACDisposable *)racObserveSelector:(SEL)selector object:(id)object next:(void (^)(RACTuple *tuple))next {
    RACDisposable *disposable = [[object rac_signalForSelector:selector] subscribeNext:next];
    RACCompoundDisposable *selectorDisposables = objc_getAssociatedObject(self, kSelectorDisposables);
    if (selectorDisposables == nil) {
        selectorDisposables = [RACCompoundDisposable compoundDisposable];
        objc_setAssociatedObject(self, kSelectorDisposables, selectorDisposables, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.rac_willDeallocSignal subscribeCompleted:^{
            if (!selectorDisposables.disposed) {
                [selectorDisposables dispose];
            }
        }];
    }
    [selectorDisposables addDisposable:disposable];
    return disposable;
}

- (RACSignal *)racSelectorSignal:(SEL)selector {
    return [self rac_signalForSelector:selector];
}

@end
