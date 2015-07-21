//
//  DZNPolyActivity.m
//  DZNWebViewController
//  https://github.com/dzenbot/DZNWebViewController
//
//  Created by Ignacio Romero Zurbuchen on 3/28/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "DZNPolyActivity.h"

@implementation DZNPolyActivity
{
    DZNPolyActivityType _type;
	NSURL *_URL;
}

+ (instancetype)activityWithType:(DZNPolyActivityType)type
{
    return [[DZNPolyActivity alloc] initWithActivityType:type];
}

- (instancetype)initWithActivityType:(DZNPolyActivityType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}


#pragma mark - Getter methods

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (NSString *)activityType
{
    switch (_type) {
        case DZNPolyActivityTypeLink:           return @"com.dzn.DZNWebViewController.activity.CopyLink";
        case DZNPolyActivityTypeSafari:         return @"com.dzn.DZNWebViewController.activity.OpenInSafari";
        case DZNPolyActivityTypeChrome:         return @"com.dzn.DZNWebViewController.activity.OpenInChrome";
        case DZNPolyActivityTypeOpera:          return @"com.dzn.DZNWebViewController.activity.OpenInOperaMini";
        case DZNPolyActivityTypeDolphin:        return @"com.dzn.DZNWebViewController.activity.OpenInDolphin";
    }
}

- (NSString *)activityTitle
{
    switch (_type) {
        case DZNPolyActivityTypeLink:           return NSLocalizedString(@"Copy Link", nil);
        case DZNPolyActivityTypeSafari:         return NSLocalizedString(@"Open in Safari", nil);
        case DZNPolyActivityTypeChrome:         return NSLocalizedString(@"Open in Chrome", nil);
        case DZNPolyActivityTypeOpera:          return NSLocalizedString(@"Open in Opera", nil);
        case DZNPolyActivityTypeDolphin:        return NSLocalizedString(@"Open in Dolphin", nil);
    }
}

- (UIImage *)activityImage
{
    switch (_type) {
        case DZNPolyActivityTypeLink:           return [UIImage imageNamed:@"Link7"];
        case DZNPolyActivityTypeSafari:         return [UIImage imageNamed:@"Safari7"];
        case DZNPolyActivityTypeChrome:         return [UIImage imageNamed:@"Chrome7"];
        case DZNPolyActivityTypeOpera:          return [UIImage imageNamed:@"Opera7"];
        case DZNPolyActivityTypeDolphin:        return [UIImage imageNamed:@"Dolphin7"];
        default:                                return nil;
    }
}

- (NSURL *)chromeURLWithURL:(NSURL *)URL
{
    return [self customURLWithURL:URL andType:DZNPolyActivityTypeChrome];
}

- (NSURL *)operaURLWithURL:(NSURL *)URL
{
    return [self customURLWithURL:URL andType:DZNPolyActivityTypeOpera];
}

- (NSURL *)dolphinURLWithURL:(NSURL *)URL
{
    return [self customURLWithURL:URL andType:DZNPolyActivityTypeDolphin];
}

- (NSURL *)customURLWithURL:(NSURL *)URL andType:(DZNPolyActivityType)type
{
    // Replaces the URL Scheme with the type equivalent.
    NSString *scheme = nil;
    if ([URL.scheme isEqualToString:@"http"]) {
        if (type == DZNPolyActivityTypeChrome) scheme = @"googlechrome";
        if (type == DZNPolyActivityTypeOpera) scheme = @"ohttp";
        if (type == DZNPolyActivityTypeDolphin) scheme = @"dolphin";
    }
    else if ([URL.scheme isEqualToString:@"https"]) {
        if (type == DZNPolyActivityTypeChrome) scheme = @"googlechromes";
        if (type == DZNPolyActivityTypeOpera) scheme = @"ohttps";
        if (type == DZNPolyActivityTypeDolphin) scheme = @"dolphin";
    }
    
    // Proceeds only if a valid URI Scheme is available.
    if (scheme) {
        NSRange range = [[URL absoluteString] rangeOfString:@":"];
        NSString *urlNoScheme = [[URL absoluteString] substringFromIndex:range.location];
        return [NSURL URLWithString:[scheme stringByAppendingString:urlNoScheme]];
    }
    
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	for (UIActivity *item in activityItems) {
        
		if ([item isKindOfClass:[NSString class]]) {
            
			NSURL *URL = [NSURL URLWithString:(NSString *)item];
            if (!URL) continue;
            
            if (_type == DZNPolyActivityTypeLink) {
                return URL ? YES : NO;
            }
            if (_type == DZNPolyActivityTypeSafari) {
                return [[UIApplication sharedApplication] canOpenURL:URL];
            }
            if (_type == DZNPolyActivityTypeChrome) {
                return [[UIApplication sharedApplication] canOpenURL:[self chromeURLWithURL:URL]];
            }
            if (_type == DZNPolyActivityTypeOpera) {
                return [[UIApplication sharedApplication] canOpenURL:[self operaURLWithURL:URL]];
            }
            if (_type == DZNPolyActivityTypeDolphin) {
                return [[UIApplication sharedApplication] canOpenURL:[self dolphinURLWithURL:URL]];
            }
            
            break;
		}
	}

	return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
	for (id item in activityItems) {
        
		if ([item isKindOfClass:[NSString class]]) {
			_URL = [NSURL URLWithString:(NSString *)item];
            if (!_URL) continue;
            else break;
		}
	}
}

- (void)performActivity
{
    BOOL completed = NO;
    
    if (!_URL) {
        [self activityDidFinish:completed];
        return;
    }
    
    switch (_type) {
        case DZNPolyActivityTypeLink:
            [[UIPasteboard generalPasteboard] setURL:_URL];
            completed = YES;
            break;
        case DZNPolyActivityTypeSafari:
            completed = [[UIApplication sharedApplication] openURL:_URL];
            break;
        case DZNPolyActivityTypeChrome:
            completed = [[UIApplication sharedApplication] openURL:[self chromeURLWithURL:_URL]];
            break;
        case DZNPolyActivityTypeOpera:
            completed = [[UIApplication sharedApplication] openURL:[self operaURLWithURL:_URL]];
            break;
        case DZNPolyActivityTypeDolphin:
            completed = [[UIApplication sharedApplication] openURL:[self dolphinURLWithURL:_URL]];
            break;
    }
    
	[self activityDidFinish:completed];
}

@end
