//
//  JMSGhostEntry.h
//  GhostPost-iOS
//
//  Created by Jared Sorge on 3/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMSManagedObject.h"

extern NSString *const MarkdownTextKey;
extern NSString *const PostTitleKey;
extern NSString *const PostTagsKey;

@interface JMSGhostEntry : JMSManagedObject

@property (nonatomic, retain) NSString * markdownText;
@property (nonatomic, retain) NSString * postTitle;
@property (nonatomic, retain) NSString * postTags;

@end
