//
//  DZNEmptyDataSetTests.m
//  DZNEmptyDataSetTests
//
//  Created by Ignacio Romero on 2/28/17.
//  Copyright © 2017 DZN. All rights reserved.
//

@import UIKit;
@import DZNEmptyDataSet;
@import FBSnapshotTestCase;

#import "Application.h"
#import "DetailViewController.h"

@interface ApplicationsSnapshotTests : FBSnapshotTestCase
@end

@implementation ApplicationsSnapshotTests

- (void)setUp {
    [super setUp];
    
    self.recordMode = NO;
    
    // Snaphot tests are not yet configured to be running for multiple hardware configuration (device type, system version, screen density, etc.).
    // We make sure tests are only ran for @2x iPhone simulators, with iOS 10 or above.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIDevice *device = [UIDevice currentDevice];
        XCTAssert([device.name containsString:@"iPhone 8"], @"Please run snapshot tests on an iPhone 8 simulator with iOS 13.3");
        XCTAssert([device.systemVersion doubleValue] == 13.3, @"Please run snapshot tests on an iPhone 8 simulator with iOS 13.3");
    });
}

- (void)tearDown {
    [super tearDown];
}

- (void)testApplicationEmptyDataSets
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"applications" ofType:@"json"];
    NSArray *applications = [Application applicationsFromJSONAtPath:path];
    
    for (Application *app in applications) {

        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.rootViewController = [[DetailViewController alloc] initWithApplication:app];
        [window makeKeyAndVisible];

        [self verifyView:window withIdentifier:app.displayName];
    }
}

#pragma mark - FBSnapshotTestCase

- (NSString *)getReferenceImageDirectoryWithDefault:(NSString *)dir
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [[bundle infoDictionary] valueForKey:@"XCodeProjectPath"];
    return [NSString stringWithFormat:@"%@/DZNEmptyDataSetTests/ReferenceImages", path];
}

- (void)verifyView:(UIView *)view withIdentifier:(NSString *)identifier
{
    FBSnapshotVerifyViewWithOptions(view, identifier, FBSnapshotTestCaseDefaultSuffixes(), 1);
}

@end
