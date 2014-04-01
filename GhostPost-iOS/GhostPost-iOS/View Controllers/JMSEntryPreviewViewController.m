//
//  JMSEntryPreviewViewController.m
//  GhostPost
//
//  Created by Jared Sorge on 3/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSEntryPreviewViewController.h"
#import "JMSGhostEntry.h"
#import "JKSMarkdownDocument.h"

@interface JMSEntryPreviewViewController ()
@property (weak, nonatomic)IBOutlet UIWebView *htmlPreview;
@end

@implementation JMSEntryPreviewViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JKSMarkdownDocument *renderer = [[JKSMarkdownDocument alloc] initWithString:self.entry.markdownText];
    [self.htmlPreview loadHTMLString:[renderer HTML] baseURL:nil];
}

#pragma mark - IBActions
- (IBAction)doneButtonTapped:(id)sender
{
    [self.delegate entryPreviewViewControllerDismissed:self];
}
@end
