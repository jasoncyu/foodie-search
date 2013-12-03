//
//  RestaurantDetailsViewController.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 12/2/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "RestaurantDetailsViewController.h"
#import "FourSquareCategory.h"

@interface RestaurantDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RestaurantDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Nav bar
    [self.navigationItem setTitle:self.venue.name];
    
    //category icons
    float categoryRowX = 0;
    float categoryRowY = 50;
    for (FourSquareCategory *category in self.venue.categories)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:category.icon];
        imageView.frame = CGRectMake(categoryRowX, categoryRowY, category.icon.size.width, category.icon.size.height);
        [self.view addSubview:imageView];
        
        categoryRowX += category.icon.size.width + 10;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
