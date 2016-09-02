//
//  MCLShare.h
//
//  An online version of the documentation can be found at https://docs.megacool.co
//
//  Do you feel like this reading docs? (╯°□°）╯︵ ┻━┻  Give us a shout if there's anything that's
//  unclear and we'll try to brighten the experience. We can sadly not replace flipped tables.
//

#import <Foundation/Foundation.h>
#import "MCLReferralCode.h"

typedef NS_ENUM(NSInteger, MCLShareState) {
    MCLShareStateSent = 0,
    MCLShareStateClicked,
    MCLShareStateOpened,
    MCLShareStateInstalled,
};

/*!
 @brief MCLShare holds information about a share, like which state it has (MCLShareStateSent,
 MCLShareStateClicked, MCLShareStateOpened or MCLShareStateInstalled), the URL and custom data.
 */
@interface MCLShare : NSObject

/*!
 @brief Instantiate a new share object with url
 */
+ (instancetype)shareWithURL:(NSURL *)URL;


/*!
 @brief Instantiate a new share object with url and data
 */
+ (instancetype)shareWithURL:(NSURL *)URL data:(NSDictionary *)data;


/*!
 @brief Unique referral code for each share which is part of the link.

 @discussion The referral code is assigned when the share is shared, thus not available when you've
 instantiated the share yourself.
 */
@property(readonly) MCLReferralCode *referralCode;


/*!
 @brief State of the share: MCLShareStateSent, MCLShareStateClicked, MCLShareStateOpened or
 MCLShareStateInstalled
 */
@property(readonly) MCLShareState state;


/*!
 @brief Timestamp of when the share was created
 */
@property(readonly) NSDate *createdAt;


/*!
 @brief Timestamp of the last update to the share
 */
@property(readonly) NSDate *updatedAt;


/*!
 @brief Data associated with the share object
 */
@property(readonly) NSDictionary *data;


/*!
 @brief URL that is associated with the share object.

 @discussion This is the URL you should use to navigate within the app, but the shared url will have
 https://mgcl.co/<yourIdentifier> prepended and <tt>_m=<referralCode></tt> appended to it. If not
 given defaults to <tt>@"/"</tt>. The URL will be normalized by adding leading slash to the path if
 absent, and stripping any trailing slash.
 */
@property(nonatomic, readonly) NSURL *URL;

@end
