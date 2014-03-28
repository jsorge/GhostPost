//
//  JMSSettingsController.m
//  GhsotPost
//
//  Created by Jared Sorge on 3/27/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSSettingsController.h"

NSString *const serverURLKey = @"serverURL";

@implementation JMSSettingsController
#pragma mark - API
+ (void)retrieveSynchronizedValues;
{
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

+ (NSString *)serverURL
{
    return [[NSUbiquitousKeyValueStore defaultStore] valueForKey:serverURLKey];
}

+ (void)updateServerURL:(NSString *)url
{
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    [store setObject:url forKey:serverURLKey];
    [store synchronize];
}
@end