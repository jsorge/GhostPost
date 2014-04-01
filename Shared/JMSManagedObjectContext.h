//
//  JMSManagedObjectContext.h
//  GhostPost-iOS
//
//  Created by Jared Sorge on 3/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface JMSManagedObjectContext : NSManagedObjectContext

#pragma mark - API
+ (instancetype)createContextWithStoreURL:(NSURL *)storeURL options:(NSDictionary *)options;
+ (BOOL)storeNeedsMigrationAtURL:(NSURL *)storeURL;
- (instancetype)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end
