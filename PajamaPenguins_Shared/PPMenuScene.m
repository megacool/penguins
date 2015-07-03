//
//  PPMenuScene.m
//  PajamaPenguins
//
//  Created by Skye on 3/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPMenuScene.h"
#import "PPGameScene.h"
#import "PPBackgroundManager.h"
#import "PPSharedAssets.h"
#import "PPPlayer.h"
#import "PPSkySprite.h"
#import "PPFishNode.h"
#import "PPWaterSprite.h"
#import "PPCloudParallaxFast.h"
#import "PPCloudParallaxSlow.h"
#import "PPButtonNode.h"
#import "PPFadingSky.h"

#import "SKColor+SFAdditions.h"
#import "SKTexture+SFAdditions.h"
#import "UIDevice+SFAdditions.h"

#import "SSKUtils.h"
#import "SSKParallaxNode.h"
#import "SSKButtonNode.h"
#import "SSKGraphicsUtils.h"
#import "SSKDynamicColorNode.h"

typedef NS_ENUM(NSUInteger, SceneLayer) {
    SceneLayerBackground = 0,
    SceneLayerClouds,
    SceneLayerSnow,
    SceneLayerForeground,
    SceneLayerWater,
    SceneLayerFish,
    SceneLayerMenu = 10,
};

CGFloat const kButtonRadius    = 45.0;
CGFloat const kSplashStrength  = -2.5;
CGFloat const kPlatformPadding = 60.0;

CGFloat const kAnimationFadeTime     = 0.5;
CGFloat const kAnimationMoveDistance = 10;

@interface PPMenuScene()
@property (nonatomic) SKNode *backgroundNode;
@property (nonatomic) SKNode *foregroundNode;
@property (nonatomic) SKNode *menuNode;

@property (nonatomic) PPWaterSprite *waterSurface;

@property (nonatomic) PPCloudParallaxSlow *cloudSlow;
@property (nonatomic) PPCloudParallaxFast *cloudFast;

@property (nonatomic) SKEmitterNode *splashEmitter;

@property (nonatomic) PPPlayer *playerNode;
@end

@implementation PPMenuScene {
    CGFloat _playerSurfaceHeight;
    CGFloat _playerUnderSurfaceHeight;
}

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
}

#pragma mark - Scene Construction
- (void)createSceneBackground {
    NSUInteger timeOfDay = [[PPBackgroundManager sharedManager] timeOfDay];
    self.backgroundColor = [PPSkySprite colorForSkyType:timeOfDay];
    
    self.backgroundNode = [SKNode node];
    [self.backgroundNode setZPosition:SceneLayerBackground];
    [self.backgroundNode setName:@"menuBackground"];
    [self addChild:self.backgroundNode];
    
    //Clouds
    self.cloudSlow = [[PPCloudParallaxSlow alloc] initWithSize:self.size];
    [self.cloudSlow setPosition:CGPointMake(0, -self.size.height/4)];
    [self.cloudSlow setZPosition:2];
    [self.backgroundNode addChild:self.cloudSlow];
    
    self.cloudFast = [[PPCloudParallaxFast alloc] initWithSize:self.size];
    [self.cloudFast setPosition:CGPointMake(0, -self.size.height/4)];
    [self.cloudFast setZPosition:2];
    [self.backgroundNode addChild:self.cloudFast];
    
    //Snow
    [self.backgroundNode addChild:[self newSnowEmitter]];
}

- (void)createSceneForeground {
    self.foregroundNode = [SKNode new];
    [self.foregroundNode setZPosition:SceneLayerForeground];
    [self.foregroundNode setName:@"menuForeground"];
    [self addChild:self.foregroundNode];
    
    self.playerNode = [self blackPenguin];
    [self.foregroundNode addChild:self.playerNode];
    
    _playerSurfaceHeight = -self.size.height/3 - self.playerNode.size.height/2;
    _playerUnderSurfaceHeight = -self.size.height/2 + self.playerNode.size.height/2;
    
    //Water Surface
    self.waterSurface = [self waterNode];
    [self addChild:self.waterSurface];
    
    // Water Splash Emitter
    self.splashEmitter = [PPSharedAssets sharedPlayerSplashDownEmitter];
    [self.splashEmitter setParticleColorSequence:nil];
    [self.splashEmitter setParticleColorBlendFactor:1.0];
    [self.splashEmitter setParticleColor:self.waterSurface.color];
}

- (void)createMenu {
    self.menuNode = [SKNode node];
    [self.menuNode setZPosition:SceneLayerMenu];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    [self.menuNode addChild:[self newTitleLabel]];
    
    [self.menuNode addChild:[self playButton]];
}

- (void)startAnimations {
    //Water waves
    SKAction *splashLeft = [self waterSplashAtPosition:CGPointMake(-self.size.width/2, 0)];
    SKAction *splashRight = [self waterSplashAtPosition:CGPointMake(self.size.width/2, 0)];
    SKAction *wait = [SKAction waitForDuration:.5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[splashLeft,wait,splashRight,wait]]]];
    
    // Fish Spawn
    [self spawnFishForever];
    
    //Pause to prevent frame skip
    [self runAction:[SKAction waitForDuration:0.8] completion:^{
        
        //Player float
        [self playerSwimAnimationLoop];
        [self playerFloatForever];
        
        //Buttons move in
        SKNode *playButton = [self.menuNode childNodeWithName:@"playButton"];
        [playButton runAction:[SKAction moveDistance:CGVectorMake(0, -kAnimationMoveDistance) fadeInWithDuration:kAnimationFadeTime]];
        
        //Title move in
        SKNode *title = [self.menuNode childNodeWithName:@"titleLabel"];
        [title runAction:[SKAction moveDistance:CGVectorMake(0, -kAnimationMoveDistance) fadeInWithDuration:kAnimationFadeTime]];
    }];
}

#pragma mark - Nodes
- (PPWaterSprite*)waterNode {
    CGFloat surfacePadding = 5;
    CGPoint surfaceStart = CGPointMake(-self.size.width/2 - surfacePadding, -self.size.height/3);
    CGPoint surfaceEnd = CGPointMake(self.size.width/2 + surfacePadding, -self.size.height/3);
    
    PPWaterSprite *waterNode = [PPWaterSprite surfaceWithStartPoint:surfaceStart endPoint:surfaceEnd
                                                              depth:self.size.height/6];
    [waterNode setName:@"waterSurface"];
    [waterNode setZPosition:SceneLayerWater];
    return waterNode;
}

- (PPSprite*)newPlatformIceberg {
    PPSprite *platform = [[PPSprite alloc] initWithTexture:[PPSharedAssets sharedIcebergMenuTexture]];
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
    [label setFontSize:35];
    [label setFontColor:[SKColor whiteColor]];
    [label setPosition:CGPointMake(0, (self.size.height/8 * 3) + kAnimationMoveDistance)];
    [label setName:@"titleLabel"];
    [label setAlpha:0];
    return label;
}

- (SKEmitterNode*)newSnowEmitter {
    SKEmitterNode *snowEmitter = [PPSharedAssets sharedSnowEmitter].copy;
    [snowEmitter setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [snowEmitter setZPosition:SceneLayerSnow];
    [snowEmitter setName:@"snowEmitter"];
    return snowEmitter;
}

#pragma mark - Fish
- (void)spawnFishForever {
    if ([self actionForKey:@"fishSpawn"]) return;
    
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *moveLeft = [SKAction moveToX:-self.size.width/4 * 3 duration:3];
    SKAction *moveRight = [SKAction moveToX:self.size.width/4 * 3 duration:3];
    
    SKAction *spawnAndMove = [SKAction runBlock:^{

        // Get random y position
        CGFloat randY = SSKRandomFloatInRange(self.size.height/2, self.size.height/2.5);
        
        // Get random side (left or right)
        CGFloat randLeftRight = SSKRandomFloatInRange(1, 3);
        
        // Spawn a new fish
        PPFishNode *fish = [self newFish];
        [self.backgroundNode addChild:fish];
        
        // Spawn from left, move, remove
        if (randLeftRight == 1) {
            [fish setXScale:-1];
            [fish setPosition:CGPointMake(-self.size.width/2 - fish.size.width/2, -randY)];
            [fish runAction:moveRight completion:^{
                [fish removeFromParent];
            }];
        }
        
        // Spawn from right, move, remove
        else {
            [fish setPosition:CGPointMake(self.size.width/2 + fish.size.width/2, -randY)];
            [fish runAction:moveLeft completion:^{
                [fish removeFromParent];
            }];
        }
        
        // Wiggle
        [fish swimForever];
    }];
    
    SKAction *spawnSequence = [SKAction sequence:@[wait,spawnAndMove]];
    
    [self runAction:[SKAction repeatActionForever:spawnSequence] withKey:@"fishSpawn"];
}

- (PPFishNode*)newFish {
    PPFishNode *fish = [[PPFishNode alloc] initWithType:SSKRandomFloatInRange(0, 4)];
    [fish setSize:CGSizeMake(fish.size.width/2, fish.size.height/2)];
    [fish setZPosition:SceneLayerFish];
    return fish;
}

#pragma mark - Emitter
- (void)runOneShotEmitter:(SKEmitterNode*)emitter location:(CGPoint)location {
    SKEmitterNode *splashEmitter = emitter.copy;
    [splashEmitter setPosition:location];
    [splashEmitter setZPosition:SceneLayerWater + 1];
    [self.foregroundNode addChild:splashEmitter];
    [SSKGraphicsUtils runOneShotActionWithEmitter:splashEmitter duration:0.05];
}

#pragma mark - Buttons
- (PPButtonNode*)playButton {
    PPButtonNode *playButton = [PPButtonNode buttonWithTexture:[PPSharedAssets sharedButtonPlay]];
    [playButton setTouchUpInsideTarget:self selector:@selector(transitionGameScene)];
    [playButton setPosition:CGPointMake(0, -self.size.height/7 + kAnimationMoveDistance)];
    [playButton setName:@"playButton"];
    [playButton setAlpha:0];
    return playButton;
}

#pragma mark - Player
- (PPPlayer*)penguinWithType:(PlayerType)type atlas:(SKTextureAtlas*)atlas {
    PPPlayer *penguin = [PPPlayer playerWithType:type atlas:atlas];
    [penguin setAnchorPoint:CGPointMake(0.5, 0)];
    [penguin setPosition:CGPointMake(-self.size.width/2 - penguin.size.width, -self.size.height/3 - penguin.size.height/10 * 5.5)];
    [penguin setPlayerState:PlayerStateIdle];
    [penguin setName:@"penguin"];
    return penguin;
}

- (PPPlayer*)blackPenguin {
    return [self penguinWithType:PlayerTypeBlack atlas:[PPSharedAssets sharedPenguinBlackTextures]];
}

- (void)playerSwimAnimationLoop {
    if (!self.playerNode || [self.playerNode actionForKey:@"swimmingForever"]) return;
    
    CGFloat playerWidth = self.playerNode.size.width;
    CGFloat swimDuration = 4;
    
    SKAction *swimRight = [SKAction moveToX:self.size.width/2 + playerWidth duration:swimDuration];
    SKAction *swimLeft = [SKAction moveToX:-self.size.width/2 - playerWidth duration:swimDuration];
    
    SKAction *flipLeft = [self flipPlayerLeft];
    SKAction *flipRight = [self flipPlayerRight];

    SKAction *setPlayerStateSwim = [self setPlayerAnimationState:PlayerStateSwim];
    SKAction *setPlayerStateIdle = [self setPlayerAnimationState:PlayerStateIdle];
    
    CGFloat leftX = -self.size.width/2 - self.playerNode.size.width;
    CGFloat rightX = self.size.width/2 + self.playerNode.size.width;

    SKAction *playerPositionUnderSurfaceLeft = [self setPlayerPosition:CGPointMake(leftX, _playerUnderSurfaceHeight)];
    SKAction *playerPositionUnderSurfaceRight = [self setPlayerPosition:CGPointMake(rightX, _playerUnderSurfaceHeight)];
    
    SKAction *playerPositionSurfaceLeft = [self setPlayerPosition:CGPointMake(leftX, _playerSurfaceHeight)];
    SKAction *playerPositionSurfaceRight = [self setPlayerPosition:CGPointMake(rightX, _playerSurfaceHeight)];
    
    SKAction *pause = [SKAction waitForDuration:2];
    
    SKAction *sequence = [SKAction sequence:@[pause,flipRight,playerPositionSurfaceLeft,setPlayerStateSwim,swimRight,pause,// top swim right
                                              flipLeft,playerPositionUnderSurfaceRight,setPlayerStateIdle,swimLeft,pause, // bottom swim left
                                              flipRight,playerPositionUnderSurfaceLeft,swimRight,pause, // bottom swim right
                                              flipLeft,playerPositionSurfaceRight,setPlayerStateSwim,swimLeft]]; // top swim left
    [self.playerNode runAction:[SKAction repeatActionForever:sequence] withKey:@"swimmingForever"];
}

#pragma mark - Player Actions
- (SKAction*)flipPlayerLeft {
    return [SKAction runBlock:^{
        self.playerNode.zRotation = SSKDegreesToRadians(-50);
    }];
}

- (SKAction*)flipPlayerRight {
    return [SKAction runBlock:^{
        self.playerNode.zRotation = SSKDegreesToRadians(50);
    }];
}

- (SKAction*)setPlayerAnimationState:(PlayerState)playerState {
    return [SKAction runBlock:^{
        [self.playerNode setPlayerState:playerState];
    }];
}

- (SKAction*)setPlayerPosition:(CGPoint)position {
    return [SKAction runBlock:^{
        self.playerNode.position = position;
    }];
}

- (void)playerFloatForever {
    if ([self.playerNode actionForKey:@"floating"]) return;
    [self.playerNode runAction:[SKAction repeatActionForever:[self floatAction:self.playerNode.size.height/4]] withKey:@"floating"];
}

#pragma mark - Actions
- (SKAction*)floatAction:(CGFloat)distance {
    SKAction *up = [SKAction moveByX:0 y:distance duration:1];
    [up setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *down = [up reversedAction];
    return [SKAction sequence:@[up,down]];
}

- (SKAction*)waterSplashAtPosition:(CGPoint)position {
    return [SKAction runBlock:^{
        [self.waterSurface splash:position speed:kSplashStrength];
    }];
}

- (SKAction*)waterEmitterAtPosition:(CGPoint)position {
    return [SKAction runBlock:^{
        [self runOneShotEmitter:self.splashEmitter location:position];
    }];
}

#pragma mark - Transitioning scenes
- (void)transitionGameScene {
    [PPGameScene loadSceneAssetsWithCompletionHandler:^{
        SKScene *gameScene = [PPGameScene sceneWithSize:self.size];
        SKTransition *fade = [SKTransition fadeWithColor:[SKColor whiteColor] duration:1];
        [self.view presentScene:gameScene transition:fade];
    }];
}

#pragma mark - Touches
- (void)interactionBeganAtPosition:(CGPoint)position {
    
    // Check if touch is near water surface
    
    CGFloat surfaceHeight = self.waterSurface.startPoint.y;
    CGFloat distanceFromSurface = position.y - surfaceHeight;
    
    if (distanceFromSurface <= 35) {
        // Splash
        [self.waterSurface splash:position speed:-10];
        [self runOneShotEmitter:self.splashEmitter location:CGPointMake(position.x, surfaceHeight - 5)];
    }
    
}

#pragma mark - Update
- (void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    
    [self.waterSurface update:self.deltaTime];
    [self.playerNode update:self.deltaTime];

    [self.cloudSlow update:self.deltaTime];
    [self.cloudFast update:self.deltaTime];
}

@end

