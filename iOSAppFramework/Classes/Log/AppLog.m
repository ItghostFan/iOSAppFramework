//
//  AppLog.m
//  IosStudy
//
//  Created by FanChunxing on 16/3/29.
//  Copyright © 2016年 tt. All rights reserved.
//

#import "AppDefine.h"
#import "AppLog.h"

static NSUInteger MaxCacheSize = 4096;
static NSUInteger MaxLogFileSize = 10 * 1024 * 1024;

@interface AppLog()

@property (strong, nonatomic) NSString* logPath;
@property (assign, atomic) FILE* logFile;
@property (strong, atomic) NSMutableData* cache;
@property (strong, atomic) dispatch_queue_t logQueue;

@end

@implementation AppLog

#pragma mark - super

- (void)dealloc
{
    [self closeFile];
}

#pragma mark - self public

+ (AppLog *)appLog:(NSString *)logPath
{
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:logPath isDirectory:&isDirectory]) {
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:logPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        NSLog(@"Create log file error: %@", error);
    }
    
    AppLog* appLog = [AppLog new];
    [appLog initWith:logPath];
    return appLog;
}

- (void)log:(const char *)function
       line:(NSUInteger)line
      level:(AppLogLevelType)level
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(4, 5)
{
    static NSDateFormatter* dateFormat;
    if (!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    }
    static NSString* APP_LOG_FORMAT = @"%@ [%@] %s (%lu) \n%@\n";
    va_list args;
    va_start(args, format);
    NSString* log = [NSString stringWithFormat:APP_LOG_FORMAT,
                     [dateFormat stringFromDate:[NSDate date]],
                     [self level:level],
                     function,
                     line,
                     [[NSString alloc] initWithFormat:format arguments:args]];
    va_end(args);
    [self asyncCacheToFile:log];
}

- (void)closeLog
{
    [self closeFile];
}

#pragma mark - self private

- (void)asyncOpenFile:(BOOL)create
{
    WeakSelf(weakSelf);
    dispatch_async(_logQueue, ^{
        [weakSelf openFile:(BOOL)create];
    });
}

- (void)openFile:(BOOL)create
{
    if ([NSThread currentThread].isMainThread) {
        NSAssert(NO, @"%s could not invoke main thread.", __FUNCTION__);
    }
    
    if (!create) {
        NSFileManager* fileManager = [NSFileManager new];
        NSArray<NSString *>* files = [fileManager subpathsAtPath:_logPath];
        if (files.count) {
            [files sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
                return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
            }];
            
            NSString* logFilePath = [NSString stringWithFormat:@"%@/%@", _logPath, files.lastObject];
            NSError* error;
            NSDictionary<NSString *, id>* attributes = [fileManager attributesOfItemAtPath:logFilePath error:&error];
            if (!error) {
                NSNumber* fileSize = [attributes objectForKey:NSFileSize];
                if (fileSize.unsignedLongLongValue < MaxLogFileSize) {
                    _logFile = fopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+b");
                    NSAssert(_logFile, @"%@, open failed.", files.firstObject);
                    return;
                }
            }
        }
    }
    
    static NSDateFormatter* dateFormat;
    if (!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    }
    NSString* logFilePath = [NSString stringWithFormat:@"%@/%@.txt", _logPath, [dateFormat stringFromDate:[NSDate date]]];
    _logFile = fopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+b");
    NSLog(@"%p", _logFile);
    NSAssert(_logFile, @"%@, open failed.", logFilePath);
}

- (void)asyncCacheToFile:(NSString *)log
{
    WeakSelf(weakSelf);
    dispatch_async(_logQueue, ^{
        [weakSelf cacheToFile:log];
    });
}

- (void)cacheToFile:(NSString *)log
{
    if ([NSThread currentThread].isMainThread) {
        NSAssert(NO, @"%s could not invoke main thread.", __FUNCTION__);
    }
    if (!_cache) {
        _cache = [NSMutableData data];
    }
    [_cache appendData:[log dataUsingEncoding:NSUTF8StringEncoding]];
    if (_cache.length >= MaxCacheSize) {
        fwrite([_cache bytes], sizeof(char), _cache.length, _logFile);
        fflush(_logFile);
        long int fileSize = ftell(_logFile);
        if (fileSize >= MaxLogFileSize) {
            fclose(_logFile);
            [self openFile:YES];
        }
    }
}

- (void)asyncCloseFile
{
    WeakSelf(weakSelf)
    dispatch_async(_logQueue, ^{
        [weakSelf closeFile];
    });
}

- (void)closeFile
{
    if (_cache.length) {
        fwrite([_cache bytes], sizeof(char), _cache.length, _logFile);
    }
    fclose(_logFile);
    _logFile = NULL;
    _logPath = nil;
    _cache = nil;
}

- (NSString *)level:(AppLogLevelType)level
{
    switch (level) {
        case AppLogLevel_Debug:
            return @"Debug";
        case AppLogLevel_Info:
            return @"Info";
        case AppLogLevel_Warning:
            return @"Warning";
        case AppLogLevel_Error:
            return @"Error";
            
        default:
            NSAssert(NO, @"Please pass right level.");
            break;
    }
    
    return nil;
}

- (void)initWith:(NSString *)logPath
{
    if (_logPath) {
        NSAssert(NO, @"Init twice %@.", logPath);
    }
    if (!_logQueue) {
        NSString* queueName = [NSString stringWithFormat:@"com.AppLog.%@", [[NSFileManager defaultManager] displayNameAtPath:logPath]];
        _logQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    }
    _logPath = logPath;
    [self asyncOpenFile:NO];
}

@end
