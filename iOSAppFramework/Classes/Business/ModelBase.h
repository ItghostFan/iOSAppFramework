//
//  ModelBase.h
//  pandafit
//
//  Created by FanChunxing on 16/2/20.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

@interface ModelBase : NSObject

@property (strong, nonatomic, readonly) FMDatabaseQueue* databaseQueue;

- (void)initModel;
- (void)uninitModel;

/**
 * Impelement by subclass.
 */
- (NSString *)databaseFilePath;

@end
