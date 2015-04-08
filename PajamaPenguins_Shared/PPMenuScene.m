//
//  PPMenuScene.m
//  PajamaPenguins
//
//  Created by Skye on 3/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPMenuScene.h"
#import "PPGameScene.h"
#import "PPSharedAssets.h"
#import "PPPlayer.h"
#import "PPSkySprite.h"
#import "PPWaterSprite.h"

#import "SSKUtils.h"

#import "SKColor+SFAdditions.h"
#import "SKTexture+SFAdditions.h"
#import "UIDevice+SFAdditions.h"

#import "SSKParallaxNode.h"
#import "SSKButtonNode.h"
#import "SSKGraphicsUtils.h"
#import "SSKDynamicColorNode.h"

typedef NS_ENUM(NSUInteger, SceneLayer) {
    SceneLayerBackground = 0,
    SceneLayerClouds,
    SceneLayerForeground,
    SceneLayerMenu,
};

CGFloat const kSplashStrength  = -2.5;
CGFloat const kPlatformPadding = 50.0;

@interface PPMenuScene()
@property (nonatomic) SKNode *backgroundNode;
@property (nonatomic) SKNode *foregroundNode;
@property (nonatomic) SKNode *menuNode;

@property (nonatomic) PPSkySprite *skySprite;
@property (nonatomic) PPWaterSprite *waterSurface;

@property (nonatomic) SSKParallaxNode *cloudFast;
@property (nonatomic) SSKParallaxNode *cloudSlow;
@end

@implementation PPMenuScene

- (instancetype)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    [self createSceneBackground];
    [self createSceneForeground];
    [self createMenu];
 
    [self startAnimations];
    
    [self testStuff];
}

- (void)testStuff {
//    SKAction *wait      = [SKAction waitForDuration:5];
//    SKAction *morning   = [self changeToSkyWithType:SkyTypeMorning];
//    SKAction *day       = [self changeToSkyWithType:SkyTypeDay];
//    SKAction *afternoon = [self changeToSkyWithType:SkyTypeAfternoon];
//    SKAction *sunset    = [self changeToSkyWithType:SkyTypeSunset];
//    SKAction *night     = [self changeToSkyWithType:SkyTypeNight];
//
//    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait,day,wait,afternoon,wait,sunset,wait,night,wait,morning]]]];
}

- (SKAction*)changeToSkyWithType:(SkyType)skyType {
    return [SKAction runBlock:^{
        [self.skySprite setSkyType:skyType];
    }];
}

#pragma mark - Scene Construction
- (void)createSceneBackground {
    self.backgroundColor = [SKColor whiteColor];
    
    self.backgroundNode = [SKNode node];
    [self.backgroundNode setZPosition:SceneLayerBackground];
    [self.backgroundNode setName:@"menuBackground"];
    [self addChild:self.backgroundNode];

    //Sky
    self.skySprite = [PPSkySprite spriteWithSize:CGSizeMake(self.size.width, self.size.height/4 * 3) skyType:SkyTypeMorning];
    [self.skySprite setPosition:CGPointMake(0, -self.size.height/4)];
    [self.backgroundNode addChild:self.skySprite];

    //Clouds
    self.cloudFast = [self cloudParallaxLayerFast];
    [self.backgroundNode addChild:self.cloudFast];
    
    self.cloudSlow = [self cloudParallaxLayerSlow];
    [self.backgroundNode addChild:self.cloudSlow];
    
    //Snow
    [self.backgroundNode addChild:[self newSnowEmitter]];
}

- (void)createSceneForeground {
    self.foregroundNode = [SKNode new];
    [self.foregroundNode setZPosition:SceneLayerForeground];
    [self.foregroundNode setName:@"menuForeground"];
    [self addChild:self.foregroundNode];
    
    //Iceberg group
    SKNode *platformNode = [SKNode new];
    [platformNode setName:@"platform"];
    [self.foregroundNode addChild:platformNode];
    
    [platformNode addChild:[self newPlatformIceberg]];
    [platformNode addChild:[self blackPenguin]];
    
    //Water Surface
    self.waterSurface = [self waterNode];
    [self.foregroundNode addChild:self.waterSurface];
}

- (void)createMenu {
    self.menuNode = [SKNode node];
    [self.menuNode setZPosition:SceneLayerMenu];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    SKLabelNode *titleLabel = [self newTitleLabel];
    [titleLabel setPosition:CGPointMake(0, self.size.height/2 + titleLabel.frame.size.height)]; //For animation
    [self.menuNode addChild:titleLabel];
    
    SSKButtonNode *playButton = [self playButton];
    [playButton setPosition:CGPointMake(0, -self.size.height/2 - playButton.size.height)];      //For animation
    [self.menuNode addChild:playButton];
}

- (void)startAnimations {
    //Water waves
    SKAction *splashLeft = [self waterSplashAtPosition:CGPointMake(-self.size.width/2, 0)];
    SKAction *splashRight = [self waterSplashAtPosition:CGPointMake(self.size.width/2, 0)];
    SKAction *wait = [SKAction waitForDuration:.5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[splashLeft,wait,splashRight,wait]]]];
    
    //Pause to prevent frame skip
    [self runAction:[SKAction waitForDuration:.5] completion:^{

        //Iceberg float
        [[self.backgroundNode childNodeWithName:@"platform"] runAction:[SKAction repeatActionForever:[self floatAction]]];
        
        //Button move in
        [[self.menuNode childNodeWithName:@"playButton"] runAction:[SKAction moveTo:CGPointMake(0, -self.size.height/4) duration:.75 timingMode:SKActionTimingEaseOut]];
        
        //Title move in
        [[self.menuNode childNodeWithName:@"titleLabel"] runAction:[SKAction moveTo:CGPointMake(0, self.size.height/8 * 3) duration:.75 timingMode:SKActionTimingEaseOut]];
    }];
}

#pragma mark - Nodes
- (PPWaterSprite*)waterNode {
    CGFloat surfacePadding = 5;
    CGPoint surfaceStart = CGPointMake(-self.size.width/2 - surfacePadding, 0);
    CGPoint surfaceEnd = CGPointMake(self.size.width/2 + surfacePadding, 0);
    
    PPWaterSprite *waterNode = [PPWaterSprite surfaceWithStartPoint:surfaceStart endPoint:surfaceEnd depth:self.size.height/2];
    [waterNode setName:@"waterSurface"];
    return waterNode;
}

- (SKSpriteNode*)newPlatformIceberg {
    SKSpriteNode *platform = [SKSpriteNode spriteNodeWithTexture:[PPSharedAssets sharedIcebergTexture]];
    [platform setName:@"platformIceberg"];
    [platform setAnchorPoint:CGPointMake(0.5, 1)];
    [platform setPosition:CGPointMake(0, kPlatformPadding)];
    return platform;
}

- (SKLabelNode*)newTitleLabel {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter"];
    [label setText:@"Pajama Penguins"];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setFontSize:30];
    [label setFontColor:[SKColor whiteColor]];
    [label setPosition:CGPointMake(0, self.size.height/8 * 3)];
    [label setName:@"titleLabel"];
    return label;
}

- (SKEmitterNode*)newSnowEmitter {
    SKEmitterNode *snowEmitter = [PPSharedAssets sharedSnowEmitter].copy;
    [snowEmitter setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [snowEmitter setName:@"snowEmitter"];
    return snowEmitter;
}

- (SSKButtonNode*)playButton {
    SSKButtonNode *playButton = [SSKButtonNode buttonWithIdleTexture:[PPSharedAssets sharedPlayButtonUpTexture] selectedTexture:[PPSharedAssets sharedPlayButtonDownTexture]];
    [playButton setTouchUpInsideTarget:self selector:@selector(loadGameScene)];
    [playButton setName:@"playButton"];
    return playButton;
}

#pragma mark - Clouds
- (SSKParallaxNode*)cloudParallaxLayerSlow {
    SKTexture *cloudTexture = [[PPSharedAssets sharedCloudAtlas] textureNamed:@"cloud_01"];
    
    SKSpriteNode *cloudWideHigh = [self cloudNodeWithTexture:cloudTexture alpha:0.25];
    [cloudWideHigh setPosition:CGPointMake(-self.size.width/5, self.size.height/6)];
    
    SKSpriteNode *cloudWideLow = cloudWideHigh.copy;
    [cloudWideLow setPosition:CGPointMake(self.size.width/3, self.size.height/8)];
    
    SSKParallaxNode *layer = [SSKParallaxNode nodeWithSize:self.size attachedNodes:@[cloudWideHigh, cloudWideLow] moveSpeed:CGPointMake(-7.5, 0)];
    [layer setZPosition:SceneLayerClouds];
    return layer;
}

- (SSKParallaxNode*)cloudParallaxLayerFast {
    SKTexture *cloudTexture = [[PPSharedAssets sharedCloudAtlas] textureNamed:@"cloud_00"];
    
    SKSpriteNode *cloudTallHigh = [self cloudNodeWithTexture:cloudTexture alpha:0.4];
    [cloudTallHigh setPosition:CGPointMake(-self.size.width/3, self.size.height/2)];
    
    SKSpriteNode *cloudTallLow = cloudTallHigh.copy;
    [cloudTallLow setPosition:CGPointMake(self.size.width/4, self.size.height/4)];
    
    SSKParallaxNode *layer = [SSKParallaxNode nodeWithSize:self.size attachedNodes:@[cloudTallHigh,cloudTallLow] moveSpeed:CGPointMake(-15, 0)];
    [layer setZPosition:SceneLayerClouds];
    return layer;
}

- (SKSpriteNode*)cloudNodeWithTexture:(SKTexture*)texture alpha:(CGFloat)alpha {
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithTexture:texture];
    [cloud setSize:[self getSizeForNode:cloud]];
    [cloud setAlpha:alpha];
    return cloud;
}

#pragma mark - Penguins Types
- (PPPlayer*)penguinWithType:(PlayerType)type atlas:(SKTextureAtlas*)atlas {
    PPPlayer *penguin = [PPPlayer playerWithType:type atlas:atlas];
    [penguin setSize:[self getSizeForNode:penguin]];
    [penguin setAnchorPoint:CGPointMake(0.5, 0)];
    [penguin setPosition:CGPointMake(0, kPlatformPadding/2)];
    [penguin setPlayerState:PlayerStateIdle];
    [penguin setName:@"penguin"];
    return penguin;
}

- (PPPlayer*)blackPenguin {
    return [self penguinWithType:PlayerTypeBlack atlas:[PPSharedAssets sharedPenguinBlackTextures]];
}

- (void)updateAllPenguins:(NSTimeInterval)dt {
    [self enumerateChildNodesWithName:@"//penguin" usingBlock:^(SKNode *node, BOOL *stop) {
        PPPlayer *penguin = (PPPlayer*)node;
        [penguin update:dt];
    }];
}

#pragma mark - Actions
- (SKAction*)floatAction {
    SKAction *up = [SKAction moveByX:0 y:20 duration:3];
    [up setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *down = [up reversedAction];
    return [SKAction sequence:@[up,down]];
}

- (SKAction*)waterSplashAtPosition:(CGPoint)position {
    return [SKAction runBlock:^{
        [self.waterSurface splash:position speed:kSplashStrength];
    }];
}

#pragma mark - Convenience
- (CGSize)getSizeForNode:(SKSpriteNode*)node {
    CGSize oldNodeSize = node.size;
    CGSize newNodeSize;
    
    if ([UIDevice isUserInterfaceIdiomPhone]) {
        newNodeSize = CGSizeMake(oldNodeSize.width/3, oldNodeSize.height/3);
    }
    
    else if ([UIDevice isUserInterfaceIdiomPad]) {
        newNodeSize = CGSizeMake(oldNodeSize.width * 0.8, oldNodeSize.height * 0.8);
    }
    
    return newNodeSize;
};

#pragma mark - Transfer To Game Scene
- (void)loadGameScene {
    [PPGameScene loadSceneAssetsWithCompletionHandler:^{
        SKScene *gameScene = [PPGameScene sceneWithSize:self.size];
        SKTransition *fade = [SKTransition fadeWithColor:[SKColor whiteColor] duration:1];
        [self.view presentScene:gameScene transition:fade];
    }];
}

#pragma mark - Update
- (void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    
    [self.waterSurface update:self.deltaTime];
    [self.cloudFast update:self.deltaTime];
    [self.cloudSlow update:self.deltaTime];
    [self updateAllPenguins:self.deltaTime];
}

@end

