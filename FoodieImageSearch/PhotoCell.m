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
    self.photo.image = fourSquarePhoto.photo;
    self.photo.contentMode = UIViewContentModeScaleToFill;
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
