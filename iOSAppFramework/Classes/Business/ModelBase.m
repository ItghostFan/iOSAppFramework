//
//  ModelBase.m
//  pandafit
//
//  Created by FanChunxing on 16/2/20.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <FMDB/FMDB.h>

#import "ModelBase.h"

@implementation ModelBase

- (void)initModel
{
    NSString* databaseFilePath = [self databaseFilePath];
    if (!databaseFilePath) {
        return;
    }
    NSString* sandboxPath = NSHomeDirectory();
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[sandboxPath stringByAppendingPathComponent:databaseFilePath]];
}

- (void)uninitModel
{
    [_databaseQueue close];
}

- (NSString *)databaseFilePath
{
    NSAssert(NO, @"%s should implemented by subclass", __FUNCTION__);
    return @"";
}

@end
