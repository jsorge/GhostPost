//
//  JMSEntryListViewController.m
//  GhsotPost
//
//  Created by Jared Sorge on 3/27/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSEntryListViewController.h"
#import "JMSEntryStore.h"
#import "JMSManagedObjectContext.h"
#import "JMSGhostEntry.h"

static NSString *const savedPostCellKey = @"savedPostCell";

@interface JMSEntryListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (strong, nonatomic)JMSManagedObjectContext *context;
@property (strong, nonatomic)NSFetchedResultsController *fetchedResultsController;
@end

@implementation JMSEntryListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
}

#pragma mark - Properties
- (JMSManagedObjectContext *)context
{
    if (!_context) {
        _context = [JMSManagedObjectContext createContextWithStoreURL:[JMSEntryStore storeURL] options:nil];
    }
    return _context;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSFetchRequest *allEntriesFetch = [JMSGhostEntry fetchRequest];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:allEntriesFetch
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    }
    return _fetchedResultsController;
}

#pragma mark - IBActions

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:savedPostCellKey];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:savedPostCellKey];
    }
    
    JMSGhostEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entry.postTitle;
    cell.detailTextLabel.text = @"";
    
    return cell;
}

#pragma mark - UITableViewDelegate


@end
