//
//  photoDetailViewController.h
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/26/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquarePhoto.h"

@interface PhotoDetailViewController : UIViewController
- (id)initWithFourSquarePhoto:(FourSquarePhoto *)fourSquarePhoto;
@end
