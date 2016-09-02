//
//  Megacool.h
//
//  An online version of the documentation can be found at https://docs.megacool.co
//
//  Do you feel like this reading docs? (╯°□°）╯︵ ┻━┻  Give us a shout if there's anything that's
//  unclear and we'll try to brighten the experience. We can sadly not replace flipped tables.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <UIKit/UIKit.h>

#import "MCLConstants.h"
#import "MCLEvent.h"
#import "MCLShare.h"

#ifndef MEGACOOL_SDK_VERSION
#define MEGACOOL_SDK_VERSION @"2.0.0-rc"
#endif


#define MEGACOOL_DEFAULT_LINK_HANDLERS /*iOS 9 deep link handler*/                         \
    -(BOOL)application : (UIApplication *)application openURL                              \
                         : (NSURL *)url options                                            \
                           : (nonnull NSDictionary<NSString *, id> *)options {             \
        [[Megacool sharedMegacool] handleDeepLink:url];                                    \
        return YES;                                                                        \
    }                                                                                      \
                                                                                           \
    /*iOS 4-8 deep link handler */                                                         \
    -(BOOL)application : (UIApplication *)application openURL                              \
                         : (NSURL *)url sourceApplication                                  \
                           : (NSString *)sourceApplication annotation : (id)annotation {   \
        [[Megacool sharedMegacool] handleDeepLink:url];                                    \
        return YES;                                                                        \
    }                                                                                      \
                                                                                           \
    /*iOS 9 Universal Link hander */                                                       \
    -(BOOL)application : (UIApplication *)application continueUserActivity                 \
                         : (NSUserActivity *)userActivity restorationHandler               \
                           : (void (^)(NSArray * restorableObjects))restorationHandler {   \
        return [[Megacool sharedMegacool] continueUserActivity:userActivity];              \
    }                                                                                      \
                                                                                           \
    /* Background upload/download handler (gif upload and fallback image download) */      \
    -(void)application : (UIApplication *)application handleEventsForBackgroundURLSession  \
                         : (NSString *)identifier completionHandler                        \
                           : (void (^)())completionHandler {                               \
        [[Megacool sharedMegacool] handleEventsForBackgroundURLSession:identifier          \
                                                     completionHandler:completionHandler]; \
    }

typedef void (^MCLEventHandlerCallback)(NSArray<MCLEvent *> *events);
typedef void (^MCLShareStateCallback)(NSArray<MCLShare *> *shares);
typedef BOOL (^MCLShareFilterCallback)(MCLShare *share);
typedef void (^MCLReferralCodeCallback)(NSString *referralCode);

@protocol MCLDelegate;

@protocol MCLDelegate<NSObject>
@optional


/*!
 @brief Optional callback when a user has completed a share.

 @discussion Integration:

 1) Add a MCLDelegate to your Interface: @c \@interface ViewController ()<MCLDelegate>

 2) Set Delegate to self: <tt> [[Megacool sharedMegacool] setDelegate:self];</tt>

 3) Implement the method somewhere in your code:

 @code
 - (void) megacoolDidCompleteShare {
    NSLog(@"Reward Player");
 }
 @endcode

 @remarks This method being called does not imply that anyone has actually joined the
 game from the share, only that the share was sent over some channel.
 */
- (void)megacoolDidCompleteShare;


/*!
 @brief Optional callback when a user has aborted (dismissed) a share.

 @discussion Integration:

 1) Add a MCLDelegate to your Interface: <tt> @interface ViewController ()<MCLDelegate>
 </tt>
 2) Set Delegate to self: <tt> [[Megacool sharedMegacool] setDelegate:self]; </tt>
 3) Add the method somewhere in your code:

 @code
 - (void)megacoolDidDismissShareView{
    NSLog(@"Dismissed sharing");
 }
 @endcode
 */
- (void)megacoolDidDismissShareView;

@end

@interface Megacool : NSObject


/*!
 @brief Initializes the SDK. Get your app config from your Megacool Dashboard.

 @param appConfig NSString with the format @c \@"prefix.appSecret"
 */
+ (void)startWithAppConfig:(NSString *)appConfig;


/*!
 @brief Initializes the SDK with a callback handler for events. Get your app config from your
 Megacool Dashboard.

 @param NSString appConfig with the format @c \@"prefix.secret"
 @param callback A block that is called when a Megacool event occurs. The callback is passed a
 @c NSArray<MCLEvent *> with the events that have occured. A @c MCLEvent may
 contain a @c MCLShare. There are 3 main events to handle:
 <ul>
   <li>
     <b> MCLEventLinkClicked </b> : The app was opened from a link click. @c MCLEvent.type is
     MCLEventLinkClicked and @c event.data contains the path, query, referralCode and full URL, to
     send the user to the right scene. A request is sent to the server asap, and a @c MCLEvent
     with type @c receivedShareOpened will be passed to the callback with the associated share.
   </li>
   <li>
     <b> MCLEventReceivedShareOpened </b>: When a shared link is clicked to either open or install
     the app, the eventHandler will receive the @c MCLEvent from the server. The @c
     MCLEvent.type is MCLEventReceivedShareOpened. @c isFirstSession is a boolean telling if the
     app was opened for the first time (new install) or just opened. The @c MCLShare is the
     object that was sent to this user.
   </li>
   <li>
     <b> MCLEventSentShareOpened </b>: When a shared link is clicked by <i>another</i> user and the
     app opens, a @c MCLEvent will be triggered. The @c event.type is @c
     MCLEventSentShareOpened, and the event contains the share object that was sent from this user.
     It also indicates if it was a first session and the @c event.data contains the other users
     referral code @c MCLEventDataReceiverReferralCode so you can match the users on your own.
   </li>
 </ul>
 */
+ (void)startWithAppConfig:(NSString *)appConfig andEventHandler:(MCLEventHandlerCallback)callback;


/*!
 @brief Extract the URL from a link click.

 @discussion Add this to <tt>- application:openURL:options:</tt> in your AppDelegate. If the URL was
 a Megacool URL, the event handler will be called with a @c MCLEventLinkClicked event.

 @param url The url that was clicked. Megacool URLs will be either
 https://mgcl.co/youridentifer/some/path=?_m=<referralCode> or
 yourscheme:///some/path?_m=<referralCode>.
 */
- (void)handleDeepLink:(NSURL *)url;


/*!
 @brief Allow Megacool to handle a universal link opening the app, returning whether it was from a
 Megacool link or not. Add this to <tt>- application:continueUserActivity:restorationHandler:</tt>
 in your
 AppDelegate.

 @param userActivity that caused the app to open.
 */
- (BOOL)continueUserActivity:(NSUserActivity *)userActivity;


/*!
 @brief Returns the singleton instance of Megacool. Must be used to call the Megacool methods.
 */
+ (Megacool *)sharedMegacool;


/*!
 @brief Start recording a GIF from a view.

 @discussion This will keep a buffer of 50 frames (default). The frames are overwritten until
 @c stopRecording gets called.

 @param view UIView you want to record
 */
- (void)startRecording:(UIView *)view;


/*!
 @brief Start customized GIF recording

 @discussion This will keep a buffer of 50 frames (default). The frames are overwritten until
 @c stopRecording gets called.

 @param view UIView you want to record
 @param config NSDictonary to customize the recording. The following keys are accepted in the
 dictionary:

 <ul>
    <li>
        <b> @c crop </b>: Crops the recording (surprise!) to the given area. Example:
        <tt> \@{@"crop":[NSValue valueWithCGRect:CGRectMake(0, 100, 300, 300)]} </tt>
    </li>
    <li>
        <b> @p recordingId @c </b>: An identifier for this recording. Can be used to retrieve the
        same recording later after storing it to disk.
    </li>
 </ul>
 */
- (void)startRecording:(UIView *)view withConfig:(NSDictionary *)config;


/*!
 @brief Capture a single frame

 @discussion Capture a single frame of the UIView to the buffer. The buffer size is 50 frames
 (default) and the oldest frames will be deleted if the method gets called more than 50 times.
 The total number of frames can be customized by setting the @c maxFrames property on the
 @c sharedMegacool instance. If you want a different strategy for handling too many frames, try
 <tt> captureFrame:(UIView *)view withConfig:\@{\@"overflowStrategy": \@"timelapse"}</tt>

 @param view UIView you want to capture a frame from
 */
- (void)captureFrame:(UIView *)view;


/*!
 @brief Capture a customized frame for a GIF

 @discussion Capture a single frame of the UIView to the buffer. The buffer size is 50 frames
 (default) and the oldest frames will be deleted if the method gets called more than 50 times.
 The total number of frames can be customized by setting the @c maxFrames property on the
 @c sharedMegacool instance.

 If the overflow strategy is timelapse, we recommend setting @c maxFrames to a value where
 @c floor(maxFrames*4/3) is even, this maximizes the number of frames at any point in time present
 in the timalpse.

 @param view UIView you want to capture a frame from.
 @param config NSDictonary to customize the recording. Accepted keys in the dictionary are:

 <ul>
    <li>
        <b>@c overflowStrategy </b>: How to handle frames when they the total surpasses
        @c maxFrames . The default is @c @@"latest" , which will only keep the most recent
        ones. The alternative is @c \@"timelapse", which will contain frames from the entire
        recording but sped up so that the total is not surpassed. Note that when using @c
        \@"timelapse" the total number of frames will be between 1.33* @c maxFrames and 0.67* @c
        maxFrames , such that the *expected* value will be @c maxFrames , but it might sometimes be
        more.
    </li>
    <li>
        <b>@c recordingId </b>: An identifier for this recording. Can be used to retrieve the
        same recording later after storing it to disk. Example:
        <tt> \@{\@"recordingId": \@"level2/5"} </tt>. See discussion in the
        <a href="https://docs.megacool.co/#5-recording-persistency">docs</a> for details.
    </li>
    <li>
        <b>@c crop </b>: Crops (surprise!) the recording to the given area. Example:
        <tt> \@{\@"crop":[NSValue valueWithCGRect:CGRectMake(0, 100, 300, 300)]} </tt>
    </li>
 </ul>
 */
- (void)captureFrame:(UIView *)view withConfig:(NSDictionary *)config;


/*!
 @brief Pauses the current recording for resumption later.

 @discussion The frames captured so far will be stored on disk and can be resumed later by calling
 @c startRecording / @c captureFrame with the same @c "recordingId".
*/
- (void)pauseRecording;


/*!
 @brief Stop recording the UIView set in startRecording.

 @discussion This method should be called after @c startRecording or @c captureFrame to
 mark the recording as completed. A completed recording can not have any more frames added to it,
 calling @c captureFrame or @c startRecording with the same @c recordingId as a completed recording
 will overwrite the old one.
 */
- (void)stopRecording;


/*!
 @brief Delete a recording.

 @discussion Will remove any frames of the recording in memory and on disk. Both completed and
 incomplete recordings will take space on disk, thus particularly if you're using @c
 keepCompletedRecordings=YES you might want to provide an interface to your users for removing
 recordings they don't care about anymore to free up space for new recordings.
 */
- (void)deleteRecording:(NSString *)recordingId;


/*!
 @brief Render preview of GIF that can be showed before sharing.

 @discussion Use the @c startAnimating / @c stopAnimating methods on the returned
 @c UIImageView to play/pause the GIF. If you use this method you need to position and scale
 the returned view before adding it to a parent view, using
 <tt> view.frame = CGRectMake(x, y, width, height); </tt> To avoid doing this in two steps you
 can apply the frame directly by calling <tt>
 renderPreviewOfGifWithConfig:@{kMCLConfigPreviewFrameKey:
 CGRectMake(x, y, width, height)} </tt>.

 @returns UIImageView with the same images as the GIF.
 */
- (UIImageView *)renderPreviewOfGif;


/*!
 @brief Render preview of GIF with a given frame size that can be showed before sharing.

 @discussion Use the @c startAnimating / @c stopAnimating methods on the returned
 @c UIImageView to play/pause the GIF.

 @deprecated This method is deprecated starting in version 1.2 and will be deleted in
 version 1.4, please use <tt> renderPreviewOfGifWithConfig:@{@"previewFrame":frame} </tt>
 instead.

 @returns UIImageView with the same images as the GIF
 */
- (UIImageView *)renderPreviewOfGifWithFrame:(CGRect)frame __deprecated;


/*!
 @brief Render preview of GIF with a given frame size that can be showed before sharing.

 @discussion Use the @c startAnimating / @c stopAnimating methods on the returned
 @c UIImageView to play/pause the GIF. The config parameter accepts the following keys:

 <ul>
     <li>
         <b>@c recordingId </b>: An identifier for this recording. Can be used to retrieve the
         same recording later after storing it to disk. Available through the constant
         @c kMCLConfigRecordingIdKey. Example:
         <tt> \@{\@"recordingId": \@"level2/5"} </tt>
     </li>
     <li>
         <b>@c previewFrame </b>: Customize the frame of the UIImageView. Available as the constant
         @c kMCLConfigPreviewFrameKey. Example:
         <tt> \@{\@"previewFrame":[NSValue valueWithCGRect:CGRectMake(0, 100, 300, 300)]} </tt>
     </li>
 </ul>

 @param config NSDictonary to customize the recording. Accepted keys are documented above.
 @returns UIImageView with the same images as the GIF
 */
- (UIImageView *)renderPreviewOfGifWithConfig:(NSDictionary *)config;


/*!
 @brief Open Share Modal View in a View Controller - For iPhone

 @discussion Shows a native share modal view with supported sharing channels like SMS, Twitter,
 Facebook etc.
 @note This method must be called from the main thread of your application.

 @param viewController View Controller that presents the share modal view
 */
- (void)openShareModalIn:(UIViewController *)viewController;


/*!
 @brief Open Share Modal View in a View Controller - For iPhone

 @discussion Shows a native share modal view with supported sharing channels like SMS, Twitter,
 Facebook etc.

 @param view View Controller that presents the share modal view
 @param config NSDictionary with config of the sharing. Supported keys in the dictionary:
 @note This method must be called from the main thread of your application.

 <ul>
    <li>
        <b>@c lastFrameOverlay</b>: Transparent UIImage that will be placed over the last frame.
        Example: <tt>\@{\@"lastFrameOverlay":[UIImage imageNamed:@"frame.png"]}</tt>
    </li>
    <li>
        <b> @c recordingId </b>: An identifier for this recording. Can be used to retrieve the
        same recording later after storing it to disk.
    </li>
    <li>
        <b> @c fallbackImageURL </b>: @c NSURL to an image to show in case there's been no frames
        recorded so far, or if something else fails in creation of the GIF.
    </li>
    <li>
        <b> @c fallbackImage </b>: Same as @c fallbackImageURL, but given as a @c UIImage instead
        of a @c NSURL.
    </li>
    <li>
        <b> @c share </b>: @c MCLShare object that will be sent to the receiver. Add a @c URL
        that will be parsed and added to the shared URL, which gives a great onboarding
        experience. In addition you might add a NSDictionary to @c share.data that will be fetched
        from the server on the receiving device.
        Example: <tt>
            <p>NSURL *URL = [NSURL URLWithString:@"battle?player=nbroby"];
            <p>NSDictionary *data = @{ @"welcomeText" : @"Nick has challenged you!" };</p>
            <p>MCLShare *share = [MCLShare shareWithURL:URL data:data];</p>
            <p>//config:<p/>
            <p>\@{kMCLConfigShareKey:share}</p>
            </tt>

        Final URL will be: https://mgcl.co/appname/battle?player=nbroby&_m=12345678
    </li>
 </ul>
 */
- (void)openShareModalIn:(UIViewController *)viewController withConfig:(NSDictionary *)config;


/*!
 @brief Disable a set of features

 @discussion If something fails or is not desired on a class of devices, some features can be
 disabled remotely through the dashboard. To be able to test behavior when this is the case, or to
 always force a given feature to be disabled, you can call this function with a list of the features
 you want to disable.

 Features disabled through this call will not be visible or configurable through the dashboard. A
 feature will be disabled if it's disabled either through this call or remotely or both. This call
 will overwrite any effects of previous calls, thus calling <tt>disableFeatures:kMCLFeatureGifs</tt>
 followed by <tt> disableFeatures:kMCLFeatureAnalytics</tt> would leave only analytics disabled.
 Combine features with the bitwise OR operator @c | to disable multiple features, like
 <tt>disableFeatures:kMCLFeatureAnalytics|kMCLFeatureGifUpload</tt>.

 The supported features you can disable is:
 * <b>GIFs</b>: Disable all recording, frame capturing and subsequent creation of the GIF. Available
 as the constant @c kMCLFeatureGifs.
 * <b>GIF uploading<b>: By default all GIFs created are uploaded to our servers, which is
 necessaryto be able to share GIFs to Facebook and Twitter, and for you to see them in the
 dashboard. This does have some networking overhead though, so if you're very constrained in terms
 of bandwidth you can disable this. Include the constant @c kMCLFeatureGifUpload.
 * <b>Analytics<b>: To be able to determine whether an install or an app open event came from a link
 we have to submit some events to our servers to be able to match the event to a link click detected
 by us, which involves submitting the users IDFA to us. If you are very concerned about your user's
 privacy or don't want to incur the extra networking required, you can disable this feature. Note
 that users will not be credited for inviting friends if this feature is off. Include the constant
 @c kMCLFeatureAnalytics.
 */
- (void)disableFeatures:(kMCLFeature)features;


/*!
 @brief Get the shares sent by the user.

 @discussion The locally cached shares will be returned immediately and are useful for determining
 how many shares have been sent and when that was done. If the callback is non-nil we will query
 the backend for an updated status on the shares to see if anything has happened since last time.

 Each element in the list returned will be a @c MCLShare (link to docs).
 */
- (NSArray<MCLShare *> *)getShares:(MCLShareStateCallback)callback;


/*!
 @brief Get the shares sent by the user, with filtering.

 @discussion Use this instead of @c -getShares: when you only want a subset of the shares, to keep
 network traffic to a minimum. The locally cached shares will be returned immediately and are useful
 for determining how many shares have been sent and when that was done. If the callback is non-nil
 we will query the backend for an updated status on the shares to see if anything has happened since
 last time.

 Each element in the list returned will be a @c MCLShare (link to docs).

 @param filter can be used to filter out the shares returned. An example is to only return those
 who haven't yet generated an install. The filter loops through all shares and you can decide
 for each share if it should be fetched or not by returning YES / NO.
 */
- (NSArray<MCLShare *> *)getShares:(MCLShareStateCallback)callback
                        withFilter:(MCLShareFilterCallback)filter;


/*!
 @brief Delete local share objects

 @discussion Local shares are also useful to show the users how many shares they've sent and what
 their statuses are. But at a certain time you might want to delete old ones.

 @param filter is used to delete old share objects you don't want local anymore. I.e. shares that
 have been installed and are over 2 days old can be deleted. For each share, return <tt>YES/NO</t t>
 if it
 should be deleted.
 */

- (void)deleteSharesMatchingFilterFromDevice:(MCLShareFilterCallback)filter;


/*!
 @brief Get the inviter id for this user/app.

 @discussion The inviter id will be passed to the callback immediately if known, otherwise the
 callback will be called when we've received the inviter id from the backend, which happens on the
 first session, and will be stored locally after that.
 */
- (void)getUserId:(MCLReferralCodeCallback)callback;


/*!
 @brief Set the text to be shared on different channels

 @remarks The text should be set before @c openShareModal is called.
 */
@property(nonatomic, strong) NSString *sharingText;


/*!
 @brief Set numbers of frames per second to record.

 @discussion Default is 10 frames / second. The GIF will be recorded with this frame rate.
 */
@property(nonatomic) float frameRate;


/*!
 @brief Set numbers of frames per second to play.

 @discussion Default is 10 frames / second. The GIF will be exported with this frame rate.
 */
@property(nonatomic) float playbackFrameRate;


/*!
 @brief Max number of frames in a recording.

 @discussion Default is 50 frames. What happens when a recording grows above the @c maxFrames limit
 is determined by the overflow strategy, see the documentation for @c captureFrame or @c
 startRecording for details.
 */
@property(nonatomic) int maxFrames;


/*!
 @brief Set a delay (in seconds) on the last frame in the animation.

 @discussion Default is 1 second
 */
@property(nonatomic) int lastFrameDelay;


/*!
 @brief Assign the delegate for callbacks
 */
@property(nonatomic, weak) id<MCLDelegate> delegate;


/*!
 @brief Turn on / off debug mode. In debug mode calls to the SDK are stored and can be submitted to
 the core developers using @c submitDebugDataWithMessage later.
 */
+ (void)setDebug:(BOOL)debug;


/*!
 @brief Get whether debugging is currently enabled or not.
 */
+ (BOOL)debug;


/*!
 @brief Whether to keep completed recordings around.

 @discussion The default is @c NO, which means that all completed recordings will be deleted
 whenever a new recording is started with either @c captureFrame or @c startRecording. Setting this
 to @c YES means we will never delete a completed recording, which is what you want if you want to
 enable players to browse previous GIFs they've created. A completed recording will still be
 overwritten if a new recording is started with the same @c recordingId.
 */
@property(nonatomic) BOOL keepCompletedRecordings;


/*!
 @brief Handle background upload/download tasks

 @discussion This is necessary to properly handle uploading of gifs in the background, and to
 download new fallback images defined through the dashboard.
 */
- (void)handleEventsForBackgroundURLSession:(NSString *)identifier
                          completionHandler:(void (^)())completionHandler;


/*!
 @brief Submit debug data to the core developers along with a message explaining the expected
 outcome and what was observed instead.

 @discussion Remember to set <tt>Megacool.debug = YES;</tt> on startup if you intend to use this
 call, otherwise the report will not contain call traces and it'll be harder to reproduce your
 issue.
 */
- (void)submitDebugDataWithMessage:(NSString *)message;


/*!
 @brief Resets the device identity, enabling it to receive events with @c isFirstSession=YES again.

 @discussion Use this if you're testing the invite flow and you want to wipe previous data from the
 device. This will issue your device a new identity, which means it can receive @c
 recievedShareOpened events again with @c isFirstSession set to @c YES, and enabling you to click
 previous links sent by the same device, mitigating the need for multiple devices to test invites.

 This method should be called before @c -startWithAppConfig:, otherwise the changes will not have
 any effect until the next session.
 */
+ (void)resetIdentity;


@end
