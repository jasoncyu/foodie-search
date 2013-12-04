//
//  DraggableView.h
//  FoodieImageSearch
//
//  Created by Xinlei Xu on 12/4/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView {
    CGPoint offset;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *yesLabel;
@property (nonatomic, strong) UILabel *noLabel;

@property (nonatomic, strong) UIGestureRecognizer *singleTab;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)aImage;

- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer;
@end
