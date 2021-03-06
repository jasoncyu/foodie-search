//
//  photoDetailViewController.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/26/13.
//  Copyright (c) 2013 Jason Mimee. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "RestaurantDetailsViewController.h"
#import "BackgroundLayer.h"

@interface PhotoDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *restaurantDetailsButton;
- (IBAction)viewRestaurantDetails:(id)sender;
- (IBAction)goBackToSearchView:(id)sender;

@property FourSquarePhoto *fourSquarePhoto;
@end

@implementation PhotoDetailViewController

- (id)initWithFourSquarePhoto:(FourSquarePhoto *)fourSquarePhoto;
{
    self = [super initWithNibName:@"PhotoDetailViewController" bundle:nil];
    if (self) {
        self.fourSquarePhoto = fourSquarePhoto;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    

    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];//greyGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    // Do any additional setup after loading the view from its nib.
    self.imageView.image = self.fourSquarePhoto.photo;
    [self.imageView.layer setBorderWidth:0];
    [self.imageView.layer setCornerRadius:15.0];
    self.imageView.clipsToBounds = YES;
    
    //navigation title
    [self.navigationItem setTitle:@"Explore More"];
    
    //Add the restaurant name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 9*(self.fourSquarePhoto.venue.name.length), 20)];
    //styling... just a label
    [nameLabel.layer setBorderWidth:1];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel.layer setCornerRadius:5.0];
    [nameLabel setBackgroundColor:[UIColor whiteColor]];
    nameLabel.alpha = 0.7;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];

    [nameLabel setText:self.fourSquarePhoto.venue.name];
    [self.imageView addSubview:nameLabel];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)viewRestaurantDetails:(id)sender
{
    RestaurantDetailsViewController *vc = [[RestaurantDetailsViewController alloc] initWithNibName:@"RestaurantDetailsViewController" bundle:nil];
    vc.venue = self.fourSquarePhoto.venue;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goBackToSearchView:(id)sender {
    [self.delegate dismissMe];
}
@end
