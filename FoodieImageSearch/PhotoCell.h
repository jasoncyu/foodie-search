//
//  PhotoCell.h
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/25/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquarePhoto.h"

@interface PhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property(weak, nonatomic) FourSquarePhoto *fourSquarePhoto;


@end
