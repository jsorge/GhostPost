//
//  JMSManagedObjectContext.m
//  GhostPost-iOS
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
    NSManagedObjectModel *firstModel = [self loadManagedObjectModel];
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

+ (BOOL)storeNeedsMigrationAtURL:(NSURL *)storeURL;
{
    BOOL compatible = NO;
    NSError *error;
    
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil
                                                                                              URL:storeURL
                                                                                            error:&error];
    if (error) {
        //TODO: Handle error
        abort();
    } else if (sourceMetadata != nil) {
        NSManagedObjectModel *destinationModel = [self loadManagedObjectModel];
        compatible = [destinationModel isConfiguration:nil
                           compatibleWithStoreMetadata:sourceMetadata];
    }
    
    return !compatible;
}

- (instancetype)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    self = [super init];
    if (self) {
        self.persistentStoreCoordinator = coordinator;
    }
    return self;
}

#pragma mark - Private
+ (NSString *)modelName
{
    return @"GhostPostCoreDataModel";
}

+ (NSManagedObjectModel *)loadManagedObjectModel
{
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:[self modelName] withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:bundleURL];
}

@end
