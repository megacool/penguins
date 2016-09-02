//
//  PPEmitters.h
//  PajamaPenguins
//
//  Created by Skye on 3/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SFAudio.h"
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface PPSharedAssets : NSObject

// Preloading
typedef void (^AssetCompletionHandler)(void);
+ (void)loadSharedAssetsWithCompletion:(AssetCompletionHandler)completion;

// Clouds
+ (SKTextureAtlas *)sharedCloudAtlas;

// Iceberg Textures
+ (SKTextureAtlas *)sharedIcebergAtlas;
+ (SKTexture *)sharedIcebergMenuTexture;
+ (SKTexture *)sharedIcebergGameTexture;

// Coin Textures
+ (NSArray *)sharedCoinTextures;
+ (SKTextureAtlas *)sharedCoinAtlas;

// Button Textures
+ (SKTextureAtlas *)sharedButtonAtlas;
+ (SKTexture *)sharedButtonPause;
+ (SKTexture *)sharedButtonHome;
+ (SKTexture *)sharedButtonPlay;
+ (SKTexture *)sharedButtonInvite;
+ (SKTexture *)sharedButtonReset;

// Penguins Textures
+ (SKTextureAtlas *)sharedPenguinBlackTextures;

// Fish Textures
+ (SKTextureAtlas *)sharedFishAtlas;
+ (SKTexture *)sharedFishTexture;
+ (SKTexture *)sharedFishBlueTexture;
+ (SKTexture *)sharedFishGreenTexture;
+ (SKTexture *)sharedFishMaroonTexture;
+ (SKTexture *)sharedFishRedTexture;

// Emitters
+ (SKEmitterNode *)sharedSnowEmitter;
+ (SKEmitterNode *)sharedBubbleEmitter;
+ (SKEmitterNode *)sharedPlayerSplashDownEmitter;
+ (SKEmitterNode *)sharedPlayerSplashUpEmitter;
+ (SKEmitterNode *)sharedStarEmitter;
+ (SKEmitterNode *)sharedStarExplosionEmitter;

// Audio
+ (SFAudio *)sharedSplashSFX;
+ (SKAction *)sharedCoinSFX;
+ (SKAction *)sharedFishSFX;
+ (SKAction *)sharedPowerupSFX;

@end
