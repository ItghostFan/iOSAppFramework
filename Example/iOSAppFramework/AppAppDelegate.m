//
//  AppAppDelegate.m
//  iOSAppFramework
//
//  Created by ItghostFan on 07/02/2016.
//  Copyright (c) 2016 ItghostFan. All rights reserved.
//

#import "AppAppDelegate.h"

@implementation AppAppDelegate

+ (void)testArgs:(NSInteger)count, ... {
    va_list args;
    va_start(args, count);
    for (int index = 0; index < count; ++index) {
        int value = va_arg(args, int);
        NSLog(@"%d", value);
    }
    va_end(args);
}

+ (NSString *)formatNumber:(NSNumber *)number {
    CGFloat value = 0.0f;
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.roundingMode = kCFNumberFormatterRoundDown;
    if (number.unsignedLongLongValue > 99999999) {
        UInt64 integerPart = number.unsignedLongLongValue / 1000000;
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
        value = integerPart / 100.0f;
        return [NSString stringWithFormat:NSLocalizedString(@"%@亿", nil), [formatter stringFromNumber:@(value)]];
    }
    else if (number.unsignedLongLongValue > 999999) {
        value = number.unsignedLongLongValue / 10000;
        return [NSString stringWithFormat:NSLocalizedString(@"%@万", nil), [formatter stringFromNumber:@(value)]];
    }
    return number.stringValue;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AppAppDelegate testArgs:3, 1, 2, 3];
    // Override point for customization after application launch.
    NSLog(@"%@", [AppAppDelegate formatNumber:@(999999)]);
    NSLog(@"%@", [AppAppDelegate formatNumber:@(1499999)]);
    NSLog(@"%@", [AppAppDelegate formatNumber:@(1500000)]);
    
    NSLog(@"%@", [AppAppDelegate formatNumber:@(99994999)]);
    NSLog(@"%@", [AppAppDelegate formatNumber:@(144999999)]);
    NSLog(@"%@", [AppAppDelegate formatNumber:@(145000000)]);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
