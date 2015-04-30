//
//  PPEmitters.h
//  PajamaPenguins
//
//  Created by Skye on 3/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface PPSharedAssets : NSObject

// Preloading
typedef void (^AssetCompletionHandler)(void);
+ (void)loadSharedAssetsWithCompletion:(AssetCompletionHandler)completion;

// Sky Textures
+ (SKTexture*)sharedSkyMorning;
+ (SKTexture*)sharedSkyDay;
+ (SKTexture*)sharedSkyAfternoon;
+ (SKTexture*)sharedSkySunset;
+ (SKTexture*)sharedSkyNight;

// Water Texture
+ (SKTexture*)sharedWaterTexture;
    
// Clouds
+ (SKTextureAtlas*)sharedCloudAtlas;

// Iceberg Textures
+ (SKTextureAtlas*)sharedIcebergAtlas;
+ (SKTexture*)sharedIcebergTexture; // Menu Iceberg

// Coin Textures
+ (SKTextureAtlas*)sharedCoinAtlas;

// Button Textures
+ (SKTextureAtlas*)sharedButtonAtlas;

// Penguins Textures
+ (SKTextureAtlas*)sharedPenguinBlackTextures;

// Fish Textures
+ (SKTextureAtlas*)sharedFishAtlas;

// Emitters
+ (SKEmitterNode*)sharedSnowEmitter;
+ (SKEmitterNode*)sharedBubbleEmitter;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter;
+ (SKEmitterNode*)sharedObstacleSplashEmitter;

@end
