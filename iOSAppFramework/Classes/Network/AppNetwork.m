//
//  AppNetwork.m
//  pandafit
//
//  Created by FanChunxing on 16/4/3.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import "Reachability.h"

#import "AppObject.h"
#import "AppNetwork.h"

@interface AppNetwork()

@property (strong, nonatomic) Reachability* reachability;

@end

@implementation AppNetwork

#pragma mark - super

- (instancetype)init
{
    self = [super init];
    
    [self addNotification:@selector(onReachabilityChanged:)
                     name:kReachabilityChangedNotification
                   object:nil];
    
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    
    return self;
}

- (void)dealloc
{
    [self removeNotification:kReachabilityChangedNotification object:nil];
    [self removeAllNotifications];
}

#pragma mark - self public

- (AppNetworkStatus)networkStatus
{
    return (AppNetworkStatus)_reachability.currentReachabilityStatus;
}

#pragma mark - Notifications

- (void)onReachabilityChanged:(NSNotification *)notification
{
//    Reachability* reachability = [notification object];
//    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:M_AppNetworkStatus
                                                        object:self];
}

@end
