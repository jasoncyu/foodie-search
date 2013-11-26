//
//  ViewController.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "ViewController.h"
#import "FourSquare.h"
#import "FourSquareVenue.h"
#import "FourSquarePhoto.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FourSquare *fourSquare = [[FourSquare alloc] init];
//    [fourSquare testSession];
    __block FourSquareVenue *venue = [[FourSquareVenue alloc] init];
    [fourSquare getVenuesForTerm:@"thai" completionBlock:^(NSString *searchTerm, NSArray *venues, NSError *error) {
        NSLog(@"%@", venues);
        if(venues && [venues count] > 0) {
            venue = venues[0];
            DLog(@"%@", venue.id);
        } else {
            NSLog(@"Error searching venues: %@", error);
        }
        
        [fourSquare getPhotosForVenue:venue completionBlock:^(NSMutableArray *photos, NSError *error) {
            if (photos && [photos count] > 0) {
                FourSquarePhoto *photo = photos[0];
                NSLog(@"%@", photo.photo);
            } else {
                DLog(@"No photos found");
            }
            
        }];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
