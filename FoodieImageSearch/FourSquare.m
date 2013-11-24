//
//  FourSquare.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "FourSquare.h"
#import "FourSquareVenue.h"

#define CLIENT_ID @"H2NAFJGZIB0DHTN1EI5XCBS3O1RJY2V1T42CLACK3TQGQBET"
#define CLIENT_SECRET @"RMB4ZL04E05KQIJYX4ENRQBF1BLOUCW4PX22AVWCGZNZTD42"

@import CoreLocation;

@interface FourSquare () <CLLocationManagerDelegate>
@property CLLocationManager *locationManager;
@property CLLocation *location;
@end

@implementation FourSquare
- (id) init
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    return self;
}

+ (NSString *)fourSquareSearchURLForSearchTerm:(NSString *) searchTerm near:(NSString *)location
{
//    float latitude = location.coordinate.latitude;
//    float longitude = location.coordinate.longitude;
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?near=%@&client_id=%@&client_secret=%@&v=%@", location, CLIENT_ID, CLIENT_SECRET, @"20131123"];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return escapedURL;
}

- (void)searchFourSquareForTerm:(NSString *) term completionBlock:(FourSquareSearchCompletionBlock) completionBlock
{
    NSURLSession *session = [NSURLSession sharedSession];
    //TODO: don't hardcode this
    NSString *location = @"Claremont, CA";
    NSString *searchURL = [FourSquare fourSquareSearchURLForSearchTerm:term near:location];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        [[session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error != nil)
            {
                NSLog(@"%@", error);
                completionBlock(term,nil,error);
            }
            else
            {
                NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:kNilOptions
                                                                                    error:&error];
                
                NSArray *objVenues = searchResultsDict[@"response"][@"venues"];
                NSMutableArray *venues = [@[] mutableCopy];
                
                for (NSMutableDictionary *objVenue in objVenues) {
                    FourSquareVenue *venue = [[FourSquareVenue alloc] init];
                    venue.id = objVenue[@"id"];
                    venue.name = objVenue[@"name"];
                    
                    [venues addObject:venue];
                }
                
                completionBlock(term,venues,error);
                
            }
        }] resume];
    });
}

# pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
}
@end
