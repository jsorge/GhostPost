//
//  JMSSettingsTableViewController.m
//  GhostPost
//
//  Created by Jared Sorge on 3/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSSettingsTableViewController.h"
#import "JMSSettingsController.h"

@interface JMSSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serverURLTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernmaeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation JMSSettingsTableViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

#pragma mark - IBActions
- (IBAction)testConnectionButtonTapped:(id)sender
{
    
}

- (IBAction)doneButtonTapped:(id)sender
{
    [JMSSettingsController updateServerURL:self.serverURLTextField.text];
    //TODO: Save username & password
    
    [self.delegate ghostPostSettingsTableViewControllerDismissed:self];
}
@end
