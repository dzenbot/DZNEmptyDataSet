//
//  TableViewController.m
//  Colors
//
//  Created by Ignacio Romero Z. on 6/29/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "TableViewController.h"
#import "UIColor+Random.h"

@interface TableViewController ()
@end

@implementation TableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    [super loadView];

    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.125 alpha:1.0];
    }
    
    NSString *string = [_colors[indexPath.row] hexFromColor];
    cell.textLabel.text = string;
    cell.imageView.image = [self colorPreviewAtRow:indexPath.row];
    
    return cell;
}

- (UIImage *)colorPreviewAtRow:(NSInteger)row
{
    // Constants
    CGRect bounds = CGRectMake(0, 0, 32, 32);
    
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    
    // Create the bezier path & drawing
    UIColor *color = self.colors[row];
    
    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:bounds];
    [color setFill];
    [ovalPath fill];
    
    //Create the image using the current context.
    UIImage *_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _image;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
            NSString *string = [_colors[indexPath.row] hexFromColor];
            if (string.length > 0) [[UIPasteboard generalPasteboard] setString:string];
        }
    });
}

@end
