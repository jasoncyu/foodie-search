//
//  FourSquare.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "FourSquare.h"
#import "FourSquareCategory.h"
#import "UIImageView+WebCache.h"
#import "NSMutableArray+Shuffle.h"

#define CLIENT_ID @"H2NAFJGZIB0DHTN1EI5XCBS3O1RJY2V1T42CLACK3TQGQBET"
#define CLIENT_SECRET @"RMB4ZL04E05KQIJYX4ENRQBF1BLOUCW4PX22AVWCGZNZTD42"

@import CoreLocation;

@interface FourSquare () <CLLocationManagerDelegate, NSURLConnectionDataDelegate>
//@property CLLocationManager *locationManager;
@property CLLocation *location;

@property NSURLConnection *venuesConnection;
@property NSURLConnection *photosConnection;
@property NSURLSession *session;

@property SDWebImageManager *webImageManager;
@end

@implementation FourSquare {
    dispatch_queue_t backgroundQueue;
}
- (id) init
{
    //    self.locationManager = [[CLLocationManager alloc] init];
    //    self.locationManager.delegate = self;
    //    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    [self.locationManager startUpdatingLocation];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    
    self.webImageManager = [SDWebImageManager sharedManager];
    return self;
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

+ (NSString *)venueURLForId:(NSString *)id
{
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=%@&client_secret=%@&v=%@", id, CLIENT_ID, CLIENT_SECRET, @"20131123"];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)getVenuesForTerm:(NSString *) term completionBlock:(FourSquareVenueSearchCompletionBlock)completionBlock;
{
    //TODO: don't hardcode this
    
    NSString *location = @"Claremont, CA";
    NSString *searchURL = [FourSquare fourSquareSearchURLForSearchTerm:term near:location];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //        ULog(@"called");
        if (error)
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
            
            
            //Grab venues
            for (NSMutableDictionary *objVenue in objVenues) {
                __block FourSquareVenue *venue = [[FourSquareVenue alloc] init];
                venue.id = objVenue[@"id"];
                venue.name = objVenue[@"name"];
                venue.openString = objVenue[@"hours"][@"status"];
                
                NSArray *objCategories = objVenue[@"categories"];
                for (NSDictionary *objCategory in objCategories) {
                    FourSquareCategory *category = [[FourSquareCategory alloc] init];
                    category.name = objCategory[@"name"];
                    
                    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@bg_%d%@", objCategory[@"icon"][@"prefix"], 32, objCategory[@"icon"][@"suffix"]]];
                    [self.webImageManager downloadWithURL:iconURL
                                                  options:0
                                                 progress:nil
                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                    category.icon = image;
                                                    [venue.categories addObject:category];
                                                }];
                }
                
                [venues addObject:venue];
            }
            
            completionBlock(term, venues, error);
        }
    }];
    [dataTask resume];
}

//Needed because this returns more detailed information about a venue than
//searching for many venues
- (void)getVenueForId:(NSString *)id completionBlock:(FourSquareVenueDetailsCompletionBlock) completionBlock
{
    NSURL *url = [NSURL URLWithString:[FourSquare venueURLForId:id]];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *searchResultsDict = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:kNilOptions
                                           error:&error];
        NSDictionary *objVenue = searchResultsDict[@"response"][@"venue"];
        NSDictionary *objLocation = objVenue[@"location"];
        
        FourSquareVenue *venue = [[FourSquareVenue alloc] init];
        CLLocationCoordinate2D location;
        
        location.latitude = [objLocation[@"lat"] doubleValue];
        location.longitude = [objLocation[@"lng"] doubleValue];
        venue.location = location;
        
        completionBlock(venue, error);
    }];
    [dataTask resume];
}

- (void)photosForVenue:(FourSquareVenue *)venue completion:(void(^)(NSMutableArray *photos))completion
{
    NSString *searchURL = [FourSquare photoSeachURLForVenue:venue];
    NSMutableArray *photos = [NSMutableArray array];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //        ULog(@"called");
        NSDictionary *searchResultsDict = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:kNilOptions
                                           error:&error];
        NSArray *objPhotos = searchResultsDict[@"response"][@"photos"][@"items"];
        
        
        for (NSMutableDictionary *objPhoto in objPhotos) {
            DLog();
            NSString *photoURL = [NSString stringWithFormat:@"%@original%@",
                                  objPhoto[@"prefix"],
                                  objPhoto[@"suffix"]];
            
            FourSquarePhoto *photo = [[FourSquarePhoto alloc] init];
            photo.venue = venue;
            photo.imageURL =[NSURL URLWithString:photoURL];
            [photos addObject:photo];
        }
        
        completion(photos);
    }];
    
    [dataTask resume];
}

- (void)getPhotosForTerm:(NSString *)term completion:(FourSquarePhotoCompletionBlock)completion
{
    DLog();
    [self getVenuesForTerm:term completionBlock:^(NSString *searchTerm, NSArray *venues, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        if ([venues count] == 0) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"No restaurants found!", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                                       };
            NSError *error = [NSError errorWithDomain:@"Foodie"
                                                 code:-57 
                                             userInfo:userInfo];
            completion(nil, error);
            return;
        }
        
        NSMutableArray *outerPhotos = [NSMutableArray array];
        
        for (int i = 0; i < [venues count]; i++) {
            FourSquareVenue *venue = venues[i];
            [self photosForVenue:venue completion:^(NSMutableArray *photos) {
                [outerPhotos addObjectsFromArray:photos];
                
                //Hacky way of checking that I'm done with the last iteration
                if (i == [venues count] - 1) {
                    [self randomImagesWithPhotos:outerPhotos completion:completion];
                }
            }];
        }}];
}

//Download images from links in random order
- (void)randomImagesWithPhotos:(NSMutableArray *)photos completion:(FourSquarePhotoCompletionBlock) completion
{
    DLog(@"%lu", [photos count]);
    photos = [NSMutableArray fisherShuffle:photos];
    for (FourSquarePhoto *photo in photos) {
        [self.webImageManager downloadWithURL:photo.imageURL options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {;
            //                NSLog(@"received size: %lu", (unsigned long)receivedSize);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (error) {
                ULog(@"No photos found");
                return;
            }
            
            if (image) {
                photo.photo = image;
                
                completion(photo, error);
            } else {
                ULog(@"no image");
            }
        }];
    }
}

# pragma mark - CLLocationManagerDelegate methods
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    self.location = [locations lastObject];
//}

@end
