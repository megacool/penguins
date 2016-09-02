//
//  MCLEvent.h
//
//  An online version of the documentation can be found at https://docs.megacool.co
//
//  Do you feel like this reading docs? (╯°□°）╯︵ ┻━┻  Give us a shout if there's anything that's
//  unclear and we'll try to brighten the experience. We can sadly not replace flipped tables.
//

#import <Foundation/Foundation.h>
#import "MCLShare.h"

/*!
 @brief MCLEvent types which is used in <tt>startWithAppConfig:andEventHandler</tt>
 */
typedef NS_ENUM(NSInteger, MCLEventType) {
    /*!
     @brief Emitted when we've opened a share sent by someone else.

     @discussion The sending user's id can be found in the @c data dictionary under the key @c
     MCLEventDataSenderUserId.
     */
    MCLEventReceivedShareOpened = 0,


    /*!
     @brief Emitted when a share sent by this user is opened by someone else.

     @discussion The other person's @c userId can be found in the @c data dictionary under the @c
     MCLEventDataReceiverUserId key.
     */
    MCLEventSentShareOpened,


    /*!
     @brief Emitted when a link click was detected locally.

     @discussion This will usually happen very quickly after the app was loaded, and can be used to
     navigate to a specific section of your app. Look up the URL to navigate to from the property @c
     MCLEventDataURL in the @c data dictionary. This event will not be emitted for deferred link
     clicks (detections that has to go through the backend), for those only the @c
     MCLEventReceivedShareOpened event will be emitted.

     @c isFirstSession can be used to detect if this is the first session by this user. This will be
     persisted across re-installs in the Keychain, thus re-installing the app and clicking a link
     will not emit any new events with `isFirstSession` set.
     */
    MCLEventLinkClicked,
};

/*!
 @brief MCLEvent.data keys
 */
typedef NSString MCLEventDataKey;
extern MCLEventDataKey *const MCLEventDataURL;
extern MCLEventDataKey *const MCLEventDataReferralCode;
extern MCLEventDataKey *const MCLEventDataReceiverUserId;
extern MCLEventDataKey *const MCLEventDataSenderUserId;


/*!
 @brief @c MCLEvents are passed in the callback of <tt>startWithAppConfig:andEventHandler</tt>
 and is triggered soon after the app opens. There are three types of events which is defined in
 @c MCLEventType.
 */
@interface MCLEvent : NSObject

/*!
 @brief A megacool share object associated with the event.

 @discussion This will not be set on events with type @c MCLEventLinkClicked, since they happen
 locally. After the link clicked event is sent, a request will be sent to the backend to fetch
 the share object, which will then be attached to a @c MCLEventReceivedShareOpened event.

 Might be @c nil if a share could not be found for the event, which can happen if a user removes the
 last characters of the referral code before clicking or similar.
 */
@property(readonly) MCLShare *share;


/*!
 @brief When the event occured.
 */
@property(readonly) NSDate *createdAt;


/*!
 @brief type of event
 */
@property(readonly) MCLEventType type;


/*!
 @brief Whether the event happened for the first time on the event's originating device.
 */
@property(readonly) BOOL isFirstSession;


/*!
 @brief Data associated to the event.

 @discussion Which values is present will vary with the type of event, but will be available under
 the keys @c MCLEventDataURL, @c MCLEventDataReferralCode or @c MCLEventDataReceiverReferralCode.
 */
@property(readonly) NSDictionary *data;


@end
