//
//  TestDatabase.m
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/7/5.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "TestDatabase.h"

#import "FMDB/FMDB.h"
#import "iOSAppFramework/NSThread+iOS.h"

@interface TestDatabase ()
@property (strong, nonatomic) FMDatabaseQueue *databaseQueue;
@property (strong, nonatomic) dispatch_queue_t worker;
@end

@implementation TestDatabase

- (instancetype)init {
    if (self = [super init]) {
        [self initDatabase];
    }
    return self;
}

- (void)dealloc {
    [_databaseQueue close];
}

- (void)initDatabase {
    dispatch_async(self.worker, ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
            if (![db executeStatements:@"create table if not exists test(name text, columnDouble float, columnBool boolean, columnUInt8 integer, columnUInt16 integer, columnUInt32 integer, columnUInt64 integer, columnInt8 integer, columnInt16 integer, columnInt32 integer, columnInt64 integer)"]) {
                NSLog(@"Database init failed!");
            }
        }];
    });
}

- (FMDatabaseQueue *)databaseQueue {
    if (_databaseQueue) {
        return _databaseQueue;
    }
    NSString *databaseFilePath = nil;
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (documentDirectories.count) {
        NSString *directory = [documentDirectories.firstObject stringByAppendingPathComponent:@"db"];
        databaseFilePath = [directory stringByAppendingPathComponent:@"test"];
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return nil;
        }
    }
    _databaseQueue = [[FMDatabaseQueue alloc] initWithPath:databaseFilePath];
    return _databaseQueue;
}

- (dispatch_queue_t)worker {
    if (_worker) {
        return _worker;
    }
    _worker = dispatch_queue_create("test.db", DISPATCH_QUEUE_SERIAL);
    return _worker;
}

- (RACSignal *)intoTable:(TestRow *)row {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        dispatch_async(self.worker, ^{
            @strongify(self);
            [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                NSError *error = nil;
                *rollback = ![db executeUpdate:@"insert or replace into test values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" withErrorAndBindings:&error, row.name,
                 row.columnDouble, row.columnBool, row.columnUInt8, row.columnUInt16, row.columnUInt32, row.columnUInt64, row.columnInt8, row.columnInt16, row.columnInt32, row.columnInt64];
                void (^result)() = ^() {
                    if (!error) {
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                    else {
                        [subscriber sendError:error];
                    }
                };
                SAFE_INVOKE_BLOCK_IN_MAIN_THREAD(result);
            }];
        });
        return nil;
    }];
}

- (RACSignal *)queryTable {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        dispatch_async(self.worker, ^{
            @strongify(self);
            [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                FMResultSet *resultSet = [db executeQuery:@"select * from test"];
                NSError *error = db.lastError;
                NSMutableArray *rows = nil;
                if (resultSet) {
                    rows = [TestRow result:resultSet];
                }
                void (^result)() = ^() {
                    if (resultSet) {
                        [subscriber sendNext:rows];
                        [subscriber sendCompleted];
                    }
                    else {
                        [subscriber sendError:error];
                    }
                };
                SAFE_INVOKE_BLOCK_IN_MAIN_THREAD(result);
            }];
        });
        return nil;
    }];
}

@end
