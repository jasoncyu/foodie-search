//
//  FourSquare.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "FourSquare.h"
#import "FourSquarePhoto.h"
#import "FourSquareVenue.h"

#define CLIENT_ID @"H2NAFJGZIB0DHTN1EI5XCBS3O1RJY2V1T42CLACK3TQGQBET"
#define CLIENT_SECRET @"RMB4ZL04E05KQIJYX4ENRQBF1BLOUCW4PX22AVWCGZNZTD42"

@import CoreLocation;

@interface FourSquare () <CLLocationManagerDelegate, NSURLConnectionDataDelegate>
@property CLLocationManager *locationManager;
@property CLLocation *location;

@property NSURLConnection *venuesConnection;
@property NSURLConnection *photosConnection;
@property NSURLSession *session;


@end

@implementation FourSquare
- (id) init
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    
    return self;
}

-(void)testSession
{
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:@"www.google.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        ULog(@"called");
    }];
                                      
    [dataTask resume];
}
+ (NSString *)photoSeachURLForVenue:(FourSquareVenue *)venue
{
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&v=%@", venue.id, CLIENT_ID, CLIENT_SECRET, @"20131123"];
    return url;
}

+ (NSString *)fourSquareSearchURLForSearchTerm:(NSString *) searchTerm near:(NSString *)location
{
//    float latitude = location.coordinate.latitude;
//    float longitude = location.coordinate.longitude;
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?near=%@&query=%@&client_id=%@&client_secret=%@&v=%@", location, searchTerm, CLIENT_ID, CLIENT_SECRET, @"20131123"];
    NSString *escapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return escapedURL;
}

- (void)getVenuesForTerm:(NSString *) term completionBlock:(FourSquareVenueSearchCompletionBlock)completionBlock;
{
    //TODO: don't hardcode this
    NSString *location = @"Claremont, CA";
    NSString *searchURL = [FourSquare fourSquareSearchURLForSearchTerm:term near:location];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSError *error = nil;
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        ULog(@"called");
        if (error != nil)
        {
            completionBlock(term, nil, error);
        }
        else
        {
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                                error:&error];
//            NSLog(@"%@", searchResultsDict);
            NSArray *objVenues = searchResultsDict[@"response"][@"venues"];
            NSMutableArray *venues = [@[] mutableCopy];
            
            for (NSMutableDictionary *objVenue in objVenues) {
                FourSquareVenue *venue = [[FourSquareVenue alloc] init];
                venue.id = objVenue[@"id"];
                venue.name = objVenue[@"name"];
                
                [venues addObject:venue];
            }
            
            completionBlock(term, venues, error);
        }
    }];
    [dataTask resume];
}

// 5 photo per venue
- (void)getPhotosForVenue:(FourSquareVenue *)venue completionBlock:(FourSquarePhotoCompletionBlock) completionBlock
{
    if (venue == nil || venue.id == nil) {
        ULog(@"No such venue");
    }
    NSString *searchURL = [FourSquare photoSeachURLForVenue:venue];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSError * error = nil;
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        ULog(@"called");
        NSDictionary *searchResultsDict = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:kNilOptions
                                           error:&error];
        
        int count = searchResultsDict[@"response"][@"photos"][@"count"];
        NSArray *objPhotos = searchResultsDict[@"response"][@"photos"][@"items"];
        NSMutableArray *fourSquarePhotos = [@[] mutableCopy];
        
        //First 5 images
        int i = 0;
        for (NSMutableDictionary *objPhoto in objPhotos) {
            NSString *photoURL = [NSString stringWithFormat:@"%@original%@",
                                  objPhoto[@"prefix"],
                                  objPhoto[@"suffix"]];
            DLog(@"%@", photoURL);
            FourSquarePhoto *fourSquarePhoto = [[FourSquarePhoto alloc] init];
            UIImage *photoMaybe = [[UIImage alloc]
             initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]];
            if (!photoMaybe) {
                DLog(@"Bad photo url");
            }
//            DLog(@"photo size: %@", NSStringFromCGSize(photoMaybe.size));
            fourSquarePhoto.photo = photoMaybe;
            fourSquarePhoto.venue = venue;
            
            [fourSquarePhotos addObject:fourSquarePhoto];
            i++;
            if (i == 5) {
                break;
            }
        }
        
        completionBlock(fourSquarePhotos, error);
    }];
    [dataTask resume];
}

# pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
}

@end
