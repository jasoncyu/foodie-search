//
//  FourSquareVenue.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/24/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "FourSquareVenue.h"
#import "FourSquarePhoto.h"
@implementation FourSquareVenue

-(id)init
{
    self = [super init];
    self.categories = [NSMutableArray array];
    self.photos = [NSMutableArray array];
    self.startedDownload = NO;
    self.poppedAPhoto = NO;
    return self;
}

- (void)addPhoto:(FourSquarePhoto *)photo
{
    self.startedDownload = YES;
    [self.photos addObject:photo];
//    DLog(@"%lu", (unsigned long)[self.photos count]);
}

- (FourSquarePhoto *)popPhoto
{
    FourSquarePhoto *ret = self.photos[0];
    [self.photos removeObjectAtIndex:0];
    self.poppedAPhoto = YES;
    return ret;
}

- (BOOL)noPhotos
{
    return [self.photos count] == 0;
}

@end
