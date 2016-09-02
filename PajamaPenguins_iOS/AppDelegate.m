//
//  AppDelegate.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "AppDelegate.h"
#import "PPBackgroundManager.h"
#import "PPUserManager.h"
#import <Megacool/Megacool.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [PPUserManager sharedManager];
  [PPBackgroundManager sharedManager];

  [Megacool
      startWithAppConfig:@"pajama.8yXXNXRUSjDTUVQ9ajUC"
         andEventHandler:^(NSArray<MCLEvent *> *events) {

           for (MCLEvent *event in events) {
             /* THIS DEVICE */

             // MCLEventLinkClicked
             // The app has been opened from a link click, send the user
             // instantly to
             // the right scene
             if (event.type == MCLEventLinkClicked) {
               NSURL *URL = event.data[MCLEventDataURL];
               MCLReferralCode *referralCode =
                   event.data[MCLEventDataReferralCode];

               NSLog(@"To path: %@ with query: %@", URL.path, URL.query);
               NSLog(@"Invited by userId: %@", referralCode.userId);

               [[NSNotificationCenter defaultCenter]
                   postNotificationName:@"scenePreferences"
                                 object:URL];
             }

             // MCLEventReceivedShareOpened && isFirstSession
             // This device has received a share to the app and installed
             // it
             if (event.type == MCLEventReceivedShareOpened &&
                 event.isFirstSession) {
               NSURL *URL = event.share.URL;
               MCLReferralCode *referralCode = event.share.referralCode;
               NSDictionary *shareData = event.share.data;
               NSString *welcomeText = shareData[@"welcomeText"];

               [[NSNotificationCenter defaultCenter]
                   postNotificationName:@"scenePreferences"
                                 object:URL];
               [self showAlertWithTitle:@"Welcome bonus! 100💰"
                             andMessage:welcomeText];

               [self updateCoins:100];

               NSLog(@"Invited by userId: %@", referralCode.userId);
               NSLog(@"To path: %@ with query: %@", URL.path, URL.query);
               NSLog(@"Welcome text: %@", welcomeText);
             }

             // MCLEventReceivedShareOpened && !isFirstSession
             // This device has received a share to the app and opened it
             if (event.type == MCLEventReceivedShareOpened &&
                 !event.isFirstSession) {
               NSURL *URL = event.share.URL;
               MCLReferralCode *referralCode = event.share.referralCode;
               NSDictionary *shareData = event.share.data;
               NSString *welcomeText = shareData[@"welcomeText"];

               [[NSNotificationCenter defaultCenter]
                   postNotificationName:@"scenePreferences"
                                 object:URL];

               [self showAlertWithTitle:@"Welcome!" andMessage:welcomeText];

               NSLog(@"Invited by userId: %@", referralCode.userId);
               NSLog(@"To path: %@ with query: %@", URL.path, URL.query);
               NSLog(@"Welcome text: %@", welcomeText);
             }
             /* FRIEND'S DEVICE */

             // MCLEventSentShareOpened && isFirstSession
             // Friend's device has received a share to the app and
             // installed it, add
             // him as
             // friend!
             if (event.type == MCLEventSentShareOpened &&
                 event.isFirstSession) {
               NSString *userId = event.data[MCLEventDataReceiverUserId];
               NSLog(@"User id %@ has installed the app", userId);

               [self showAlertWithTitle:@"Reward!"
                             andMessage:@"A friend has installed the "
                                        @"app! Here's 100 coins"];
             }

             // MCLEventSentShareOpened && !isFirstSession
             // Friend's device has received a share to the app and opened
             // it, join his
             // session!
             if (event.type == MCLEventSentShareOpened &&
                 !event.isFirstSession) {

               [self showAlertWithTitle:@"Welcome!"
                             andMessage:@"Your friend has opened the invite"];

               NSString *userId = event.data[MCLEventDataReceiverUserId];
               NSLog(@"User id %@ has opened the app", userId);
             }
           }
         }];

  [[Megacool sharedMegacool] setLastFrameDelay:1.5];

  return YES;
}

- (void)updateCoins:(int)amount {

  NSNumber *coins =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"UserTotalCoins"];

  coins = [NSNumber numberWithInt:[coins intValue] + amount];

  [[NSUserDefaults standardUserDefaults] setObject:coins
                                            forKey:@"UserTotalCoins"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"Megacool!"
                                        otherButtonTitles:nil];

  dispatch_async(dispatch_get_main_queue(), ^{
    [alert show];
  });
}

MEGACOOL_DEFAULT_LINK_HANDLERS

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
