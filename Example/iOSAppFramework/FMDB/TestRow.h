//
//  TestRow.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/7/5.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "iOSAppFramework/FMDBRow.h"

@interface TestRow : FMDBRow

@property (strong, nonatomic) NSString<FMDB_COLUMN(String)> *name;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(Double)> *columnDouble;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(Bool)> *columnBool;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(UInt8)> *columnUInt8;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(UInt16)> *columnUInt16;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(UInt32)> *columnUInt32;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(UInt64)> *columnUInt64;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(Int8)> *columnInt8;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(Int16)> *columnInt16;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(Int32)> *columnInt32;
@property (strong, nonatomic) NSNumber<FMDB_COLUMN(Int64)> *columnInt64;

@end
