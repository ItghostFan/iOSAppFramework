//
//  AppLog.h
//  IosStudy
//
//  Created by FanChunxing on 16/3/29.
//  Copyright © 2016年 tt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AppLogLevelType)
{
    AppLogLevel_Debug,
    AppLogLevel_Info,
    AppLogLevel_Warning,
    AppLogLevel_Error,
};

@interface AppLog : NSObject

+ (AppLog *)appLog:(NSString *)logPath;

- (void)log:(const char *)function
       line:(NSUInteger)line
      level:(AppLogLevelType)level
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(4, 5);

- (void)closeLog;

@end
