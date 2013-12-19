//
//  DraggableView.m
//  FoodieImageSearch
//
//  Created by Xinlei Xu on 12/4/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "DraggableView.h"
#import "PhotoDetailViewController.h"
#import "FourSquareVenue.h"

@implementation UIView (AppNameAdditions)

- (UIViewController *)swipeViewController {
    /// Finds the view's view controller.
    
    // Take the view controller class object here and avoid sending the same message iteratively unnecessarily.
    Class vcc = [UIViewController class];
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: vcc])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

@end


@implementation DraggableView

/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}*/


- (id)initWithFrame:(CGRect)frame andFourSquarePhoto:(FourSquarePhoto *)photoToAdd
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.fourSquarePhoto = photoToAdd;
        
        self.imageView = [[UIImageView alloc] initWithImage:photoToAdd.photo];
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
    
        //Checked Label is almost always unseen
        self.checkedLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-180, 0, 180, 150)];
        
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
    if (self.center.x >= 160 && self.checkedLabel.alpha!=0.9f) {
        //rotation
        [self setTransform:CGAffineTransformMakeRotation(((self.center.x - 160.0f)/160.0f) * (M_PI/5))];
        
        //labels change opacity as centre changes
        self.yesLabel.alpha = (self.center.x - 160.0f)/160.0f;
        self.noLabel.alpha = 0.0f;
        
        //I want this to be the saved one
        //TODO: I dunno, just make it do more stuff
        
    }
    //swipe left
    if (self.center.x < 160 && self.checkedLabel.alpha!=0.9f) {
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
        //save the stack view from having too many subviews
        if(self.alpha < 0.05)
        {
            [self removeFromSuperview];
        }
        
    }
    
}

//When tapped, show info
- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    //image will only respond if it does not have a "X" label
    if (self.noLabel.alpha < 0.1f && self.checkedLabel.alpha!=0.9)
    {
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void)
        {
            self.imageView.alpha = 0.4;
            [self setTransform:CGAffineTransformMakeScale(0.3, 0.3)];
            //[self setTransform:CGAffineTransformMakeTranslation(-self.center.x+10, -self.center.y+10)];
            self.center = CGPointMake(20,20);
            
            self.checkedLabel.font = [UIFont fontWithName:@"Helvetica" size:36];
            self.checkedLabel.textAlignment = NSTextAlignmentCenter;
            self.checkedLabel.backgroundColor = [UIColor clearColor];
            self.checkedLabel.textColor = [UIColor whiteColor];
            self.checkedLabel.alpha = 1.0f;
            [self addSubview:self.checkedLabel];
        }
                         completion:^(BOOL finished)
        {
            self.checkedLabel.text = self.fourSquarePhoto.venue.name;
            PhotoDetailViewController *vc = [[PhotoDetailViewController alloc] initWithFourSquarePhoto:self.fourSquarePhoto];
            //Some sketchy things happening here
            vc.delegate = [self swipeViewController];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [[self swipeViewController] presentViewController:nav animated:YES completion:^{self.userInteractionEnabled = YES;}];
        }];
        
    }
    
    //In the case that the user decides to click on an image already "saved"
    //We display detail for it
    if (self.checkedLabel.alpha == 0.9f)
    {
        self.userInteractionEnabled = NO;
        PhotoDetailViewController *vc = [[PhotoDetailViewController alloc] initWithFourSquarePhoto:self.fourSquarePhoto];
        //Some sketchy things happening here
        vc.delegate = [self swipeViewController];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [[self swipeViewController] presentViewController:nav animated:YES completion:^{self.userInteractionEnabled = YES;}];
    }
    
    //TODO: Maybe in the else case, the fadded pic comes back (unfadded) and wobbles adorably... or something.
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
