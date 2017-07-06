//
//  FMDBRow.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/3/27.
//
//

#import "FMDB/FMDB.h"

#define FMDB_COLUMN(type) FMDBColumn##type

@protocol FMDB_COLUMN(String) <NSObject>
@end

@protocol FMDB_COLUMN(Double) <NSObject>
@end

@protocol FMDB_COLUMN(Bool) <NSObject>
@end

@protocol FMDB_COLUMN(UInt8) <NSObject>
@end

@protocol FMDB_COLUMN(UInt16) <NSObject>
@end

@protocol FMDB_COLUMN(UInt32) <NSObject>
@end

@protocol FMDB_COLUMN(UInt64) <NSObject>
@end

@protocol FMDB_COLUMN(Int8) <NSObject>
@end

@protocol FMDB_COLUMN(Int16) <NSObject>
@end

@protocol FMDB_COLUMN(Int32) <NSObject>
@end

@protocol FMDB_COLUMN(Int64) <NSObject>
@end

@interface NSObject (FMDBRow)
<
FMDB_COLUMN(String),
FMDB_COLUMN(Double),
FMDB_COLUMN(Bool),
FMDB_COLUMN(UInt8),
FMDB_COLUMN(UInt16),
FMDB_COLUMN(UInt32),
FMDB_COLUMN(UInt64),
FMDB_COLUMN(Int8),
FMDB_COLUMN(Int16),
FMDB_COLUMN(Int32),
FMDB_COLUMN(Int64)>
@end

@interface FMDBRow : NSObject

+ (NSMutableArray *)result:(FMResultSet *)resultSet;

@end
