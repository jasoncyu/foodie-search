//
//  photoDetailViewController.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/26/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property FourSquarePhoto *fourSquarePhoto;
@end

@implementation PhotoDetailViewController

- (id)initWithFourSquarePhoto:(FourSquarePhoto *)fourSquarePhoto;
{
    self = [super initWithNibName:@"PhotoDetailViewController" bundle:nil];
    if (self) {
        self.fourSquarePhoto = fourSquarePhoto;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.backButton addTarget:self.presentingViewController action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    self.imageView.image = self.fourSquarePhoto.photo;
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.presentingViewController performSelector:@selector(dismiss)];
}

@end
