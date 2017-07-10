//
//  FMDBRow.m
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/3/27.
//
//

#import "FMDBRow.h"

#import <objc/runtime.h>

#import "ObjectProperty.h"
#import "NSInvocation+iOS.h"

@implementation FMDBRow

+ (NSMutableArray *)result:(FMResultSet *)resultSet {
    @autoreleasepool {
        
    }
    NSMutableArray *result = nil;
    NSDictionary *properties = [ObjectProperty parsePropertiesInMap:self.class];
    NSError *error;
    while ([resultSet nextWithError:&error]) {
        if (!result) {
            result = [NSMutableArray new];
        }
        id row = [self.class new];
        [result addObject:row];
        for (NSString *columnName in properties.allKeys) {
            ObjectProperty *property = properties[columnName];
            Ivar var = class_getInstanceVariable(self.class, property.ivarName);
            SEL selector = [self selectorForType:property.type];
            NSMethodSignature *methodSignature = [FMResultSet.class instanceMethodSignatureForSelector:selector];
            if (methodSignature) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                invocation.target = resultSet;
                invocation.selector = selector;
                [invocation setArgument:(void *)&columnName atIndex:2];
                [invocation invoke];
                
//                id columnValue = [NSString stringWithFormat:@"%@", @"123"];
//                if (!strcmp(methodSignature.methodReturnType, @encode(id))) {
//                    [invocation getReturnValue:&columnValue];
//                }
//                else if (methodSignature.methodReturnLength) {
//                    void *value = malloc(methodSignature.methodReturnLength);
//                    [invocation getReturnValue:value];
//                    columnValue = [self objectForType:property.type withValue:value];
//                    free(value);
//                }
//                
//                if (columnValue) {
//                    object_setIvar(row, var, [columnValue copy]);
//                }
                id columnValue = [invocation getReturnValue];
                object_setIvar(row, var, columnValue);
            }
        }
    }
    
    return result;
}

+ (SEL)selectorForType:(const char *)propertyType {
    NSString *columnType;
    const char * leftBracket = strchr(propertyType, '<');
    if (leftBracket) {
        const char * rightBracket = strrchr(leftBracket, '>');
        if (rightBracket) {
            columnType = [[NSString alloc] initWithBytes:leftBracket + 1 length:strlen(leftBracket) - 2 encoding:NSASCIIStringEncoding];
        }
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(String)))]) {
        return @selector(stringForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Bool)))]) {
        return @selector(boolForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(UInt8)))]) {
        return @selector(intForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(UInt16)))]) {
        return @selector(intForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(UInt32)))]) {
        return @selector(unsignedLongLongIntForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(UInt64)))]) {
        return @selector(unsignedLongLongIntForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Double)))]) {
        return @selector(doubleForColumnIndex:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Int8)))]) {
        return @selector(intForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Int16)))]) {
        return @selector(intForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Int32)))]) {
        return @selector(longLongIntForColumn:);
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Int64)))]) {
        return @selector(longLongIntForColumn:);
    }
    return nil;
}

+ (id)objectForType:(const char *)propertyType withValue:(void *)value {
    NSString *columnType;
    const char * leftBracket = strchr(propertyType, '<');
    if (leftBracket) {
        const char * rightBracket = strrchr(leftBracket, '>');
        if (rightBracket) {
            columnType = [[NSString alloc] initWithBytes:leftBracket + 1 length:strlen(leftBracket) - 2 encoding:NSASCIIStringEncoding];
        }
    }
//    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(String)))]) {
//        return [NSString class];
//    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Bool)))]) {
        return [NSNumber numberWithBool:*(BOOL *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(UInt8)))]) {
        return [NSNumber numberWithUnsignedChar:*(unsigned char *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(UInt16)))]) {
        return [NSNumber numberWithUnsignedShort:*(unsigned short *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(UInt32)))]) {
        return [NSNumber numberWithUnsignedInt:*(unsigned int *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(UInt64)))]) {
        return [NSNumber numberWithUnsignedLongLong:*(unsigned long long *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Double)))]) {
        return [NSNumber numberWithDouble:*(double *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Int8)))]) {
        return [NSNumber numberWithChar:*(char *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Int16)))]) {
        return [NSNumber numberWithShort:*(short *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Int32)))]) {
        return [NSNumber numberWithInt:*(int *)value];
    }
    if ([columnType isEqualToString:NSStringFromProtocol(@protocol(FMDB_COLUMN(Int64)))]) {
        return [NSNumber numberWithLongLong:*(long long*)value];
    }
    return nil;
}

@end
