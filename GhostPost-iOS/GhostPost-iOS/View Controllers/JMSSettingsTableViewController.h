//
//  JMSSettingsTableViewController.h
//  GhsotPost
//
//  Created by Jared Sorge on 3/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JMSGhostPostSettingsDelegate;

@interface JMSSettingsTableViewController : UITableViewController
@property (weak, nonatomic)id<JMSGhostPostSettingsDelegate>delegate;
@end


@protocol JMSGhostPostSettingsDelegate <NSObject>
- (void)ghostPostSettingsTableViewControllerDismissed:(JMSSettingsTableViewController *)controller;
@end