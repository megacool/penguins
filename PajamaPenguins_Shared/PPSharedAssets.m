// 
//   PPEmitters.m
//   PajamaPenguins
// 
//   Created by Skye on 3/7/15.
//   Copyright (c) 2015 Skye Freeman. All rights reserved.
// 

#import "PPSharedAssets.h"
#import "SSKGraphicsUtils.h"
#import "SKColor+SFAdditions.h"
#import "SKTexture+SFAdditions.h"

@implementation PPSharedAssets
+ (void)loadSharedAssetsWithCompletion:(AssetCompletionHandler)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDate *startTime = [NSDate date];
        
        // Menu Iceberg
        sIcebergTexture = [SKTexture textureWithImageNamed:@"platform_iceberg"];
        
        // Buttons
        sButtonAtlas = [SKTextureAtlas atlasNamed:@"buttons"];
        sButtonHome = [sButtonAtlas textureNamed:@"button_home"];
        sButtonPlay = [sButtonAtlas textureNamed:@"button_play"];
        
        // Coins
        sCoinsAtlas = [SKTextureAtlas atlasNamed:@"coins"];
        sCoinTextures = [SSKGraphicsUtils loadFramesFromAtlas:sCoinsAtlas baseFileName:@"coin_" frameCount:6];
        
        // Clouds
        sCloudAtlas = [SKTextureAtlas atlasNamed:@"clouds"];
        
        // Penguins
        sPenguinBlackTextures = [SKTextureAtlas atlasNamed:@"penguin_black"];
        
        // Fish
        sFishAtlas = [SKTextureAtlas atlasNamed:@"fish"];
        sFishTexture = [sFishAtlas textureNamed:@"fish"];
        
        // Icebergs
        sIcebergAtlas = [SKTextureAtlas atlasNamed:@"icebergs"];
        
        // Emitters
        sSnowEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"SnowEmitter"];
        sBubbleEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"BubbleEmitter"];
        sPlayerSplashDownEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"PlayerSplashDownEmitter"];
        sPlayerSplashUpEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"PlayerSplashUpEmitter"];

        NSLog(@"Scene loaded in %f seconds",[[NSDate date] timeIntervalSinceDate:startTime]);
        
        if (!completion) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();  // Calls the handler on the main thread once assets are ready.
        });
    });
}

#pragma mark - Shared Textures

// Background Elements
static SKTexture *sIcebergTexture = nil;
+ (SKTexture*)sharedIcebergTexture {
    return sIcebergTexture;
}

// Clouds
static SKTextureAtlas *sCloudAtlas = nil;
+ (SKTextureAtlas*)sharedCloudAtlas {
    return sCloudAtlas;
}

// Buttons
static SKTextureAtlas *sButtonAtlas = nil;
+ (SKTextureAtlas*)sharedButtonAtlas {
    return sButtonAtlas;
}

static SKTexture *sButtonHome = nil;
+ (SKTexture*)sharedButtonHome {
    return sButtonHome;
}

static SKTexture *sButtonPlay = nil;
+ (SKTexture*)sharedButtonPlay {
    return sButtonPlay;
}

// Fish
static SKTextureAtlas *sFishAtlas = nil;
+ (SKTextureAtlas*)sharedFishAtlas {
    return sFishAtlas;
}

static SKTexture *sFishTexture = nil;
+ (SKTexture*)sharedFishTexture {
    return sFishTexture;
}

// Penguins
static SKTextureAtlas *sPenguinBlackTextures = nil;
+ (SKTextureAtlas*)sharedPenguinBlackTextures {
    return sPenguinBlackTextures;
}

// Coins
static SKTextureAtlas *sCoinsAtlas = nil;
+ (SKTextureAtlas*)sharedCoinAtlas {
    return sCoinsAtlas;
}

static NSArray *sCoinTextures = nil;
+ (NSArray*)sharedCoinTextures {
    return sCoinTextures;
}

// Icebergs
static SKTextureAtlas *sIcebergAtlas = nil;
+ (SKTextureAtlas*)sharedIcebergAtlas {
    return sIcebergAtlas;
}

// Water
static SKTexture *sWaterTexture = nil;
+ (SKTexture*)sharedWaterTexture {
    return sWaterTexture;
}

// Skies
static SKTexture *sSkyMorning = nil;
+ (SKTexture*)sharedSkyMorning {
    return sSkyMorning;
}

static SKTexture *sSkyDay = nil;
+ (SKTexture*)sharedSkyDay {
    return sSkyDay;
}

static SKTexture *sSkyAfternoon = nil;
+ (SKTexture*)sharedSkyAfternoon {
    return sSkyAfternoon;
}

static SKTexture *sSkySunset = nil;
+ (SKTexture*)sharedSkySunset {
    return sSkySunset;
}

static SKTexture *sSkyNight = nil;
+ (SKTexture*)sharedSkyNight {
    return sSkyNight;
}

#pragma mark - Shared Emitters
static SKEmitterNode *sSnowEmitter = nil;
+ (SKEmitterNode*)sharedSnowEmitter {
    return sSnowEmitter;
}

static SKEmitterNode *sBubbleEmitter = nil;
+ (SKEmitterNode*)sharedBubbleEmitter {
    return sBubbleEmitter;
}

static SKEmitterNode *sPlayerSplashDownEmitter = nil;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter {
    return sPlayerSplashDownEmitter;
}

static SKEmitterNode *sPlayerSplashUpEmitter = nil;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter {
    return sPlayerSplashUpEmitter;
}

@end
