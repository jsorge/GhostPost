//
//  JMSManagedObjectContext.h
//  GhostPost-iOS
//
//  Created by Jared Sorge on 3/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString *const ContextNeedsUIUpdateNotification;

@interface JMSManagedObjectContext : NSManagedObjectContext

#pragma mark - API
+ (instancetype)createContextWithStoreURL:(NSURL *)storeURL ubiquityStoreName:(NSString *)ubiquityStoreName;
+ (BOOL)storeNeedsMigrationAtURL:(NSURL *)storeURL;
- (instancetype)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end
