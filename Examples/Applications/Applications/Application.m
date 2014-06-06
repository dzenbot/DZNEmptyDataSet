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
        self.identifier = [dict objectForKey:@"identifier"];
        self.iconName = [dict objectForKey:@"icon_name"];
        
        if ([self.identifier isEqualToString:@"389801252"]) {
            self.type = ApplicationTypeInstagram;
        }
    }
    return self;
}

@end
