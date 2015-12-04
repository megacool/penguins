//
//  Megacool.h
//  Megacool
//
//  Created by Nicolaj Broby Petersen on 10/27/15.
//  Copyright © 2015 Nicolaj Broby Petersen. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <UIKit/UIKit.h>

typedef void (^callbackWithParams) (NSArray *events, NSError *error);

@protocol MegacoolDelegate;

@protocol MegacoolDelegate <NSObject>
@optional


/*!
 @brief Optional callback when a user has completed a sharing

 @discussion Integration:

 1) Add a MegacoolDelegate to your Interface: @interface ViewController ()<MegacoolDelegate>
 2) Set Delegate to self: [[Megacool sharedMegacool] setDelegate:self];
 3) Add the method somewhere in your code:
 
 - (void)didCompleteShare{
    NSLog(@"Reward Player");
 }

 */
- (void)didCompleteShare;

/*!
 @brief Optional callback when a user has dismissed sharing

 @discussion Integration:

 1) Add a MegacoolDelegate to your Interface: @interface ViewController ()<MegacoolDelegate>
 2) Set Delegate to self: [[Megacool sharedMegacool] setDelegate:self];
 3) Add the method somewhere in your code:

 - (void)didDismissShareView{
    NSLog(@"Dismissed sharing");
 }

 */
- (void)didDismissShareView;

@end

@interface Megacool : NSObject


//
/*!
 @brief Initializes the SDK. Get your app config from your Megacool Dashboard.

 @param appConfig with the format @"prefix.appSecret"

 */
+ (void)startWithAppConfig:(NSString *)appConfig;

/*!
 @brief Initializes the SDK with a callback handler for deep link. Get your app config from your Megacool Dashboard.

 @param appConfig with the format @"prefix.appSecret"
 @param callback that is called when the session starts with information about if the user was invited through a link

 */
+ (void)startWithAppConfig:(NSString *)appConfig andEventHandler:(callbackWithParams)callback;

/*!
 @brief Allow Megacool to handle a link opening the app, returning whether it was from a Megacool link or not.

 @param url that caused the app to open.

 */
+(BOOL)handleDeepLink:(NSURL *)url;


/*!
 @brief Allow Megacool to handle a universal link opening the app, returning whether it was from a Megacool link or not.

 @param userActivity that caused the app to open.

 */

+(BOOL)continueUserActivity:(NSUserActivity *)userActivity;

/*!
 @brief Returns the singleton instance of Megacool. Must be used to call the Megacool methods

 */
+ (Megacool *)sharedMegacool;


// Start recording GIFs from a view. This will keep a buffer of the last 5 seconds. The frames are overwritten until stopRecording gets called.
- (void)startRecording:(UIView *)view;

// Capture a single frame of the UIView to the buffer. The frames are overwritten if they are over maxFrames (default 50).
- (void)captureFrame:(UIView *)view;

// Stop recording. Must be called before starting a new recording or switch to captureFrame recording
- (void)stopRecording;

// Render preview of Gif that can be showed before sharing. Call startAnimating / stopAnimating to play/pause the GIF
- (UIImageView *)renderPreviewOfGif;

// Render preview of Gif in a UIView that can be showed before sharing
- (UIImageView *)renderPreviewOfGifWithFrame:(CGRect)frame;

// Open Share Modal View in a View Controller - iPhone
- (void)openShareModalIn:(UIViewController *)viewController;

// Open Share Modal View in a View Controller - iPad (PopOver from Source View)
- (void)openShareModalIn:(UIViewController *)viewController fromSourceView:(UIView *)sourceView;

// Set sharing text
@property(nonatomic, strong) NSString *sharingText;

// Set numbers of frames per second to record. Default is 10 frames / second
@property(nonatomic) float frameRate;

// Set the size of the buffer of frames. Default is 50 frames
@property(nonatomic) int maxFrames;

// Set numbers of frames per second to play. Default is 10 frames / second
@property(nonatomic) float playbackFrameRate;

// Set a delay (in seconds) on last frame in gif. Default is 1 second
@property(nonatomic) int lastFrameDelay;

// Assign the delegate for status calls and configuration
@property (nonatomic, weak) id <MegacoolDelegate> delegate;


@end
