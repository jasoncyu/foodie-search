//
//  RestaurantDetailsViewController.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 12/2/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//
#import "RestaurantDetailsViewController.h"
#import "FourSquareCategory.h"
#import "FourSquare.h"
#import "RestaurantLocation.h"

@import CoreLocation;
@import MapKit;

#define METERS_PER_MILE 1609.344

@interface RestaurantDetailsViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property MKMapView *mapView;
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
    
    //Map view
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //seems faster to execute in a background thread, but need to fiddle with the map a bit for the marker to show
    FourSquare *fs = [[FourSquare alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^{
        [fs getVenueForId:self.venue.id completionBlock:^(FourSquareVenue *venue, NSError *error) {
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(venue.location, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
            [self.mapView setRegion:viewRegion];
            
            RestaurantLocation *location = [[RestaurantLocation alloc] initWithCoordinate:venue.location name:_venue.name];
            [self.mapView addAnnotation:location];
            [self.mapView setCenterCoordinate:venue.location];
            DLog();
        }];
    });

    //category icons
    float categoryRowX = 0;
    float categoryRowY = 300;
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
    UIImage *fourSquareIcon = [UIImage imageNamed:@"foursquare-icon"];
    [openInFourSquareButton setImage:fourSquareIcon forState:UIControlStateNormal];
    [openInFourSquareButton setCenter:self.view.center];
    [openInFourSquareButton addTarget:self action:@selector(openInFourSquare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openInFourSquareButton];
    
    FourSquare *fourSquare = [[FourSquare alloc] init];
    [fourSquare getVenueForId:self.venue.id completionBlock:^(FourSquareVenue *venue, NSError *error) {
        ;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Open in FourSquare
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

#pragma mark - MKMapViewDelegate methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"RestaurantLocation";
    if ([annotation isKindOfClass:[RestaurantLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
//        FourSquareCategory *firstCategory = self.venue.categories[0];
//        annotationView.image = firstCategory.icon;
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    RestaurantLocation *location = view.annotation;
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving};
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}
@end
