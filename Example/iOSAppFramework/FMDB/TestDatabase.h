//
//  TestDatabase.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/7/5.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveCocoa/ReactiveCocoa.h"

#import "TestRow.h"

@interface TestDatabase : NSObject

- (RACSignal *)intoTable:(TestRow *)row;
- (RACSignal *)queryTable;

@end
