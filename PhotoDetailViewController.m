//
//  photoDetailViewController.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/26/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "RestaurantDetailsViewController.h"

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
    // Do any additional setup after loading the view from its nib.
    self.imageView.image = self.fourSquarePhoto.photo;
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
    [self.presentingViewController performSelector:@selector(dismiss)];
}
@end
