//
//  JMSEntryStore.m
//  GhsotPost
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
    NSString *documentDirectory = [(NSURL *)[locations firstObject] path];
    
    NSString *storeLocation = [documentDirectory stringByAppendingPathComponent:@"GhostPosts"];
    storeLocation = [storeLocation stringByAppendingPathExtension:@"sqlite"];
    
    return [NSURL URLWithString:storeLocation];
}

@end
