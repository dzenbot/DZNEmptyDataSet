//
//  Application.m
//  Applications
//
//  Created by Ignacio on 6/6/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "Application.h"

@implementation Application

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.displayName = [dict objectForKey:@"display_name"];
        self.developerName = [dict objectForKey:@"developer_name"];
        self.identifier = [dict objectForKey:@"identifier"];
    }
    return self;
}

- (void)setDisplayName:(NSString *)displayName
{
    _displayName = displayName;
    
    self.iconName = [[[NSString stringWithFormat:@"icon_%@", self.displayName] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    self.type = applicationTypeFromString(self.displayName) + 1;
}

ApplicationType applicationTypeFromString(NSString *string)
{
    NSArray *arr = @[
                     @"500px",
                     @"Airbnb",
                     @"AppStore",
                     @"Camera",
                     @"Dropbox",
                     @"Facebook",
                     @"Fancy",
                     @"Foursquare",
                     @"iCloud",
                     @"Instagram",
                     @"iTunes Connect",
                     @"Kickstarter",
                     @"Path",
                     @"Pinterest",
                     @"Photos",
                     @"Podcasts",
                     @"Remote",
                     @"Safari",
                     @"Skype",
                     @"Slack",
                     @"Tumblr",
                     @"Twitter",
                     @"Videos",
                     @"Vesper",
                     @"Vine",
                     @"WhatsApp",
                     @"WWDC"
                     ];
    return (ApplicationType)[arr indexOfObject:string];
}

@end
