//
//  RestaurantLocation.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 12/4/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "RestaurantLocation.h"
@import AddressBook;

@interface RestaurantLocation ()
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@property NSString *address;
@property NSString *name;
@end

@implementation RestaurantLocation
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                    name:(NSString *)name
{
    if ((self = [super init]))
    {
        self.theCoordinate = coordinate;
        self.name = name;
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error != nil) {
                NSString *errorMessage = [NSString stringWithFormat:@"%@: %@", [error localizedDescription], [error localizedFailureReason]];
                DLog(@"%@", errorMessage);
            }
            
            if (placemarks && [placemarks count] > 0) {
                CLPlacemark *placemark = placemarks[0];
                self.address = [NSString stringWithFormat:@"%@ %@,%@ %@", [placemark subThoroughfare],[placemark thoroughfare],[placemark locality], [placemark administrativeArea]];
            } else {
                DLog(@"address not found for this location");
            }
        }];
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}
@end
