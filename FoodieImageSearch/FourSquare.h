//
//  FourSquare.h
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FourSquareSearchCompletionBlock)(NSString *searchTerm, NSArray *results, NSError *error);
typedef void (^FourSquarePhotoCompletionBlock)(UIImage *photoImage, NSError *error);

@interface FourSquare : NSObject
- (void)searchFourSquareForTerm:(NSString *) term completionBlock:(FourSquareSearchCompletionBlock) completionBlock;
@end
