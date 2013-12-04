//
//  PhotoCell.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/25/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)setFourSquarePhoto:(FourSquarePhoto *)fourSquarePhoto
{
    //Write all the magic numbers on earth!
    //... ...
    
    /*\TODO do not write magic numbers! */
    /* \brief crop the image into 300 by 300 from the center*/
    UIImage *image = fourSquarePhoto.photo;
    double x = (image.size.width - 420) / 2.0;
    double y = (image.size.height - 420) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, 420, 420);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    
    //background view
    /*\TODO: filter them */
    self.backgroundView = [[UIImageView alloc] initWithImage:cropped] ;
    self.backgroundView.alpha = 0.80;
    [self.backgroundView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.backgroundView.layer setBorderWidth: 2.0];
    [self.backgroundView.layer setCornerRadius:12.0];
    [self.backgroundView.layer setShadowOffset: CGSizeMake(4,-4)];
    //[self.photo.layer setShadowColor: [[UIColor grayColor] CGColor]];
    //[self.photo.layer setShadowOffset: CGSizeMake(4, -4)];
    self.backgroundView.clipsToBounds = YES;
    
    
    //old code about self.photo
    /*
    self.photo.image = cropped;
    self.photo.image = fourSquarePhoto.photo;
    self.photo.alpha = 0.55;
    self.photo.contentMode = UIViewContentModeScaleToFill;
     */
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
