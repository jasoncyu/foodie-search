//
//  photoDetailViewController.h
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/26/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquarePhoto.h"
#import "FourSquareVenue.h"

@protocol PhotoDetailViewControllerDelegate <NSObject>

- (void)dismissMe;

@end

@interface PhotoDetailViewController : UIViewController
@property id <PhotoDetailViewControllerDelegate> delegate;

- (id)initWithFourSquarePhoto:(FourSquarePhoto *)fourSquarePhoto;
@end
