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
    float categoryRowY = 100;
    for (FourSquareCategory *category in self.venue.categories)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:category.icon];
        imageView.frame = CGRectMake(categoryRowX, categoryRowY, category.icon.size.width, category.icon.size.height);
        [self.view addSubview:imageView];
        
        categoryRowX += category.icon.size.width + 10;
    }
    
    //open/closed
    float openLabelY = categoryRowY + 50;
    UILabel *openLabel = [[UILabel alloc] initWithFrame:CGRectMake(categoryRowX, openLabelY, 100, 30)];
    openLabel.text = self.venue.openString;
    [self.view addSubview:openLabel];
    
    //view this restaurant in foursquare
    float y = openLabelY + 50;
    UIButton *openInFourSquareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, 50, 50)];
    UIImage *fourSquare = [UIImage imageNamed:@"foursquare-icon"];
    [openInFourSquareButton setImage:fourSquare forState:UIControlStateNormal];
    [openInFourSquareButton setCenter:self.view.center];
    [openInFourSquareButton addTarget:self action:@selector(openInFourSquare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openInFourSquareButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Open in Yelp
- (BOOL)isFourSquareInstalled
{
    return [[UIApplication sharedApplication]
                                  canOpenURL:[NSURL URLWithString:@"foursquare:"]];
}

- (void)openInFourSquare {
	if ([self isFourSquareInstalled]) {
		// Call into the Yelp app
        NSString *url = [NSString stringWithFormat:@"foursquare://venues/%@", self.venue.id];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
		// Use the Yelp touch site
        NSString *url = [NSString stringWithFormat:@"http://foursquare.com/venue/%@", self.venue.id];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	}
}
@end
