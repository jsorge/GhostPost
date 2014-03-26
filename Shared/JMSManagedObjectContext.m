//
//  JMSManagedObjectContext.m
//  GhsotPost-iOS
//
//  Created by Jared Sorge on 3/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSManagedObjectContext.h"

@implementation JMSManagedObjectContext

#pragma mark - API
+ (instancetype)createContextWithStoreURL:(NSURL *)storeURL options:(NSDictionary *)options
{
    NSMutableArray *models = [NSMutableArray array];
    NSString *modelName = [self modelName];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *firstModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    [models addObject:firstModel];
    
    NSManagedObjectModel *finalModel = [NSManagedObjectModel modelByMergingModels:models];
    NSAssert(finalModel != nil, @"Could not laod MOM");
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc ]initWithManagedObjectModel:finalModel];
    NSError *error;
    NSString *storeType = NSSQLiteStoreType;
    
    if (![coordinator addPersistentStoreWithType:storeType
                                   configuration:nil
                                             URL:storeURL
                                         options:options
                                           error:&error]) {
        //TODO: Handle error better
        NSLog(@"Failed creating persistent store with error: %@", error);
        abort();
    }
    
    JMSManagedObjectContext *context = [[self alloc] initWithPersistentStoreCoordinator:coordinator];
    
    return context;
}

#pragma mark - Private
+ (NSString *)modelName
{
    return @"GhostPostCoreDataModel";
}

- (instancetype)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    self = [super init];
    if (self) {
        self.persistentStoreCoordinator = coordinator;
    }
    return self;
}

@end
