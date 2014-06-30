//
//  CollectionViewController.m
//  Colors
//
//  Created by Ignacio Romero Z. on 6/19/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "CollectionViewController.h"
#import "ColorViewCell.h"
#import "UIColor+Random.h"

#define kColumnCountMax 7
#define kColumnCountMin 5

static NSString *CellIdentifier = @"ColorViewCell";

@interface CollectionViewController ()
@property (nonatomic) NSInteger columnCount;
@end

@implementation CollectionViewController

- (instancetype)init
{
    self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    if (self) {
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat inset = layout.minimumLineSpacing*1.5;
    
    self.collectionView.backgroundView = [UIView new];
    self.collectionView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.collectionView registerClass:[ColorViewCell class] forCellWithReuseIdentifier:CellIdentifier];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.columnCount = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? kColumnCountMax : kColumnCountMin;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

- (CGSize)cellSize
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat size = (self.navigationController.view.bounds.size.width/self.columnCount) - flowLayout.minimumLineSpacing;
    return CGSizeMake(size, size);
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"self.colors : %@", self.colors);
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    cell.backgroundColor = _colors[indexPath.row];
    
    if (cell.selected) {
        cell.textLabel.text = [cell.backgroundColor hexFromColor];
    }
    else {
        cell.textLabel.text = nil;
    }
    
    return cell;
}


#pragma mark - UICollectionViewDataDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorViewCell *cell = (ColorViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textLabel.text = [_colors[indexPath.row] hexFromColor];
    cell.selected = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorViewCell *cell = (ColorViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textLabel.text = nil;
    cell.selected = NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSize];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
            NSString *string = [_colors[indexPath.row] hexFromColor];
            if (string.length > 0) [[UIPasteboard generalPasteboard] setString:string];
        }
    });
}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - View Auto-Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.columnCount = UIDeviceOrientationIsLandscape(toInterfaceOrientation) ? kColumnCountMax : kColumnCountMin;
    
    [self.collectionView reloadData];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
