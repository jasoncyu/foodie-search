//
//  DraggableView.h
//  FoodieImageSearch
//
//  Created by Xinlei Xu on 12/4/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquarePhoto.h"
#import "FourSquareVenue.h"

@interface DraggableView : UIView {
    CGPoint offset;
}



@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *yesLabel;
@property (nonatomic, strong) UILabel *noLabel;
@property (nonatomic, strong) UILabel *checkedLabel;

@property(weak, nonatomic) FourSquarePhoto *fourSquarePhoto;

@property (nonatomic, strong) UIGestureRecognizer *singleTab;

- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer;

- (id)initWithFrame:(CGRect)frame andFourSquarePhoto:(FourSquarePhoto*) photoToAdd;


@end
