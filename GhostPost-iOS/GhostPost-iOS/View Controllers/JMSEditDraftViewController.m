//
//  JMSEditDraftViewController.m
//  GhostPost
//
//  Created by Jared Sorge on 3/28/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSEditDraftViewController.h"
#import "JMSGhostEntry.h"
#import "JMSEntryPreviewViewController.h"

@interface JMSEditDraftViewController () <UIActionSheetDelegate, JMSEntryPreviewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic)UIToolbar *accessoryToolbar;
@end

static NSString *const PreviewSegue = @"seg_PreviewEntry";

/*
 TODO: Send entry to server
 TODO: Post title
 TODO: Post tags
 TODO: Handle images
 */

@implementation JMSEditDraftViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.text = self.entry.markdownText;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PreviewSegue]) {
        UINavigationController *navigation = segue.destinationViewController;
        JMSEntryPreviewViewController *destination = (JMSEntryPreviewViewController *)navigation.topViewController;
        destination.entry = self.entry;
        destination.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.entry.managedObjectContext save:nil];
}

#pragma mark - Properties
- (UIToolbar *)accessoryToolbar
{
    //TODO: Implement keyboard accessory view
    if (!_accessoryToolbar) {
        _accessoryToolbar = [[UIToolbar alloc] init];
    }
    return _accessoryToolbar;
}

#pragma mark - IBActions
- (IBAction)actionButtonTapped:(id)sender
{
    UIActionSheet *entryActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Show Preview", @"Send to Server", nil];
    [entryActionSheet showFromBarButtonItem:self.actionButton animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:PreviewSegue sender:nil];
            break;
        case 1:
            //TODO: send to server
            break;
        default:
            NSLog(@"Invalid action sheet button tapped");
            break;
    }
}

#pragma mark - JMSEntryPreviewDelegate
- (void)entryPreviewViewControllerDismissed:(JMSEntryPreviewViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
