//
//  FourSquareVenue.h
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/24/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquareVenue : NSObject
@property NSString *id;
@property NSString *name;
//array of FourSquareCategories
@property NSMutableArray *categories;
//A message describing if the restaurant is open/closed
@property NSString *openString;
@end
