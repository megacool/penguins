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

// Clouds
+ (SKTextureAtlas*)sharedCloudAtlas;

// Iceberg Textures
+ (SKTextureAtlas*)sharedIcebergAtlas;
+ (SKTexture*)sharedIcebergMenuTexture;
+ (SKTexture*)sharedIcebergGameTexture;

// Coin Textures
+ (NSArray*)sharedCoinTextures;
+ (SKTextureAtlas*)sharedCoinAtlas;

// Button Textures
+ (SKTextureAtlas*)sharedButtonAtlas;
+ (SKTexture*)sharedButtonHome;
+ (SKTexture*)sharedButtonPlay;

// Penguins Textures
+ (SKTextureAtlas*)sharedPenguinBlackTextures;

// Fish Textures
+ (SKTextureAtlas*)sharedFishAtlas;
+ (SKTexture*)sharedFishTexture;

// Emitters
+ (SKEmitterNode*)sharedSnowEmitter;
+ (SKEmitterNode*)sharedBubbleEmitter;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter;

@end
