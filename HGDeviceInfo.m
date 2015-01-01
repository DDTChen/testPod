//
//  DeviceInfo.m
//  hongu.347
//
//  Created by DDT on 12/9/3.
//  Copyright (c) 2012年 SUNNET. All rights reserved.
//


/**
 * DeviceInfo 實作提供設備資訊的類別
 *
 * @author DDT
 * @copyright Copyright 2012 SUNNET LIMITED
 */
#import "HGDeviceInfo.h"

@implementation HGDeviceInfo

/**
 * 取得設備ID
 *
 * @return NSString id
 */
+ (NSString*)getDeviceId
{
    NSString *deviceUuid;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id uuid = [defaults objectForKey:@"deviceUuid"];
    //如果已產生過則不再產生
    if (uuid) {
        deviceUuid = (NSString *)uuid;
    } else {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef cfUuid = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        deviceUuid = [NSString stringWithFormat:@"%@", cfUuid];
        CFRelease(cfUuid);

        [defaults setObject:deviceUuid forKey:@"deviceUuid"];
    }

    return deviceUuid;
}

/**
 * 取得設備與APP相關資訊
 *
 * @return NSString id
 */
+ (NSMutableDictionary*)getDeviceInfo
{
    // Get Bundle Info for Remote Registration (handy if you have more than one app)
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];


    NSUInteger rntypes;
    if ([self isIOS8OrHigher]) {
        rntypes = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    } else {
        rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }


    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"ON" : @"OFF";
    NSString *pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? @"ON" : @"OFF";
    NSString *pushSound = (rntypes & UIRemoteNotificationTypeSound) ? @"ON" : @"OFF";

    //用UIDevice取得資訊
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = [self getDeviceId];
    NSString *deviceName = [dev.name stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *deviceModel = [dev.model stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *deviceSystemVersion = dev.systemVersion;

    NSString *environment;
    #ifdef DEBUG
        environment = @"SANDBOX";
    #else
        environment = @"PRODUCTION";
    #endif

    //回傳Dictionary
    NSMutableDictionary* info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
        @"",@"app_uuid",
        appName, @"appname",
        appVersion, @"appversion",
        @"IOS", @"deviceos",
        deviceUuid, @"deviceuid",
        @"", @"devicetoken",
        deviceName, @"devicename",
        deviceModel, @"devicemodel",
        deviceSystemVersion, @"deviceversion",
        pushBadge, @"pushbadge",
        pushAlert, @"pushalert",
        pushSound, @"pushsound",
        environment, @"environment",
        nil];

    return info;
}

+ (BOOL)isIOS7OrHigher
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIOS8OrHigher
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        return YES;
    } else {
        return NO;
    }
}
@end
