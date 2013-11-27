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
@import SystemConfiguration;

@interface PhotoCollectionViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property UIAlertView *loadingView;
@property NSMutableArray *fourSquarePhotos;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@property NSMutableArray *images;

@property BOOL isDataSourceAvailable;
@end

@implementation PhotoCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    //TODO: photos don't display property, wrong fit
    PhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    FourSquarePhoto *fourSquarePhoto = self.fourSquarePhotos[indexPath.row];
    cell.fourSquarePhoto = fourSquarePhoto;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchField) {
        NSString *searchTerm = textField.text;
        [self.searchField resignFirstResponder];
        [self showLoadingView];
        
        FourSquare *fourSquare = [[FourSquare alloc] init];

        __block FourSquareVenue *venue = [[FourSquareVenue alloc] init];
        [fourSquare getVenuesForTerm:searchTerm completionBlock:^(NSString *searchTerm, NSArray *venues, NSError *error) {
            if(venues && [venues count] > 0) {
                venue = venues[0];
            } else {
                NSLog(@"Error searching venues: %@", error);
            }

            [fourSquare getPhotosForVenue:venue completionBlock:^(NSMutableArray *photos, NSError *error) {
                if (photos && [photos count] > 0) {
                    self.fourSquarePhotos = photos;
                } else {
                    DLog(@"No photos found");
                }
                
                [self.loadingView dismissWithClickedButtonIndex:-1 animated:YES];
                [self.collectionView reloadData];
                DLog();
            }];
            
            DLog();
        }];
        
        DLog();
    }
    
    return YES;
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

#pragma mark - Network
- (BOOL)isDataSourceAvailable
{
    static BOOL checkNetwork = YES;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
        checkNetwork = NO;
        
        Boolean success;
        const char *host_name = "twitter.com"; // your data source host name
        
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return _isDataSourceAvailable;
}
@end
