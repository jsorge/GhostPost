//
//  JMSEditDraftViewController.m
//  GhsotPost
//
//  Created by Jared Sorge on 3/28/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSEditDraftViewController.h"
#import "JMSGhostEntry.h"

@interface JMSEditDraftViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@end

@implementation JMSEditDraftViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.text = self.entry.markdownText;
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
            
            break;
        case 1:
            break;
        default:
            NSLog(@"Invalid action sheet button tapped");
            break;
    }
}
@end
