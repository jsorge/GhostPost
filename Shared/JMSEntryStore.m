//
//  JMSEntryStore.m
//  GhostPost
//
//  Created by Jared Sorge on 3/27/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSEntryStore.h"

@implementation JMSEntryStore

#pragma mark - API
+ (NSURL *)storeURL
{
    NSArray *locations = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentDirectory = (NSURL *)[locations firstObject];
    
    NSURL *storeLocation = [documentDirectory URLByAppendingPathComponent:@"GhostPosts"];
    storeLocation = [storeLocation URLByAppendingPathExtension:@"sqlite"];
    
    return storeLocation;
}

@end
