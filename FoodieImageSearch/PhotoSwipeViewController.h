//
//  PhotoSwipeViewController.h
//  FoodieImageSearch
//
//  Created by Xinlei Xu on 12/4/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"

@interface PhotoSwipeViewController : UIViewController

@property NSMutableArray *photos;

@property NSMutableArray *tempArray;
@property DraggableView *tempLastView;

@end
