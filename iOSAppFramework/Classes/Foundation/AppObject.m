//
//  AppObject.m
//  pandafit
//
//  Created by FanChunxing on 16/4/14.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <objc/runtime.h>

#import "AppObject.h"

#ifdef DEBUG
static const char* APP_NOTIFICATION_NAMES = "AppNotificationsNames";
#endif

@implementation NSObject(AppObject)

#pragma mark - Notifications

- (void)addNotification:(SEL)selector
                   name:(NSString *)name
                 object:(id)object
{
#ifdef DEBUG
    NSMutableSet* notificationNames = [self notificationsNames];
    [notificationNames addObject:name];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:name
                                               object:object];
}

- (void)removeNotification:(NSString *)name
                    object:(id)object
{
#ifdef DEBUG
    NSMutableSet* notificationNames = [self notificationsNames];
    [notificationNames removeObject:name];
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:object];
}

- (void)removeAllNotifications
{
#ifdef DEBUG
    NSMutableSet* notificationNames = [self notificationsNames];
    if (notificationNames.count) {
        NSAssert(NO, @"Remain notifications %@", notificationNames);
    }
    for (NSString* name in notificationNames) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:nil];
    }
    [notificationNames removeAllObjects];
#else
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}

#pragma mark - Class

- (NSString *)className
{
    Class selfClass = self.class;
    NSString* className = [NSString stringWithFormat:@"%s", class_getName(selfClass)];
    return className;
}

#pragma mark - Observer

- (void)toObserve:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)option context:(void *)context
{
    
}

#pragma mark - self private

#ifdef DEBUG

- (NSMutableSet *)notificationsNames
{
    NSMutableSet* notificationNames = objc_getAssociatedObject(self, APP_NOTIFICATION_NAMES);
    if (!notificationNames) {
        notificationNames = [NSMutableSet set];
        objc_setAssociatedObject(self, APP_NOTIFICATION_NAMES, notificationNames, OBJC_ASSOCIATION_RETAIN);
    }
    return notificationNames;
}

#endif

@end

@implementation AppObject

@end
