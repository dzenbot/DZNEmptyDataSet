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
    
    NSString *name = [self.displayName lowercaseString];
    self.iconName = [NSString stringWithFormat:@"icon_%@", name];
    
    if ([name isEqualToString:@"instagram"]) {
        self.type = ApplicationTypeInstagram;
    }
    if ([name isEqualToString:@"tumblr"]) {
        self.type = ApplicationTypeTumblr;
    }
    if ([name isEqualToString:@"vesper"]) {
        self.type = ApplicationTypeVesper;
    }
}

@end
