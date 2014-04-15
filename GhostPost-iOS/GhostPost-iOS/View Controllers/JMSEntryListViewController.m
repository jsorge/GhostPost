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
@import CoreData;

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
    
    self.title = @"Saved Drafts";
    [self registerForContextUpdates];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self updateFetchedResultsController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:EditDraftSegueKey]) {
        JMSEditDraftViewController *destination = (JMSEditDraftViewController *)segue.destinationViewController;
        self.delegate = destination;
        NSAssert([sender isKindOfClass:[JMSGhostEntry class]], @"Activating the %@ segue requires a new entry as the sender", EditDraftSegueKey);
        [self.delegate entrySelected:sender];
    } else if ([segue.identifier isEqualToString:ShowSettingsSegueKey]) {
        UINavigationController *destNav = segue.destinationViewController;
        JMSSettingsTableViewController *destination = (JMSSettingsTableViewController *)destNav.topViewController;
        destination.delegate = self;
    }
}

- (void)dealloc
{
    [self deRegisterForContextUpdates];
}

#pragma mark - Properties
- (JMSManagedObjectContext *)context
{
    //TODO: Make iCloud sync optional and check for it. If it's disabled don't pass the ubiquityStoreName
    if (!_context) {
        _context = [JMSManagedObjectContext createContextWithStoreURL:[JMSEntryStore storeURL] ubiquityStoreName:[JMSEntryStore ubiquityStoreName]];
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
    [self beginEditingEntry:nil];
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
    [self beginEditingEntry:selectedEntry];
}

#pragma mark - JMSGhostPostSettingsDelegate
- (void)ghostPostSettingsTableViewControllerDismissed:(JMSSettingsTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
//    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
//            break;
        default:
            break;
    }
}

#pragma mark - iCloud
- (void)registerForContextUpdates
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFetchedResultsController)
                                                 name:ContextNeedsUIUpdateNotification
                                               object:self.context];
}

- (void)deRegisterForContextUpdates
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Helpers
- (void)updateFetchedResultsController
{
    self.fetchedResultsController = nil;
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (void)beginEditingEntry:(JMSGhostEntry *)entry
{
    if (!entry) {
        entry = [JMSGhostEntry newInstanceInManagedObjectContext:self.context];
    }
    
    [self.delegate entrySelected:entry];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [self performSegueWithIdentifier:EditDraftSegueKey sender:entry];
    }
}
@end