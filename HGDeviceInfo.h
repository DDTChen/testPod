//
//  DeviceInfo.h
//  hongu.347
//
//  Created by DDT on 12/9/3.
//  Copyright (c) 2012年 SUNNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGDeviceInfo : NSObject

+ (NSString*)getDeviceId;
+ (NSMutableDictionary*)getDeviceInfo;
+ (BOOL)isIOS7OrHigher;
+ (BOOL)isIOS8OrHigher;

@end
