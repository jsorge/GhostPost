//
//  JMSEntryStore.h
//  GhostPost
//
//  Created by Jared Sorge on 3/27/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSEntryStore : NSObject

#pragma mark - API
+ (NSURL *)storeURL;
+ (NSString *)ubiquityStoreName;

@end
