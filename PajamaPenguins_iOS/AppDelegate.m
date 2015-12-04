//
//  AppDelegate.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "AppDelegate.h"
#import "PPUserManager.h"
#import "PPBackgroundManager.h"
#import <Megacool/Megacool.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PPUserManager sharedManager];
    [PPBackgroundManager sharedManager];
    [Megacool startWithAppConfig:@"pajama.8yXXNXRUSjDTUVQ9ajUC"];
    //[[Megacool sharedMegacool] setFrameRate:5];
    //[[Megacool sharedMegacool] setMaxFrames:25];
    //[[Megacool sharedMegacool] setLastFrameDelay:2];
    //[[Megacool sharedMegacool] setPlaybackFrameRate:25];
    //[[Megacool sharedMegacool] setSharingText:@"Try to beat my score!"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    // pass the url to the handle deep link call
    
    [Megacool handleDeepLink:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    return [Megacool continueUserActivity:userActivity];
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
