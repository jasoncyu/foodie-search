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
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

@implementation RestaurantLocation
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init]))
    {
        self.coordinate = coordinate;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
}
@end
