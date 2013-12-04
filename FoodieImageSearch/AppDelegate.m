//
//  AppDelegate.m
//  FoodieImageSearch
//
//  Created by Jason Yu on 11/23/13.
//  Copyright (c) 2013 JasonMimee. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoCollectionViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //create the tab bar controller object
    self.tabBarController = [[UITabBarController alloc] init];
    
    //create the first view controller
    UIViewController *cellModeVC = [[PhotoCollectionViewController alloc] initWithNibName:@"PhotoCollectionViewController" bundle:nil];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    //    older config:
    //self.window.rootViewController = cellModeVC;

    
    
    
    [cellModeVC.view setBackgroundColor:[UIColor whiteColor]];
    [cellModeVC.view setFrame:[[UIScreen mainScreen] bounds]];
    //this is where we set the red view's representation on the tab bar
    cellModeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Span" image:nil tag:1];
    
    //create the second view controller
    /*\TODO actually it should be its own controller*/
    UIViewController *swipeModeVC = [[PhotoCollectionViewController alloc] init];
    [swipeModeVC.view setBackgroundColor:[UIColor grayColor]];
    [swipeModeVC.view setFrame:[[UIScreen mainScreen] bounds]];
    //this is where we set the second view's representation on the tab bar
    swipeModeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Decision" image:nil tag:2];
    
    //add the viewcontrollers to the tab bar
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:cellModeVC, swipeModeVC, nil] animated:YES];
    
    //add the tabbarcontroller as the root view for the App
    [self.window setRootViewController:self.tabBarController];
    
    
    //
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
