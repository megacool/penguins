//
//   PPEmitters.m
//   PajamaPenguins
//
//   Created by Skye on 3/7/15.
//   Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSharedAssets.h"
#import "SKColor+SFAdditions.h"
#import "SKTexture+SFAdditions.h"
#import "SSKGraphicsUtils.h"

@implementation PPSharedAssets
+ (void)loadSharedAssetsWithCompletion:(AssetCompletionHandler)completion {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSDate *startTime = [NSDate date];

    // Buttons
    sButtonAtlas = [SKTextureAtlas atlasNamed:@"buttons"];
    sButtonHome = [sButtonAtlas textureNamed:@"button_home"];
    sButtonMessenger = [sButtonAtlas textureNamed:@"button_messenger"];
    sButtonMail = [sButtonAtlas textureNamed:@"button_mail"];
    sButtonMessages = [sButtonAtlas textureNamed:@"button_messages"];
    sButtonTwitter = [sButtonAtlas textureNamed:@"button_twitter"];
    sButtonPlay = [sButtonAtlas textureNamed:@"button_play"];
    sButtonPause = [sButtonAtlas textureNamed:@"button_pause"];
    sButtonInvite = [sButtonAtlas textureNamed:@"button_invite"];
    sButtonReset = [sButtonAtlas textureNamed:@"button_reset"];

    // Coins
    sCoinsAtlas = [SKTextureAtlas atlasNamed:@"coins"];
    sCoinTextures = [SSKGraphicsUtils loadFramesFromAtlas:sCoinsAtlas
                                             baseFileName:@"coin_"
                                               frameCount:6];

    // Clouds
    sCloudAtlas = [SKTextureAtlas atlasNamed:@"clouds"];

    // Penguins
    sPenguinBlackTextures = [SKTextureAtlas atlasNamed:@"penguin_black"];

    // Fish
    sFishAtlas = [SKTextureAtlas atlasNamed:@"fish"];
    sFishTexture = [sFishAtlas textureNamed:@"fish"];
    sFishBlueTexture = [sFishAtlas textureNamed:@"fish_blue"];
    sFishGreenTexture = [sFishAtlas textureNamed:@"fish_green"];
    sFishMaroonTexture = [sFishAtlas textureNamed:@"fish_maroon"];
    sFishRedTexture = [sFishAtlas textureNamed:@"fish_red"];

    // Icebergs
    sIcebergAtlas = [SKTextureAtlas atlasNamed:@"icebergs"];
    sIcebergGameTexture = [sIcebergAtlas textureNamed:@"iceberg_normal"];
    sIcebergMenuTexture = [sIcebergAtlas textureNamed:@"iceberg_menu"];

    // Emitters
    sSnowEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"SnowEmitter"];
    sBubbleEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"BubbleEmitter"];
    sPlayerSplashDownEmitter =
        [SKEmitterNode emitterNodeWithFileNamed:@"PlayerSplashDownEmitter"];
    sPlayerSplashUpEmitter =
        [SKEmitterNode emitterNodeWithFileNamed:@"PlayerSplashUpEmitter"];
    sStarExplosionEmitter =
        [SKEmitterNode emitterNodeWithFileNamed:@"StarExplosion"];

    // Cant change emitter color if created with an sks file
    //        sStarEmitter = [SKEmitterNode
    //        emitterNodeWithFileNamed:@"starEmitter"];

    sStarEmitter = [[SKEmitterNode alloc] init];
    [sStarEmitter
        setParticleTexture:[SKTexture textureWithImageNamed:@"starParticle"]];
    [sStarEmitter setParticleColor:[UIColor colorWithRed:1.000
                                                   green:0.904
                                                    blue:0.000
                                                   alpha:1.000]];
    [sStarEmitter setParticleBirthRate:50];
    [sStarEmitter setParticleLifetime:2];
    [sStarEmitter setParticlePositionRange:CGVectorMake(0, 10)];
    [sStarEmitter setEmissionAngle:SSKDegreesToRadians(180)];
    [sStarEmitter setParticleSpeed:300];
    [sStarEmitter setParticleAlpha:1];
    [sStarEmitter setParticleAlphaRange:0.2];
    [sStarEmitter setParticleScale:0.15];
    [sStarEmitter setParticleScaleRange:0.05];
    [sStarEmitter setParticleScaleSpeed:-0.05];
    [sStarEmitter setParticleRotationSpeed:150];
    [sStarEmitter setParticleColorBlendFactor:1.0];

    // Audio
    sCoinSFX =
        [SKAction playSoundFileNamed:@"coin_sfx.wav" waitForCompletion:NO];
    sFishSFX =
        [SKAction playSoundFileNamed:@"fish_sfx.wav" waitForCompletion:NO];
    sPowerupSFX =
        [SKAction playSoundFileNamed:@"powerup_sfx.wav" waitForCompletion:NO];
    //        sSplashSFX = [[SFAudio alloc] initWithFileNamed:@"splash.m4a"];

    NSLog(@"Scene loaded in %f seconds",
          [[NSDate date] timeIntervalSinceDate:startTime]);

    if (!completion) {
      return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      completion(); // Calls the handler on the main thread once assets are
                    // ready.
    });
  });
}

#pragma mark - Shared Textures

// Clouds
static SKTextureAtlas *sCloudAtlas = nil;
+ (SKTextureAtlas *)sharedCloudAtlas {
  return sCloudAtlas;
}

// Buttons
static SKTextureAtlas *sButtonAtlas = nil;
+ (SKTextureAtlas *)sharedButtonAtlas {
  return sButtonAtlas;
}

static SKTexture *sButtonPause = nil;
+ (SKTexture *)sharedButtonPause {
  return sButtonPause;
}

static SKTexture *sButtonHome = nil;
+ (SKTexture *)sharedButtonHome {
  return sButtonHome;
}

static SKTexture *sButtonMessenger = nil;
+ (SKTexture *)sharedButtonMessenger {
  return sButtonMessenger;
}

static SKTexture *sButtonMail = nil;
+ (SKTexture *)sharedButtonMail {
  return sButtonMail;
}

static SKTexture *sButtonMessages = nil;
+ (SKTexture *)sharedButtonMessages {
  return sButtonMessages;
}

static SKTexture *sButtonTwitter = nil;
+ (SKTexture *)sharedButtonTwitter {
  return sButtonTwitter;
}

static SKTexture *sButtonPlay = nil;
+ (SKTexture *)sharedButtonPlay {
  return sButtonPlay;
}

static SKTexture *sButtonInvite = nil;
+ (SKTexture *)sharedButtonInvite {
  return sButtonInvite;
}

static SKTexture *sButtonReset = nil;
+ (SKTexture *)sharedButtonReset {
  return sButtonReset;
}

// Fish
static SKTextureAtlas *sFishAtlas = nil;
+ (SKTextureAtlas *)sharedFishAtlas {
  return sFishAtlas;
}

static SKTexture *sFishTexture = nil;
+ (SKTexture *)sharedFishTexture {
  return sFishTexture;
}

static SKTexture *sFishBlueTexture = nil;
+ (SKTexture *)sharedFishBlueTexture {
  return sFishBlueTexture;
}

static SKTexture *sFishGreenTexture = nil;
+ (SKTexture *)sharedFishGreenTexture {
  return sFishGreenTexture;
}

static SKTexture *sFishMaroonTexture = nil;
+ (SKTexture *)sharedFishMaroonTexture {
  return sFishMaroonTexture;
}

static SKTexture *sFishRedTexture = nil;
+ (SKTexture *)sharedFishRedTexture {
  return sFishRedTexture;
}

// Penguins
static SKTextureAtlas *sPenguinBlackTextures = nil;
+ (SKTextureAtlas *)sharedPenguinBlackTextures {
  return sPenguinBlackTextures;
}

// Coins
static SKTextureAtlas *sCoinsAtlas = nil;
+ (SKTextureAtlas *)sharedCoinAtlas {
  return sCoinsAtlas;
}

static NSArray *sCoinTextures = nil;
+ (NSArray *)sharedCoinTextures {
  return sCoinTextures;
}

// Icebergs
static SKTextureAtlas *sIcebergAtlas = nil;
+ (SKTextureAtlas *)sharedIcebergAtlas {
  return sIcebergAtlas;
}

static SKTexture *sIcebergMenuTexture = nil;
+ (SKTexture *)sharedIcebergMenuTexture {
  return sIcebergMenuTexture;
}

static SKTexture *sIcebergGameTexture = nil;
+ (SKTexture *)sharedIcebergGameTexture {
  return sIcebergGameTexture;
}

#pragma mark - Audio
static SFAudio *sSplashSFX = nil;
+ (SFAudio *)sharedSplashSFX {
  return sSplashSFX;
}

static SKAction *sCoinSFX = nil;
+ (SKAction *)sharedCoinSFX {
  return sCoinSFX;
}

static SKAction *sFishSFX = nil;
+ (SKAction *)sharedFishSFX {
  return sFishSFX;
}

static SKAction *sPowerupSFX = nil;
+ (SKAction *)sharedPowerupSFX {
  return sPowerupSFX;
}

#pragma mark - Shared Emitters
static SKEmitterNode *sSnowEmitter = nil;
+ (SKEmitterNode *)sharedSnowEmitter {
  return sSnowEmitter;
}

static SKEmitterNode *sBubbleEmitter = nil;
+ (SKEmitterNode *)sharedBubbleEmitter {
  return sBubbleEmitter;
}

static SKEmitterNode *sPlayerSplashDownEmitter = nil;
+ (SKEmitterNode *)sharedPlayerSplashDownEmitter {
  return sPlayerSplashDownEmitter;
}

static SKEmitterNode *sPlayerSplashUpEmitter = nil;
+ (SKEmitterNode *)sharedPlayerSplashUpEmitter {
  return sPlayerSplashUpEmitter;
}

static SKEmitterNode *sStarEmitter = nil;
+ (SKEmitterNode *)sharedStarEmitter {
  return sStarEmitter;
}

static SKEmitterNode *sStarExplosionEmitter = nil;
+ (SKEmitterNode *)sharedStarExplosionEmitter {
  return sStarExplosionEmitter;
}

@end
