//
//  RestaurantLocation.h
//  FoodieImageSearch
//
//  Created by Jason Yu on 12/4/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
@interface RestaurantLocation : NSObject <MKAnnotation>
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
