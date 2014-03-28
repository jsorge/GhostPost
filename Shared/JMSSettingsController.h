//
//  JMSSettingsController.h
//  GhsotPost
//
//  Created by Jared Sorge on 3/27/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSSettingsController : NSObject

#pragma mark - API
+ (void)retrieveSynchronizedValues;
+ (NSString *)serverURL;
+ (void)updateServerURL:(NSString *)url;

@end
