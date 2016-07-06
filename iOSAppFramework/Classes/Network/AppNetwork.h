//
//  AppNetwork.h
//  pandafit
//
//  Created by FanChunxing on 16/4/3.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* M_AppNetworkStatus         = @"AppNetworkStatus";

typedef NS_ENUM(NSUInteger, AppNetworkStatus) {
    Network_Disconnect = 0,
    Network_WiFi,
    Network_WWAN,
};

@interface AppNetwork : NSObject

@property (assign, nonatomic) AppNetworkStatus networkStatus;

@end
