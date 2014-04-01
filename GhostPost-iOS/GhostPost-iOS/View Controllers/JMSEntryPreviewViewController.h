//
//  JMSEntryPreviewViewController.h
//  GhsotPost
//
//  Created by Jared Sorge on 3/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSGhostEntry;
@protocol JMSEntryPreviewDelegate;

@interface JMSEntryPreviewViewController : UIViewController
@property (strong, nonatomic)JMSGhostEntry *entry;
@property (weak, nonatomic)id<JMSEntryPreviewDelegate>delegate;
@end

@protocol JMSEntryPreviewDelegate <NSObject>

- (void)entryPreviewViewControllerDismissed:(JMSEntryPreviewViewController *)controller;

@end