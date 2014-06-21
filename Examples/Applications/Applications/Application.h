//
//  Application.h
//  Applications
//
//  Created by Ignacio on 6/6/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ApplicationType) {
    ApplicationTypeAirbnb,
    ApplicationTypeAppstore,
    ApplicationTypeCamera,
    ApplicationTypeDropbox,
    ApplicationTypeFacebook,
    ApplicationTypeFancy,
    ApplicationTypeFoursquare,
    ApplicationTypeiCloud,
    ApplicationTypeInstagram,
    ApplicationTypePath,
    ApplicationTypePinterest,
    ApplicationTypePhotos,
    ApplicationTypeSafari,
    ApplicationTypeSkype,
    ApplicationTypeSlack,
    ApplicationTypeTumblr,
    ApplicationTypeTwitter,
    ApplicationTypeVideos,
    ApplicationTypeVesper,
    ApplicationTypeVine,
    ApplicationTypeWhatsapp
};

@interface Application : NSObject
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *developerName;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic) ApplicationType type;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
