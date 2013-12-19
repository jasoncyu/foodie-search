//
//  PhotoSwipeViewController.m
//  FoodieImageSearch
//
//  Created by Xinlei Xu on 12/4/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

//  Created by coolbeet on 7/18/13.
//  ViewController.m
//  draggableView
//  Copyright (c) 2013 suyu zhang. All rights reserved.
//  Modified by Mimee Xu (@NorthStar) on 12/02/13.


#import "PhotoSwipeViewController.h"
#import "DraggableView.h"
//Other dependencies
#import "FourSquare.h"
#import "FourSquareVenue.h"
#import "FourSquarePhoto.h"
#import "PhotoCell.h"
#import "PhotoDetailViewController.h"

//Hacky way to load somewhat evenly -- use a random number generator
#include <stdlib.h>
//I want gradient background
#import "BackgroundLayer.h"
@import SystemConfiguration;

@interface PhotoSwipeViewController () <UITextFieldDelegate, PhotoDetailViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UIView *stackView;
@property UIAlertView *loadingView;
@property NSMutableArray *fourSquarePhotos;

//IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

//@property NSMutableArray *images;
-(void) reloadStackFromIndex: (NSInteger) index;

@property BOOL isDataSourceAvailable;
@end





@implementation PhotoSwipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];

    }
    return self;
}

-(void)reloadStackFromIndex: (NSInteger) index;
{
    for(NSInteger j = index; j!=self.fourSquarePhotos.count; ++j)
    {
        if ([self.fourSquarePhotos objectAtIndex:j ])
        {
            FourSquarePhoto *photoToAdd = [self.fourSquarePhotos objectAtIndex:j];
            
            CGRect frame;
            NSInteger r = arc4random() % 4;
            //UpperLeft
            if (r==1)
            {
                frame = CGRectMake(160-100 - 5*(j-index), 410+5*(j-index), 200, 200);
                //DraggableView *tempView = [[DraggableView alloc] initWithFrame:CGRectMake(160-100 - 5*j, 120+10*j, 200, 200) image:readyImage];
            }
            //UpperRight
            if (r==2)
            {
                frame = CGRectMake(260-200 - 5*(j-index), 410+5*(j-index), 200, 200);
                //DraggableView *tempView = [[DraggableView alloc] initWithFrame:CGRectMake(160-100 - 5*j, 120+10*j, 200, 200) image:readyImage];
            }
            
            if (r==3)
            {
                frame = CGRectMake(260-200 - 5*(j-index), 120-5*(j-index), 200, 200);
                //DraggableView *tempView = [[DraggableView alloc] initWithFrame:CGRectMake(160-100 - 5*j, 120+10*j, 200, 200) image:readyImage];
            }
            
            else
            {
                frame = CGRectMake(160-100 - 5*(j-index), 120-5*(j-index), 200, 200);
                //DraggableView *tempView = [[DraggableView alloc] initWithFrame:CGRectMake(160-100 - 5*j, 120+10*j, 200, 200) image:readyImage];
            }
            
            DraggableView *tempView = [[DraggableView alloc] initWithFrame:frame andFourSquarePhoto:photoToAdd];
            
            //DraggableView *tempView = [[DraggableView alloc] initWithFrame:CGRectMake(160-100 - 5*i, 120+10*i, 200, 200) image:[UIImage  imageNamed:currentString]];
            
            
            //Stylin'
            CALayer *imageLayer = tempView.imageView.layer;
            [imageLayer setBorderColor: [[UIColor whiteColor] CGColor]];
            [imageLayer setBorderWidth: 2.0];
            //[imageLayer setCornerRadius:2.0];
            [imageLayer setShadowColor: [[UIColor blackColor] CGColor]];
            [imageLayer setShadowOffset: CGSizeMake(10, 10)];
            
            [self.tempArray addObject:tempView];
        }
        ++j;
        
    }
    //reverse the tempArray
    self.tempArray =[NSMutableArray arrayWithArray: [[self.tempArray reverseObjectEnumerator] allObjects]];
    //add to stackView "backwards"
    //but below the last layer added
    for (DraggableView* imageView in self.tempArray)
    {
        if (!self.tempLastView){
            [self.stackView addSubview: imageView];
        }
        else [self.stackView insertSubview:imageView belowSubview:self.tempLastView];
    }
    self.tempLastView = self.tempArray.firstObject;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchField) {
        self.fourSquarePhotos = [@[] mutableCopy];
        NSString *searchTerm = textField.text;
        [self.searchField resignFirstResponder];
        [self showLoadingView];
        
        FourSquare *fs = [[FourSquare alloc] init];
        [fs getPhotosForTerm:searchTerm completion:^(FourSquarePhoto *photo, NSError *error) {
            if (photo)
            {
                [self.fourSquarePhotos addObject:photo];
            }
            [self.loadingView dismissWithClickedButtonIndex:-1 animated:YES];

            if ((self.fourSquarePhotos.count)>0 &&(self.fourSquarePhotos.count)%8 == 0)
            {
                [self reloadStackFromIndex:((self.fourSquarePhotos.count-8))];
            }
        }];
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

- (void)dismiss
{
    //    DLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Protocol requirement
-(void)dismissMe
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end



