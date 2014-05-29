//
//  MHJAppDelegate.m
//  MapDemo
//
//  Created by Miguel Hernández Jaso on 29/05/14.
//  Copyright (c) 2014 Miguel Hernández. All rights reserved.
//

#import "MHJAppDelegate.h"
#import "MHJMapVC.h"

@implementation MHJAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // Init
    MHJMapVC *mapVC = [[MHJMapVC alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = mapVC;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
