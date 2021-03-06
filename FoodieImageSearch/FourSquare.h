//
//  FourSquare.h
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FourSquareVenue.h"
#import "FourSquarePhoto.h"

typedef void (^FourSquareVenueSearchCompletionBlock)(NSString *searchTerm, NSArray *venues, NSError *error);
typedef void (^FourSquareVenueDetailsCompletionBlock)(FourSquareVenue *venue, NSError *error);
typedef void (^FourSquarePhotoCompletionBlock)(FourSquarePhoto *photo, NSError *error);
typedef void (^PhotosDownloadedBlock)();

@interface FourSquare : NSObject
- (void)getVenueForId:(NSString *)id completionBlock:(FourSquareVenueDetailsCompletionBlock) completionBlock;
- (void)getPhotosForTerm:(NSString *)term location:(NSString *)location
              completion:(FourSquarePhotoCompletionBlock)completion;
@end
