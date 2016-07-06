//
//  AppObject.h
//  pandafit
//
//  Created by FanChunxing on 16/4/14.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(AppObject)

#pragma mark - Notification

- (void)addNotification:(SEL)selector
                   name:(NSString *)name
                 object:(id)object;

/**
 * Recommend use removeNotification method.
 */
- (void)removeNotification:(NSString *)name
                    object:(id)object;

/**
 * Don't recommend use removeAllNotifications method.
 * On release just for use habit.
 */
- (void)removeAllNotifications;

#pragma mark - Observer

- (void)toObserve:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)option context:(void *)context;

#pragma mark - Class

- (NSString *)className;

@end

@interface AppObject : NSObject

@end
