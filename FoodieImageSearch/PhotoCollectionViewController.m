//
//  ViewController.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "FourSquare.h"
#import "FourSquareVenue.h"
#import "FourSquarePhoto.h"
#import "PhotoCell.h"
#import "PhotoDetailViewController.h"
#import "NSMutableArray+Shuffle.h"
#import "BackgroundLayer.h"

@import SystemConfiguration;

@interface PhotoCollectionViewController () <UISearchBarDelegate, PhotoDetailViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property UIAlertView *loadingView;
@property NSMutableArray *fourSquarePhotos;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSMutableArray *images;

@property BOOL isDataSourceAvailable;
@end

@implementation PhotoCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self)
    {
        CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
    }
	// Do any additional setup after loading the view, typically from a nib.
    self.fourSquarePhotos = [@[] mutableCopy];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil]forCellWithReuseIdentifier:@"PhotoCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.fourSquarePhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    FourSquarePhoto *fourSquarePhoto = self.fourSquarePhotos[indexPath.row];
    cell.fourSquarePhoto = fourSquarePhoto;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FourSquarePhoto *photo = self.fourSquarePhotos[indexPath.item];
    PhotoDetailViewController *vc = [[PhotoDetailViewController alloc] initWithFourSquarePhoto:photo];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.fourSquarePhotos = [@[] mutableCopy];
    NSString *searchTerm = searchBar.text;
    [self.searchBar resignFirstResponder];
    [self showLoadingView];
    
    FourSquare *fourSquare = [[FourSquare alloc] init];
    
    [fourSquare getVenuesForTerm:searchTerm completionBlock:^(NSString *searchTerm, NSArray *venues, NSError *error) {
        if (error) {
            [self presentErrorMessage:[error localizedDescription]];
            [self.loadingView dismissWithClickedButtonIndex:-1 animated:YES];
            return;
        }
        
        if(venues && [venues count] > 0) {
            __block int venueDoneCount = 0;
            venues = [NSMutableArray fisherShuffle:venues];
            for (FourSquareVenue *venue in venues) {
                venueDoneCount++;
                DLog("%d", venueDoneCount);
                [fourSquare getPhotosForVenue:venue completionBlock:^(FourSquarePhoto *photo, NSError *error) {
                    if (photo)
                    {
                        [self.fourSquarePhotos addObject:photo];
                    }
                    [self.loadingView dismissWithClickedButtonIndex:-1 animated:YES];
                    [self.collectionView reloadData];
                } allPhotosDownloaded:^{
                    venueDoneCount--;
                    DLog("%d", venueDoneCount);
                }];
            }
        } else {
            [self presentErrorMessage:@"No restaurants found!"];
            [self.loadingView dismissWithClickedButtonIndex:-1 animated:YES];
        }
    }];
    searchBar.backgroundColor = [UIColor clearColor];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}

- (void)showLoadingView
{
    self.loadingView = [[UIAlertView alloc] initWithTitle: @"Loading..." message: nil delegate:self cancelButtonTitle: nil otherButtonTitles: nil];
    UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(125, 50, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.loadingView addSubview: progress];
    [progress startAnimating];
    [self.loadingView show];
}

#pragma mark - PhotoDetailViewControllerDelegate methods
-(void)dismissMe
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Error handling
- (void) presentErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
    [alertView show];
}
@end
