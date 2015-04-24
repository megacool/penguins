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
        
        // Device Size
        CGSize screenRect = [[UIScreen mainScreen] bounds].size;
        
        // Sky gradients
        CGSize skySize = CGSizeMake(screenRect.width * 2, screenRect.height * 2);
        
        sSkyMorning = [SKTexture textureWithGradientOfSize:skySize
                                                startColor:[SKColor colorWithR:255 g:190 b:120]
                                                  endColor:[SKColor colorWithR:69 g:149 b:255]
                                                 direction:GradientDirectionVertical];
        sSkyDay = [SKTexture textureWithGradientOfSize:skySize
                                            startColor:[SKColor colorWithR:150 g:255 b:250]
                                              endColor:[SKColor colorWithR:0 g:142 b:242]
                                             direction:GradientDirectionVertical];
        
        sSkyAfternoon = [SKTexture textureWithGradientOfSize:skySize
                                                  startColor:[SKColor colorWithR:172 g:163 b:255]
                                                    endColor:[SKColor colorWithR:0 g:100 b:225]
                                                   direction:GradientDirectionVertical];
        
        sSkySunset = [SKTexture textureWithGradientOfSize:skySize
                                               startColor:[SKColor colorWithR:255 g:111 b:108]
                                                 endColor:[SKColor colorWithR:31 g:25 b:152]
                                                direction:GradientDirectionVertical];
        
        sSkyNight = [SKTexture textureWithGradientOfSize:skySize
                                              startColor:[SKColor colorWithR:0 g:43 b:137]
                                                endColor:[SKColor colorWithR:0 g:10 b:32]
                                               direction:GradientDirectionVertical];
        // Water gradient
        CGSize waterSize = CGSizeMake(screenRect.width * 2, screenRect.height/2);
        sWaterTexture = [SKTexture textureWithGradientOfSize:waterSize
                                                  startColor:[SKColor colorWithR:0 g:0 b:255]
                                                    endColor:[SKColor colorWithR:0 g:200 b:255]
                                                   direction:GradientDirectionVertical];
        
        // Menu Iceberg
        sIcebergTexture = [SKTexture textureWithImageNamed:@"platform_iceberg"];
        
        // Buttons
        sButtonAtlas = [SKTextureAtlas atlasNamed:@"buttons"];
        
        // Clouds
        sCloudAtlas = [SKTextureAtlas atlasNamed:@"clouds"];
        
        // Penguins
        sPenguinBlackTextures = [SKTextureAtlas atlasNamed:@"penguin_black"];
        
        // Icebergs
        sIcebergAtlas = [SKTextureAtlas atlasNamed:@"icebergs"];
        
        
        // Emitters
        sSnowEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"SnowEmitter"];
        sBubbleEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"BubbleEmitter"];
        sObstacleSplashEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"ObstacleSplashEmitter"];
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

// Penguins
static SKTextureAtlas *sPenguinBlackTextures = nil;
+ (SKTextureAtlas*)sharedPenguinBlackTextures {
    return sPenguinBlackTextures;
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

static SKEmitterNode *sObstacleSplashEmitter = nil;
+ (SKEmitterNode*)sharedObstacleSplashEmitter {
    return sObstacleSplashEmitter;
}

@end
