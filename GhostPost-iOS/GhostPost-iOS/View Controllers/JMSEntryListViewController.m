//
//  JMSEntryListViewController.m
//  GhostPost
//
//  Created by Jared Sorge on 3/27/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSEntryListViewController.h"
#import "JMSEntryStore.h"
#import "JMSManagedObjectContext.h"
#import "JMSGhostEntry.h"
#import "JMSEditDraftViewController.h"
#import "JMSSettingsTableViewController.h"

static NSString *const SavedPostCellKey = @"ruid_SavedPostCell";
static NSString *const EditDraftSegueKey = @"seg_EditDraft";
static NSString *const ShowSettingsSegueKey = @"seg_ShowSettings";

@interface JMSEntryListViewController () <UITableViewDataSource, UITableViewDelegate, JMSGhostPostSettingsDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic)IBOutlet UITableView *tableView;

@property (strong, nonatomic)JMSManagedObjectContext *context;
@property (strong, nonatomic)NSFetchedResultsController *fetchedResultsController;
@end

@implementation JMSEntryListViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:EditDraftSegueKey]) {
        JMSEditDraftViewController *destination = (JMSEditDraftViewController *)segue.destinationViewController;
        NSAssert([sender isKindOfClass:[JMSGhostEntry class]], @"Activating the %@ segue requires a new entry as the sender", EditDraftSegueKey);
        destination.entry = sender;
    } else if ([segue.identifier isEqualToString:ShowSettingsSegueKey]) {
        JMSSettingsTableViewController *destination = (JMSSettingsTableViewController *)segue.destinationViewController;
        destination.delegate = self;
    }
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
        allEntriesFetch.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:MarkdownTextKey ascending:YES]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:allEntriesFetch
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

#pragma mark - IBActions
- (IBAction)settingsButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:ShowSettingsSegueKey sender:nil];
}

- (IBAction)addButtonTapped:(id)sender
{
    JMSGhostEntry *newEntry = [JMSGhostEntry newInstanceInManagedObjectContext:self.context];
    [self performSegueWithIdentifier:EditDraftSegueKey sender:newEntry];
}

- (IBAction)actionButtonTapped:(id)sender
{
    //TODO: Implement posting from the home screen
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SavedPostCellKey];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SavedPostCellKey];
    }
    
    JMSGhostEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entry.markdownText;
    cell.detailTextLabel.text = @"";
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSGhostEntry *selectedEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:EditDraftSegueKey sender:selectedEntry];
}

#pragma mark - JMSGhostPostSettingsDelegate
- (void)ghostPostSettingsTableViewControllerDismissed:(JMSSettingsTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
    NSLog(@"changing content");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    NSLog(@"content changed");
}
@end