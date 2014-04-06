//
//  JMSEditDraftViewController.h
//  GhostPost
//
//  Created by Jared Sorge on 3/28/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSEntryListViewController.h"
@class JMSGhostEntry;

@interface JMSEditDraftViewController : UIViewController <JMSEntryListDelegate>
@property (strong, nonatomic)JMSGhostEntry *entry;
@end
