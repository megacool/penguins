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

// Background Textures
+ (SKTexture*)sharedIcebergTexture;

// Clouds
+ (SKTextureAtlas*)sharedCloudAtlas;

// Iceberg Textures
+ (SKTextureAtlas*)sharedIcebergAtlas;

// Button Textures
+ (SKTextureAtlas*)sharedButtonAtlas;

// Penguins Textures
+ (SKTextureAtlas*)sharedPenguinBlackTextures;

// Emitters
+ (SKEmitterNode*)sharedSnowEmitter;
+ (SKEmitterNode*)sharedBubbleEmitter;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter;
+ (SKEmitterNode*)sharedObstacleSplashEmitter;

@end
