//
//  MCLConstants.h
//
//  An online version of the documentation can be found at https://docs.megacool.co
//
//  Do you feel like this reading docs? (╯°□°）╯︵ ┻━┻  Give us a shout if there's anything that's
//  unclear and we'll try to brighten the experience. We can sadly not replace flipped tables.
//

#import <Foundation/Foundation.h>

// config keys
extern NSString *const kMCLConfigOverflowKey;
extern NSString *const kMCLConfigForceAddKey;
extern NSString *const kMCLConfigRecordingIdKey;
extern NSString *const kMCLConfigLastFrameOverlayKey;
extern NSString *const kMCLConfigFallbackImageURLKey;
extern NSString *const kMCLConfigFallbackImageKey;
extern NSString *const kMCLConfigSourceViewKey;
extern NSString *const kMCLConfigCropKey;
extern NSString *const kMCLConfigPreviewFrameKey;
extern NSString *const kMCLConfigMaxFramesKey;
extern NSString *const kMCLConfigShareKey;
extern NSString *const kMCLConfigFrameRateKey;

// config values
extern NSString *const kMCLConfigOverflowTimelapseValue;
extern NSString *const kMCLConfigOverflowLatestValue;

// Features that can be disabled
// NB: The values declared here have to corresepond to what is defined by the API
typedef NS_OPTIONS(unsigned long, kMCLFeature) {
    // clang-format off
    kMCLFeatureNone           = 0,
    kMCLFeatureGifs           = 1 << 0,
    kMCLFeatureAnalytics      = 1 << 1,
    kMCLFeatureGifUpload      = 1 << 2,
    kMCLFeatureGifPersistency = 1 << 3,
    // clang-format on
};
