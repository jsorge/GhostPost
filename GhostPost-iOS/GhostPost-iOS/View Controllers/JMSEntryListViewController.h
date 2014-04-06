//
//  JMSEntryListViewController.h
//  GhostPost
//
//  Created by Jared Sorge on 3/27/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSGhostEntry;

@protocol JMSEntryListDelegate;

@interface JMSEntryListViewController : UIViewController
@property (weak, nonatomic)id<JMSEntryListDelegate>delegate;
@end

@protocol JMSEntryListDelegate <NSObject>
- (void)entrySelected:(JMSGhostEntry *)entry;
@end