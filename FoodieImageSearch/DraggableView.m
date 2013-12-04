//
//  DraggableView.m
//  FoodieImageSearch
//
//  Created by Xinlei Xu on 12/4/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "DraggableView.h"
#import "RestaurantDetailsViewController.h"
@implementation DraggableView

/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}*/


- (id)initWithFrame:(CGRect)frame image:(UIImage*)aImage
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.imageView = [[UIImageView alloc] initWithImage:aImage];
        CALayer *layerToStyle = self.imageView.layer;
        layerToStyle.borderWidth = 2.0;
        layerToStyle.cornerRadius = 6.0;
        layerToStyle.shadowColor= [[UIColor grayColor] CGColor];
        [layerToStyle setShadowOffset:CGSizeMake(40, 40)];
        self.imageView.clipsToBounds = YES;

        self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.imageView];
        
        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-180, 0, 180, 150)];
        self.noLabel.text = @"X";
        self.noLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:188];
        self.noLabel.textAlignment = NSTextAlignmentCenter;
        self.noLabel.backgroundColor = [UIColor clearColor];
        self.noLabel.textColor = [UIColor redColor];
        self.noLabel.alpha = 0.0f;
        [self addSubview:self.noLabel];
        
        self.yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 150)];
        self.yesLabel.text = @"OK!";
        self.yesLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:26];
        self.yesLabel.textAlignment = NSTextAlignmentCenter;
        self.yesLabel.backgroundColor = [UIColor clearColor];
        self.yesLabel.textColor = [UIColor orangeColor];
        self.yesLabel.alpha = 0.0f;
        [self addSubview:self.yesLabel];
        
        //add gestureRecogniser
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:singleTap];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

//The clicked photo shows on top layer
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    offset = [aTouch locationInView: self];
    
    //bring me to top
    [self.superview bringSubviewToFront:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    
    CGPoint temp = CGPointMake(location.x - offset.x + 100, location.y - offset.y + 100);
    
    [UIView beginAnimations:@"Dragging A DraggableView" context:nil];
    self.center = temp;
    [UIView commitAnimations];
    
    //swipe right
    if (self.center.x >= 160) {
        //rotation
        [self setTransform:CGAffineTransformMakeRotation(((self.center.x - 160.0f)/160.0f) * (M_PI/5))];
        
        //labels
        //change opacity as centre changes
        self.yesLabel.alpha = (self.center.x - 160.0f)/160.0f;
        self.noLabel.alpha = 0.0f;
        
        //I want this to be the saved one
        //TODO: I dunno, just make it do more stuff
        
    }
    //swipe left
    else {
        //rotation
        [self setTransform:CGAffineTransformMakeRotation((self.center.x - 160.0f)/160.0f * (M_PI/5))];
        
        //labels
        self.noLabel.alpha = (160.0f - self.center.x)/160.0f;
        self.yesLabel.alpha = 0.0f;
        
        //i want the "X"-ed images to disappear
        //rotation that marked abandonment
        //TODO: Make sure this feels alright
        // would minimizing the image feel better?
        [self setTransform:CGAffineTransformMakeRotation(((self.center.x - 160.0f)/160.0f) * (2* M_PI/5))];
        // disappear by fading
        self.alpha = ((self.center.x-10)/160.0f);
        
    }
    
}

//When tapped, show info
- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    //image will only respond if it does not have a "X" label
    if (self.noLabel.alpha < 0.1f) {
        [UIView animateWithDuration:0.5 animations:^(void){
            self.imageView.alpha = 0.4f;
            //TODO: find a better font.
            self.yesLabel.font = [UIFont fontWithName:@"ArialRoundedMT" size:22];
            self.yesLabel.textColor = [UIColor whiteColor];
            
            RestaurantDetailsViewController *vc = [[RestaurantDetailsViewController alloc] initWithNibName:@"RestaurantDetailsViewController" bundle:nil];
            vc.venue = self.fourSquarePhoto.venue;
            

            //TODO: Fetch restaurant info
            self.yesLabel.text = self.fourSquarePhoto.venue.name;
            self.yesLabel.alpha = 1.0f;
            //[self presentViewController:vc animated:YES];
        }];
    }
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
