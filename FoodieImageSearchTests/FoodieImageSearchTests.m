//
//  FoodieImageSearchTests.m
//  FoodieImageSearchTests
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FourSquare.h"
#import "FourSquareVenue.h"
#import "FourSquarePhoto.h"

@interface FoodieImageSearchTests : XCTestCase

@end

@implementation FoodieImageSearchTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFourSquareSearch
{
    FourSquare *fourSquare = [[FourSquare alloc] init];
    __block FourSquareVenue *venue = [[FourSquareVenue alloc] init];
    [fourSquare getVenuesForTerm:@"thai" completionBlock:^(NSString *searchTerm, NSArray *venues, NSError *error) {
        venue = venues[0];
    }];
    
    [fourSquare getPhotosForVenue:venue completionBlock:^(NSMutableArray *photos, NSError *error) {
        XCTAssertEqual([photos count], 5, "Size wrong");
    }];
}

@end
