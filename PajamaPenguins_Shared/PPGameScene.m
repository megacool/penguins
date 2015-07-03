//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPMenuScene.h"
#import "PPBackgroundManager.h"
#import "PPSharedAssets.h"
#import "PPPlayer.h"
#import "PPCircleNode.h"
#import "PPCoinNode.h"
#import "PPFishNode.h"
#import "PPBoostMeter.h"
#import "PPIcebergObstacle.h"
#import "PPSkySprite.h"
#import "PPWaterSprite.h"
#import "PPCloudParallaxSlow.h"
#import "PPCloudParallaxFast.h"
#import "PPButtonNode.h"
#import "PPFadingSky.h"
#import "PPUserManager.h"

#import "SKAction+SFSpecialEffects.h"
#import "SKColor+SFAdditions.h"
#import "SSKUtils.h"

#import "SSKProgressBarNode.h"
#import "SSKDynamicColorNode.h"
#import "SSKColorNode.h"
#import "SSKParallaxNode.h"
#import "SSKCameraNode.h"
#import "SSKButtonNode.h"
#import "SSKScoreNode.h"
#import "SSKGraphicsUtils.h"

typedef enum {
    PreGame,
    Playing,
    GameOver,
}GameState;

typedef NS_ENUM(NSUInteger, SceneLayer) {
    SceneLayerBackground = 0,
    SceneLayerClouds,
    SceneLayerSnow,
    SceneLayerIcebergs,
    SceneLayerPlayer,
    SceneLayerWater,
    SceneLayerFish,
    SceneLayerBubbles,
    SceneLayerCoins,
    SceneLayerPopCircle,
    SceneLayerPause,
    SceneLayerHUD,
    SceneLayerGameOver,
    SceneLayerButtons,
    SceneLayerFadeOut = 1000,
};

typedef NS_ENUM(NSUInteger, ParallaxMultiplier) {
    ParallaxMultiplierNormal = 1,
    ParallaxMultiplierBoost = 3,
};

//Button Constants
CGFloat kButtonPadding       = 10.0;
CGFloat kButtonIdleWidth     = 80.0;
CGFloat kButtonSelectedWidth = 70.0;

//Physics Constants
static const uint32_t playerCategory   = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t edgeCategory     = 0x1 << 2;

CGFloat const kAirGravityStrength      = -2.75;
CGFloat const kWaterGravityStrength    = 9;
CGFloat const kGameOverGravityStrength = -9.8;

CGFloat const kMaxSplashStrength      = 50;
CGFloat const kMinSplashStrength      = 5;

CGFloat const kSplashUpStrength   = 20;
CGFloat const kSplashDownStrength = -35;

//Clamped Constants
CGFloat const kWorldScaleCap  = 0.55;

CGFloat const kPlayerUpperVelocityLimit      = 650.0;
CGFloat const kPlayerLowerAirVelocityLimit   = -1000.0;
CGFloat const kPlayerLowerWaterVelocityLimit = -600.0;

//Name Constants
NSString * const kPixelFontName = @"Fipps-Regular";
NSString * const kRemoveName    = @"removeable";
NSString * const kObstacleName  = @"obstacle";
NSString * const kCoinName      = @"coinName";

//Action Constants
CGFloat const kParallaxNormalMoveSpeed = 3.5;
CGFloat const kParallaxBoostMoveSpeed  = 1.75;
CGFloat const kMoveAndFadeTime         = 0.2;
CGFloat const kMoveAndFadeDistance     = 20;
CGFloat const kMoveAndFadeLongDistance = 50;
CGFloat const kObstacleSpawnInterval   = 1.20;

//Action Keys
NSString * const kCoinSpawnKey    = @"coinSpawnKey";
NSString * const kCoinMoveKey     = @"coinMoveKey";
NSString * const kObstacleMoveKey = @"obstacleMoveKey";
NSString * const kFishMoveKey = @"fishMoveKey";

@interface PPGameScene()
@property (nonatomic) GameState gameState;

@property (nonatomic) PPWaterSprite *waterSurface;

@property (nonatomic) SKEmitterNode *snowEmitter;

@property (nonatomic) SKSpriteNode *pauseNode;

// Custom Emitters
@property (nonatomic) SKEmitterNode *splashDownEmitter;
@property (nonatomic) SKEmitterNode *splashUpEmitter;

// Parallax Nodes
@property (nonatomic) PPCloudParallaxSlow *cloudSlow;
@property (nonatomic) PPCloudParallaxFast *cloudFast;

// Coin spawn points
@property (nonatomic) SKNode *coinSpawnPosition;

// Node containers
@property (nonatomic) SKNode *worldNode;
@property (nonatomic) SKNode *hudNode;
@property (nonatomic) SKNode *gameOverNode;
@end

@implementation PPGameScene {
    NSTimeInterval _lastUpdateTime;
    CGFloat _lastPlayerHeight;

    CGFloat _playerBubbleBirthrate;
    CGFloat _playerStarBirthrate;
    
    BOOL _gamePaused;
    
    NSUInteger _currentParallaxMultiplier;
}

- (void)didMoveToView:(SKView *)view {
    [self addGestureRecognizers];
    [self createNewGame];
    [self testStuff];
}

- (void)testStuff {
}

- (void)createNewGame {
    self.gameState = PreGame;
    
    [self createWorldLayer];
    [self startGameAnimations];
}

#pragma mark - World Layer
- (void)createWorldLayer {

    self.worldNode = [SSKCameraNode node];
    [self.worldNode setName:@"world"];
    [self addChild:self.worldNode];

    //Background color
    NSUInteger timeOfDay = [[PPBackgroundManager sharedManager] timeOfDay];
    [self setBackgroundColor:[PPSkySprite colorForSkyType:timeOfDay]];
    
    //Parallaxing Nodes
    self.cloudSlow = [[PPCloudParallaxSlow alloc] initWithSize:CGSizeMake(self.size.width*2, self.size.height)];
    self.cloudSlow.zPosition = SceneLayerClouds;
    [self.worldNode addChild:self.cloudSlow];
    
    self.cloudFast = [[PPCloudParallaxFast alloc] initWithSize:CGSizeMake(self.size.width*2, self.size.height)];
    self.cloudFast.zPosition = SceneLayerClouds;
    [self.worldNode addChild:self.cloudFast];
    
    //Snow Emitter
    self.snowEmitter = [PPSharedAssets sharedSnowEmitter].copy;
    [self.snowEmitter setParticleBirthRate:SSKRandomFloatInRange(0, 100)];
    [self.snowEmitter setZPosition:SceneLayerSnow];
    [self.snowEmitter setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [self.snowEmitter setName:@"snowEmitter"];
    [self addChild:self.snowEmitter];
    
    //Water Surface
    CGPoint surfaceStart = CGPointMake(-self.size.width/2 - 1, 0);
    CGPoint surfaceEnd = CGPointMake(self.size.width/kWorldScaleCap, 0);
    
    self.waterSurface = [PPWaterSprite surfaceWithStartPoint:surfaceStart
                                                    endPoint:surfaceEnd
                                                       depth:self.size.height/2 + 1];
    [self.waterSurface setName:@"water"];
    [self.waterSurface setZPosition:SceneLayerWater];
    [self.worldNode addChild:self.waterSurface];

    //Player
    PPPlayer *player = [self blackPenguin];
    [self.worldNode addChild:player];
    
    //Setting Players initial position height (for water surface tracking)
    _lastPlayerHeight = player.position.y;
    
    //Player's bubble emitter
    SKNode *bubbleTarget = [SKNode new];
    [bubbleTarget setZPosition:SceneLayerBubbles];
    [bubbleTarget setName:kRemoveName];
    [self addChild:bubbleTarget];
    
    SKEmitterNode *playerBubbleEmitter = [PPSharedAssets sharedBubbleEmitter].copy;
    [playerBubbleEmitter setName:@"bubbleEmitter"];
    [playerBubbleEmitter setZPosition:self.waterSurface.zPosition + 1];
    [playerBubbleEmitter setTargetNode:bubbleTarget];
    [self.worldNode addChild:playerBubbleEmitter];
    
    _playerBubbleBirthrate = playerBubbleEmitter.particleBirthRate; //To reset the simulation
    
    //Players star emitter
    SKEmitterNode *playerStarEmitter = [PPSharedAssets sharedStarEmitter].copy;
    [playerStarEmitter setName:@"starEmitter"];
    [playerStarEmitter setZPosition:self.waterSurface.zPosition + 1];
    [playerStarEmitter setTargetNode:bubbleTarget];
    [playerStarEmitter setPosition:CGPointMake(player.position.x - player.size.height/2, player.position.y)];
    [self.worldNode addChild:playerStarEmitter];
    
    _playerStarBirthrate = playerStarEmitter.particleBirthRate; // To reset the simulation
    [playerStarEmitter setParticleBirthRate:0]; // Start the emitter only during boost
    
    //Customize Splash emitters
    self.splashDownEmitter = [PPSharedAssets sharedPlayerSplashDownEmitter];
    [self.splashDownEmitter setParticleColorSequence:nil];
    [self.splashDownEmitter setParticleColorBlendFactor:1.0];
    [self.splashDownEmitter setParticleColor:self.waterSurface.color];
    
    self.splashUpEmitter = [PPSharedAssets sharedPlayerSplashUpEmitter];
    [self.splashUpEmitter setParticleColorSequence:nil];
    [self.splashUpEmitter setParticleColorBlendFactor:1.0];
    [self.splashUpEmitter setParticleColor:self.waterSurface.color];
    
    //Coin spawn points
    self.coinSpawnPosition = [SKNode new];
    [self.coinSpawnPosition setPosition:CGPointMake(self.size.width * 2, self.size.height/4)];
    [self.worldNode addChild:self.coinSpawnPosition];

    //Screen Physics Boundary
    SKSpriteNode *boundary = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.size.width,self.size.height)];
    boundary.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:boundary.frame];
    [boundary.physicsBody setFriction:0];
    [boundary.physicsBody setRestitution:0];
    [boundary.physicsBody setCategoryBitMask:edgeCategory];
    [boundary setName:kRemoveName];
    [self addChild:boundary];
    
    //Set initial boost muliplier
    _currentParallaxMultiplier = 1;
}

#pragma mark - HUD layer
- (void)createHudLayer {
    self.hudNode = [SKNode new];
    [self.hudNode setZPosition:SceneLayerHUD];
    [self.hudNode setName:@"hud"];
    [self.hudNode setAlpha:0];
    [self.hudNode setPosition:CGPointMake(-kMoveAndFadeDistance, 0)];
    [self addChild:self.hudNode];
    
    CGFloat padding = 5.0;

    SSKButtonNode *pauseButton = [SSKButtonNode buttonWithCircleOfRadius:10 idleFillColor:[SKColor whiteColor] selectedFillColor:[SKColor grayColor]];
    [pauseButton setPosition:CGPointMake(self.size.width/2 - pauseButton.size.width/2 - padding, -self.size.height/2 + pauseButton.size.height/2 + padding)];
    [pauseButton setTouchUpInsideTarget:self selector:@selector(pauseButtonTouched)];
    [self.hudNode addChild:pauseButton];
    
    PPBoostMeter *boostMeter = [[PPBoostMeter alloc] initWithSize:CGSizeMake(10, 50)];
    [boostMeter setName:@"boostMeter"];
    [boostMeter setPosition:CGPointMake(-self.size.width/2 + boostMeter.size.width/2 + padding, self.size.height/2 - boostMeter.size.height/2 - padding)];
    [self.hudNode addChild:boostMeter];
    
    NSString *fontName = @"AmericanTypewriter";
    CGFloat fontSize = 12.0;
    
    SSKScoreNode *scoreCounter = [SSKScoreNode scoreNodeWithFontNamed:fontName fontSize:20 fontColor:[SKColor whiteColor]];
    [scoreCounter setName:@"scoreCounter"];
    [scoreCounter setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [scoreCounter setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    [scoreCounter setPosition:CGPointMake(boostMeter.position.x + boostMeter.size.width/2 + padding, self.size.height/2 - padding)];
    [self.hudNode addChild:scoreCounter];
    
    PPCoinNode *coinNode = [[PPCoinNode alloc] init];
    [coinNode setName:@"scoreCoin"];
    [coinNode setPosition:CGPointMake(self.size.width/2 - coinNode.size.width, self.size.height/2 - coinNode.size.height/2 - padding)];
    [self.hudNode addChild:coinNode];
    
    SSKScoreNode *coinCounter = [SSKScoreNode scoreNodeWithFontNamed:fontName fontSize:fontSize fontColor:[SKColor whiteColor]];
    [coinCounter setName:@"coinCounter"];
    [coinCounter setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [coinCounter setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    [coinCounter setPosition:CGPointMake(coinNode.position.x, coinNode.position.y - coinNode.size.height/2 - padding)];
    [coinCounter setScore:[[PPUserManager sharedManager] getTotalCoins].integerValue];
    [self.hudNode addChild:coinCounter];
}

- (void)hudLayerFadeInAnimation {
    [self.hudNode runAction:[SKAction moveDistance:CGVectorMake(kMoveAndFadeDistance, 0) fadeInWithDuration:kMoveAndFadeTime]];
}

- (void)hudLayerFadeOutAnimation {
    if (self.hudNode) {
        [self.hudNode runAction:[SKAction moveDistance:CGVectorMake(kMoveAndFadeDistance, 0) fadeOutWithDuration:kMoveAndFadeTime]];
    }
}

#pragma mark - Game Over layer
- (void)createGameOverLayer {
    self.gameOverNode = [SKNode node];
    [self.gameOverNode setZPosition:SceneLayerGameOver];
    [self.gameOverNode setName:@"gameOver"];
    [self.gameOverNode setAlpha:0];
    [self.gameOverNode setPosition:CGPointMake(-kMoveAndFadeLongDistance, 0)];
    [self addChild:self.gameOverNode];
    
    // Game over text label
    SKLabelNode *gameOverLabel = [self createNewLabelWithText:@"Game Over" withFontSize:55];
    [gameOverLabel setFontColor:[SKColor darkRed]];
    [gameOverLabel setPosition:CGPointMake(0, self.size.height/3)];
    [self.gameOverNode addChild:gameOverLabel];
    
    // Score string
    NSString *currentScoreString = [(SSKScoreNode*)[self.hudNode childNodeWithName:@"scoreCounter"] text];
    
    // Score label
    SKLabelNode *scoreLabel = [self createNewLabelWithText:[NSString stringWithFormat:@"Score: %@",currentScoreString] withFontSize:30];
    [scoreLabel setFontColor:[SKColor darkRed]];
    [scoreLabel setPosition:CGPointMake(gameOverLabel.position.x, gameOverLabel.position.y - 50)];
    [self.gameOverNode addChild:scoreLabel];
    
    // Coins Label
    NSUInteger totalCoinsCount = [(SSKScoreNode*)[self.hudNode childNodeWithName:@"coinCounter"] count];
    SKLabelNode *coinsLabel = [self createNewLabelWithText:[NSString stringWithFormat:@"Coins: %lu", (unsigned long)totalCoinsCount] withFontSize:30];
    [coinsLabel setFontColor:[SKColor darkRed]];
    [coinsLabel setPosition:CGPointMake(gameOverLabel.position.x, gameOverLabel.position.y - 100)];
    [self.gameOverNode addChild:coinsLabel];
    
    // Buttons
    [self.gameOverNode addChild:[self menuButton]];
    [self.gameOverNode addChild:[self retryButton]];
}

- (void)gameOverFadeInAnimation {
    [self.gameOverNode runAction:[SKAction moveDistance:CGVectorMake(kMoveAndFadeLongDistance, 0) fadeInWithDuration:kMoveAndFadeTime]];
}

#pragma mark - GameState Playing
- (void)gameStart {
    self.gameState = Playing;

    [self runAction:[SKAction fadeOutWithDuration:.5] onNode:[self childNodeWithName:@"menu"]];
    
    [self createHudLayer];
    [self hudLayerFadeInAnimation];
    
    [self startObstacleSpawnSequence];
    
    [self startCoinSpawnIntervals];
    
    [self startScoreCounter];
}

- (void)startGameAnimations {
    [self runAction:[SKAction waitForDuration:.5] completion:^{
        
        SKAction *splashRight = [self waterSplashAtPosition:CGPointMake(self.size.width/2, 0)];
        SKAction *wait = [SKAction waitForDuration:.5];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[splashRight,wait]]] withKey:@"idleSplashKey"];
        
        // Start fish spawn forever
        [self spawnFishForever];
    }];
}

#pragma mark - GameState GameOver
- (void)gameEnd {
    self.gameState = GameOver;
    
    [self stopCoinSpawn];
    [self stopScoreCounter];
    [self checkIfHighScore];
    [self saveCoins];
    
    [self stopStarEmitter];
    
    [self stopObstacleSpawnSequence];
    [self stopObstacleMovement];
    
    [self runGameOverSequence];
}

- (void)runGameOverSequence {
    [self setGravity:kGameOverGravityStrength];
    
    [self hudLayerFadeOutAnimation];
    
    [self playerGameOverCatapult];

    [self createGameOverLayer];
    [self gameOverFadeInAnimation];
}

- (void)resetGame {
    SKSpriteNode *fadeNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:self.size];
    [fadeNode setZPosition:SceneLayerFadeOut];
    [fadeNode setAlpha:0];
    [self addChild:fadeNode];
    
    [fadeNode runAction:[SKAction fadeInWithDuration:.5] completion:^{
        [self.worldNode removeFromParent];
        [self.hudNode removeFromParent];
        [self.gameOverNode removeFromParent];
        [self removeUnparentedNodes];
        
        [self createNewGame];
        
        [self runAction:[SKAction waitForDuration:.25] completion:^{
            [fadeNode runAction:[SKAction fadeOutWithDuration:.5] completion:^{
                [fadeNode removeFromParent];
            }];
        }];
    }];
}

#pragma mark - Menu Button
- (PPButtonNode*)menuButton {
    PPButtonNode *menuButton = [PPButtonNode buttonWithTexture:[PPSharedAssets sharedButtonHome]
                                                      idleSize:CGSizeMake(kButtonIdleWidth, kButtonIdleWidth)
                                                  selectedSize:CGSizeMake(kButtonSelectedWidth, kButtonSelectedWidth)];
    
    [menuButton setTouchUpInsideTarget:self selector:@selector(menuButtonTouched)];
    [menuButton setPosition:CGPointMake(-kButtonIdleWidth, -self.size.height/7)];
    [menuButton setZPosition:SceneLayerButtons];
    return menuButton;
}

- (void)menuButtonTouched {
    [self loadMenuScene];
    [[PPBackgroundManager sharedManager] incrementDay];
}

#pragma mark - Retry Button
- (PPButtonNode*)retryButton {
    PPButtonNode *retryButton = [PPButtonNode buttonWithTexture:[PPSharedAssets sharedButtonPlay]
                                                       idleSize:CGSizeMake(kButtonIdleWidth, kButtonIdleWidth)
                                                   selectedSize:CGSizeMake(kButtonSelectedWidth, kButtonSelectedWidth)];
    
    [retryButton setTouchUpInsideTarget:self selector:@selector(retryButtonTouched)];
    [retryButton setPosition:CGPointMake(kButtonIdleWidth, -self.size.height/7)];
    [retryButton setZPosition:SceneLayerButtons];
    return retryButton;
}

- (void)retryButtonTouched {
    [self resetGame];
    [[PPBackgroundManager sharedManager] incrementDay];
}

#pragma mark - Pause Button
- (void)pauseButtonTouched {
    [self toggleGamePause];
}

#pragma mark - Pausing
- (void)toggleGamePause {
    if (_gamePaused) {
        _gamePaused = NO;
        [self pauseGame:NO];
    } else {
        _gamePaused = YES;
        [self pauseGame:YES];
    }
}

- (void)pauseGame:(BOOL)shouldPause {
    // Pause all actions on world node
    [self setPause:shouldPause onAllChildrenOfNode:self.worldNode];
    
    // Pause individual nodes
    [self.snowEmitter setPaused:shouldPause];
    [self setPauseOnAllParallaxNodes:shouldPause];
    
    // Pause individual actions
    [self setPauseOnSpawnActions:shouldPause];
    
    // Pausing physics simulation
    [self setPauseOnPhysicsSimulation:shouldPause];
    
    // Adding the pause layer
    [self togglePauseLayer:shouldPause];
}

- (void)setPause:(BOOL)shouldPause onAllChildrenOfNode:(SKNode*)node {
    for (SKNode *child in node.children) {
        child.paused = shouldPause;
    }
}

- (void)setPauseOnAllParallaxNodes:(BOOL)shouldPause {
    if (shouldPause) {
        [self.cloudFast.parallaxLayer setMoveSpeedMultiplier:0];
        [self.cloudSlow.parallaxLayer setMoveSpeedMultiplier:0];
    } else {
        [self.cloudFast.parallaxLayer setMoveSpeedMultiplier:_currentParallaxMultiplier];
        [self.cloudSlow.parallaxLayer setMoveSpeedMultiplier:_currentParallaxMultiplier];
    }
}

- (void)setPauseOnPhysicsSimulation:(BOOL)shouldPause {
    if (shouldPause) {
        [self.physicsWorld setSpeed:0];
    } else {
        [self.physicsWorld setSpeed:1];
    }
}

- (void)setPauseOnSpawnActions:(BOOL)shouldPause {
    if (shouldPause) {
        [[self actionForKey:@"idleSpawnKey"] setSpeed:0];
        [[self actionForKey:@"fishSpawn"] setSpeed:0];
        [[self actionForKey:@"gamePlaying"] setSpeed:0];
        [[self actionForKey:@"scoreKey"] setSpeed:0];
        [[self actionForKey:kCoinSpawnKey] setSpeed:0];
    } else {
        [[self actionForKey:@"idleSpawnKey"] setSpeed:1];
        [[self actionForKey:@"fishSpawn"] setSpeed:1];
        [[self actionForKey:@"gamePlaying"] setSpeed:1];
        [[self actionForKey:@"scoreKey"] setSpeed:1];
        [[self actionForKey:kCoinSpawnKey] setSpeed:1];
    }
}

- (void)togglePauseLayer:(BOOL)shouldPause {
    if (shouldPause) {
        self.pauseNode = [self createPauseLayer];
        [self addChild:self.pauseNode];
    } else {
        [self.pauseNode removeFromParent];
    }
}

#pragma mark - Pause Layer
- (SKSpriteNode*)createPauseLayer {
    SKSpriteNode *dimSprite = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
    [dimSprite setAlpha:0.5];
    [dimSprite setZPosition:SceneLayerPause];
    
    SKLabelNode *pauseLabel = [SKLabelNode labelNodeWithText:@"Paused"];
    [pauseLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [pauseLabel setColor:[SKColor whiteColor]];
    [dimSprite addChild:pauseLabel];
    
    return dimSprite;
}

#pragma mark - Coins
- (void)startCoinSpawnIntervals {
    CGFloat coinCount = 1;
    SKAction *wait = [SKAction waitForDuration:kObstacleSpawnInterval/2];
    SKAction *spawnInterval = [SKAction waitForDuration:0.15];
    
    // Get new spawn point
    SKAction *getSpawnPosition = [SKAction runBlock:^{
        CGFloat randomHeight = SSKRandomFloatInRange(self.size.height/5, self.size.height);
        CGPoint newPoint = CGPointMake(self.size.width * 2, randomHeight);
        [self.coinSpawnPosition setPosition:newPoint];
    }];
    
    // Spawn Block
    SKAction *spawn = [SKAction runBlock:^{
        [self spawnCoinAtPosition:self.coinSpawnPosition.position];
    }];
    
    // Create a sequence with the given count
    NSMutableArray *spawnActions = [NSMutableArray new];
    for (int i = 0; i < coinCount; i++) {
        [spawnActions addObject:spawn];
        [spawnActions addObject:spawnInterval];
    }
    
    SKAction *spawnSequence = [SKAction sequence:spawnActions];
    SKAction *spawnIntervals = [SKAction sequence:@[getSpawnPosition, spawnSequence, wait]];
    
    [self runAction:[SKAction repeatActionForever:spawnIntervals] withKey:kCoinSpawnKey];
}

- (void)stopCoinSpawn {
    [self removeActionForKey:kCoinSpawnKey];
    [self.worldNode enumerateChildNodesWithName:kCoinName usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeActionForKey:kCoinMoveKey];
    }];
}

- (void)checkCoinsDidIntersect {
    [self.worldNode enumerateChildNodesWithName:kCoinName usingBlock:^(SKNode *node, BOOL *stop) {
        PPCoinNode *coin = (PPCoinNode*)node;
        if (CGRectIntersectsRect([self currentPlayer].frame, coin.frame)) {
            [coin removeFromParent];
            [coin setPosition:[self.worldNode convertPoint:[[self currentPlayer] position] toNode:self]];
            [self.hudNode addChild:coin];
            
            [self popCircleOnNode:[self currentPlayer] color:[SKColor colorWithRed:0.935 green:0.744 blue:0.042 alpha:1.000]];
            
            [coin runAction:[SKAction moveTo:[self getScoreCoin].position duration:0.3] completion:^{
                [self scoreCoinPop];
                [coin removeFromParent];
                [(SSKScoreNode*)[self.hudNode childNodeWithName:@"coinCounter"] increment];
            }];
        }
    }];
}

#pragma mark - Score Coin
- (PPCoinNode*)getScoreCoin {
    return (PPCoinNode*)[self.hudNode childNodeWithName:@"scoreCoin"];
}

- (void)scoreCoinPop {
    SKAction *scaleUp = [SKAction scaleTo:1.4 duration:0.075];
    SKAction *scaleNormal = [SKAction scaleTo:1 duration:0.075];
    [[self getScoreCoin] runAction:[SKAction sequence:@[scaleUp,scaleNormal]]];
}

- (void)saveCoins {
    NSInteger coinCount = [(SSKScoreNode*)[self.hudNode childNodeWithName:@"coinCounter"] count];
    [[PPUserManager sharedManager] saveCoins:[NSNumber numberWithInteger:coinCount]];
    NSLog(@"Total coins:%@",[[PPUserManager sharedManager] getTotalCoins]);
}

#pragma mark - Spawn Coins
- (void)spawnCoinAtPosition:(CGPoint)position {
    PPCoinNode *newCoin = [PPCoinNode new];
    
    [self runAction:[SKAction runBlock:^{
        
        // Spawn a coin
        PPCoinNode *coin = newCoin.copy;
        [coin setZPosition:SceneLayerCoins];
        [coin setPosition:position];
        [coin setName:kCoinName];
        [coin spinAnimation];
        [self.worldNode addChild:coin];
        
        // Move coin off screen
        [coin runAction:[SKAction moveToX:-self.size.width/4 * 3 duration:kParallaxNormalMoveSpeed] withKey:kCoinMoveKey completion:^{
            [coin removeFromParent];
        }];
    }]];
}

- (SKAction*)spawnCoinsWithCount:(NSUInteger)count withInterval:(CGFloat)interval atPosition:(CGPoint)position {
    SKAction *spawnInterval = [SKAction waitForDuration:interval];
    SKAction *spawnAction = [SKAction runBlock:^{
        [self spawnCoinAtPosition:position];
    }];
    
    // Create a sequence with the given count
    NSMutableArray *actions = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        [actions addObject:spawnAction];
        [actions addObject:spawnInterval];
    }
    
    return [SKAction sequence:actions];
}

#pragma mark - Fish
- (void)spawnFishForever {
    if ([self actionForKey:@"fishSpawn"]) return;
    
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *move = [SKAction moveToX:-self.size.width/4 * 3 duration:3.5];
    
    SKAction *spawnAndMove = [SKAction runBlock:^{
        
        // Get random y position
        CGFloat randY = SSKRandomFloatInRange(self.size.height/10, self.size.height/2);

        // Spawn a new fish
        PPFishNode *fish = [[PPFishNode alloc] initWithType:SSKRandomFloatInRange(0, 4)];
        [fish setPosition:CGPointMake(self.size.width*2, -randY)];
        [fish setSize:CGSizeMake(fish.size.width/3, fish.size.height/3)];
        [fish setZPosition:SceneLayerFish];
        [self.worldNode addChild:fish];
        
        // Start Fish swim animation
        [fish swimForever];
        
        // Move fish across scene then remove
        [fish runAction:move withKey:kFishMoveKey completion:^{
            [fish removeFromParent];
        }];
    }];
    
    SKAction *spawnSequence = [SKAction sequence:@[wait,spawnAndMove]];
    
    [self runAction:[SKAction repeatActionForever:spawnSequence] withKey:@"fishSpawn"];
}

- (void)checkFishDidIntersect {
    [self.worldNode enumerateChildNodesWithName:kFishName usingBlock:^(SKNode *node, BOOL *stop) {
        PPFishNode *fish = (PPFishNode*)node;
        if (CGRectIntersectsRect([self currentPlayer].frame, fish.frame)) {
            if ([self currentBoostMeter].currentProgress < 1.0) {
                [self adjustBoostMeter:0.10];
            }
            
            [self popCircleOnNode:[self currentPlayer] color:fish.color];
            
            [fish removeFromParent];
        }
    }];
}

#pragma mark - Circle Pop Animation
- (void)popCircleOnNode:(SKSpriteNode*)node color:(SKColor*)color {
    PPCircleNode *circle = [PPCircleNode shapeNodeWithCircleOfRadius:node.size.width/4];
    [circle setZPosition:SceneLayerPopCircle];
    [circle setFillColor:color];
    [node addChild:circle];
    [circle expandAndFade];
}

#pragma mark - Penguin Types
- (PPPlayer*)penguinWithType:(PlayerType)type atlas:(SKTextureAtlas*)atlas {
    PPPlayer *penguin = [PPPlayer playerWithType:type atlas:atlas];
    [penguin setPosition:CGPointMake(-self.size.width/4, 50)];
    [penguin setName:@"player"];
    [penguin setSize:CGSizeMake(30, 30)];
    [penguin setZRotation:SSKDegreesToRadians(90)];
    [penguin setZPosition:SceneLayerPlayer];
    [penguin setPlayerShouldRotate:YES];
    [penguin setPlayerState:PlayerStateFly];
    [penguin createPhysicsBody];
    [penguin.physicsBody setCategoryBitMask:playerCategory];
    [penguin.physicsBody setCollisionBitMask:obstacleCategory | edgeCategory];
    [penguin.physicsBody setContactTestBitMask:obstacleCategory];
    return penguin;
}

- (PPPlayer*)blackPenguin {
    return [self penguinWithType:PlayerTypeBlack atlas:[PPSharedAssets sharedPenguinBlackTextures]];
}

#pragma mark - Player
- (void)clampPlayerVelocity {
    PPPlayer *player = [self currentPlayer];
    
    if (player.physicsBody.velocity.dy >= kPlayerUpperVelocityLimit) {
        [player.physicsBody setVelocity:CGVectorMake(player.physicsBody.velocity.dx, kPlayerUpperVelocityLimit)];
    }
    
    if (player.position.y > [self.worldNode childNodeWithName:@"water"].position.y) {
        if (player.physicsBody.velocity.dy <= kPlayerLowerAirVelocityLimit) {
            [player.physicsBody setVelocity:CGVectorMake(player.physicsBody.velocity.dx, kPlayerLowerAirVelocityLimit)];
        }
    } else {
        if (player.physicsBody.velocity.dy <= kPlayerLowerWaterVelocityLimit) {
            [player.physicsBody setVelocity:CGVectorMake(player.physicsBody.velocity.dx, kPlayerLowerWaterVelocityLimit)];
        }
    }
}

- (void)playerGameOverCatapult {
    PPPlayer *player = (PPPlayer*)[self.worldNode childNodeWithName:@"player"];
    [player.physicsBody setVelocity:CGVectorMake(0, 0)];
    [player.physicsBody setCollisionBitMask:0x0];
    [player.physicsBody setContactTestBitMask:0x0];
    [player.physicsBody applyImpulse:CGVectorMake(1, 20)];
    [player.physicsBody applyAngularImpulse:-.00525];
}

- (void)updatePlayer:(NSTimeInterval)dt {
    [self checkPlayerAnimationState];

    [[self currentPlayer] update:dt];
    [self clampPlayerVelocity];
}

- (void)checkPlayerAnimationState {
    if ([self currentPlayer].playerShouldDive == YES) {
        [[self currentPlayer] setPlayerState:PlayerStateDive];
        return;
    }
    
    if ([self currentPlayer].position.y < self.waterSurface.position.y) {
        [[self currentPlayer] setPlayerState:PlayerStateSwim];
    }
    
    else {
        [[self currentPlayer] setPlayerState:PlayerStateFly];
    }
}

#pragma mark - Water Surface
- (SKAction*)waterSplashAtPosition:(CGPoint)position {
    return [SKAction runBlock:^{
        [self.waterSurface splash:position speed:-kMinSplashStrength/2];
    }];
}

#pragma mark - Water emitters
- (void)trackPlayerForSplash {
    CGFloat newPlayerHeight = [self currentPlayer].position.y;
    
    //Cross surface from bottom
    if (_lastPlayerHeight < 0 && newPlayerHeight > 0) {
        CGFloat splashStrength = kSplashUpStrength;
        
        [self.waterSurface splash:[self currentPlayer].position speed:splashStrength];
        [self runOneShotEmitter:self.splashUpEmitter location:[self currentPlayer].position];
        
        _lastPlayerHeight = newPlayerHeight;
        
        // Audio
//        [[PPSharedAssets sharedSplashSFX] startSound];
    }
    
    //Cross surface from top
    else if (_lastPlayerHeight > 0 && newPlayerHeight < 0) {
        CGFloat splashStrength = kSplashDownStrength;
        
        [self.waterSurface splash:[self currentPlayer].position speed:splashStrength];
        [self runOneShotEmitter:self.splashDownEmitter location:[self currentPlayer].position];
        
        _lastPlayerHeight = newPlayerHeight;
        
        // Audio
//        [[PPSharedAssets sharedSplashSFX] startSound];
    }
}

- (void)trackPlayerForBubbles {
    if ([self playerIsBelowBottomBoundary]) {
        [[self playerBubbleEmitter] setPosition:[self currentPlayer].position];

        if ([self playerBubbleEmitter].particleBirthRate == 0) {
            [[self playerBubbleEmitter] resetSimulation];
            [[self playerBubbleEmitter] setParticleBirthRate:_playerBubbleBirthrate];
        }
    } else {
        [[self playerBubbleEmitter] setParticleBirthRate:0];
    }
}

#pragma mark - Star Emitter
- (void)updateStarEmitterPosition {
    CGPoint playerPosition = [self currentPlayer].position;
    SKEmitterNode *starEmitter = (SKEmitterNode*)[self.worldNode childNodeWithName:@"starEmitter"];
    [starEmitter setPosition:CGPointMake(starEmitter.position.x, playerPosition.y)];
}

- (SKAction*)setStarEmitterBirthrate:(CGFloat)birthrate {
    return [SKAction runBlock:^{
        SKEmitterNode *starEmitter = [self currentStarEmitter];
        [starEmitter resetSimulation];
        [starEmitter setParticleBirthRate:birthrate];
    }];
}

- (SKAction*)stopStarEmitterAction {
    return [SKAction runBlock:^{
        [self stopStarEmitter];
    }];
}

- (void)stopStarEmitter {
    SKEmitterNode *starEmitter = (SKEmitterNode*)[self.worldNode childNodeWithName:@"starEmitter"];
    [starEmitter setParticleBirthRate:0];
}

- (SKEmitterNode*)currentStarEmitter {
    return (SKEmitterNode*)[self.worldNode childNodeWithName:@"starEmitter"];
}

- (SKAction*)runStarExplosionAtPosition:(CGPoint)position {
    return [SKAction runBlock:^{
        [self runOneShotEmitter:[PPSharedAssets sharedStarExplosionEmitter] location:position];
    }];
}

#pragma mark - Emitters
- (void)runOneShotEmitter:(SKEmitterNode*)emitter location:(CGPoint)location {
    SKEmitterNode *splashEmitter = emitter.copy;
    [splashEmitter setPosition:location];
    [splashEmitter setZPosition:SceneLayerWater + 1];
    [splashEmitter setAlpha:0.6];
    [self.worldNode addChild:splashEmitter];
    [SSKGraphicsUtils runOneShotActionWithEmitter:splashEmitter duration:0.15];
}

- (SKEmitterNode*)playerBubbleEmitter {
    return (SKEmitterNode*)[self.worldNode childNodeWithName:@"bubbleEmitter"];
}

#pragma mark - Icebergs
- (PPIcebergObstacle*)newIceBerg {
    // Get a random scale between 0.5 - 1.0
    CGFloat rand = SSKRandomFloatInRange(25, 100);
    CGFloat newScale = (rand/100);
    
    PPIcebergObstacle *obstacle = [PPIcebergObstacle icebergWithType:IceBergTypeNormal];
    [obstacle setName:kObstacleName];
    [obstacle setScale:newScale];
    [obstacle setPosition:CGPointMake(self.size.width * 2, obstacle.size.height / 10)];
    [obstacle setZPosition:SceneLayerIcebergs];
    [obstacle.physicsBody setCategoryBitMask:obstacleCategory];
    return obstacle;
}

#pragma mark - Obstacle Spawn Sequence
- (void)startObstacleSpawnSequence {
    SKAction *wait = [SKAction waitForDuration:kObstacleSpawnInterval];
    SKAction *spawnFloatMove = [SKAction runBlock:^{
        SKNode *obstacle = [self newIceBerg];
        [self.worldNode addChild:obstacle];
        [obstacle runAction:[SKAction repeatActionForever:[self floatAction]]];
        [obstacle runAction:[SKAction moveToX:-self.size.width/4 * 3 duration:kParallaxNormalMoveSpeed] withKey:kObstacleMoveKey completion:^{
            [obstacle removeFromParent];
        }];
    }];
    SKAction *sequence = [SKAction sequence:@[wait,spawnFloatMove]];
    [self runAction:[SKAction repeatActionForever:sequence] withKey:@"gamePlaying"];
}

- (void)stopObstacleSpawnSequence {
    [self removeActionForKey:@"gamePlaying"];
}

- (void)stopObstacleMovement {
    [self.worldNode enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeActionForKey:kObstacleMoveKey];
    }];
}

#pragma mark - Score Tracking
- (void)startScoreCounter {
    SKAction *timerDelay = [SKAction waitForDuration:.25];
    SKAction *incrementScore = [SKAction runBlock:^{
        [(SSKScoreNode*)[self.hudNode childNodeWithName:@"scoreCounter"] increment];
    }];
    SKAction *sequence = [SKAction sequence:@[timerDelay,incrementScore]];
    [self runAction:[SKAction repeatActionForever:sequence] withKey:@"scoreKey"];
}

- (void)stopScoreCounter {
    [self removeActionForKey:@"scoreKey"];
}

- (void)checkIfHighScore {
    NSInteger currentScore = [(SSKScoreNode*)[self.hudNode childNodeWithName:@"scoreCounter"] count];
    NSInteger highScore = [[PPUserManager sharedManager] getHighScore].integerValue;
    
    if (currentScore > highScore) {
        [[PPUserManager sharedManager] saveHighScore:[NSNumber numberWithInteger:currentScore]];
        [self highScoreAnimation];
    }
}

- (void)highScoreAnimation {

    SKLabelNode *highScoreLabel = [self createNewLabelWithText:@"Highscore!" withFontSize:30];
    [highScoreLabel setFontColor:[SKColor whiteColor]];
    [highScoreLabel setZPosition:SceneLayerGameOver];
    [highScoreLabel setPosition:CGPointMake(0, self.size.height/2 - highScoreLabel.frame.size.height)];
    [highScoreLabel setName:kRemoveName];
    [highScoreLabel setScale:0];
    [self addChild:highScoreLabel];
    
    SKAction *wait = [SKAction waitForDuration:.4];
    SKAction *grow = [SKAction scaleTo:1.5 duration:.4];
    [grow setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *explosion = [self runStarExplosionAtPosition:highScoreLabel.position];
    SKAction *shrink = [SKAction scaleTo:1 duration:.2];
  
    SKAction *idleGrow = [SKAction scaleTo:1.2 duration:.4];
    [idleGrow setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *idleShrink = [SKAction scaleTo:1 duration:.4];
    SKAction *pulsate = [SKAction repeatActionForever:[SKAction sequence:@[idleGrow,idleShrink]]];
    
    [highScoreLabel runAction:[SKAction sequence:@[wait,explosion,grow,shrink]] completion:^{
        [highScoreLabel runAction:pulsate];
    }];
}

#pragma mark - World Gravity
- (void)setGravity:(CGFloat)gravity {
    [self.physicsWorld setGravity:CGVectorMake(0, gravity)];
}

- (void)updateGravity {
    if ([self currentPlayer].position.y > [self.worldNode childNodeWithName:@"water"].position.y) {
        [self setGravity:kAirGravityStrength];
    } else {
        [self setGravity:kWaterGravityStrength];
    }
}

#pragma mark - Actions
- (SKAction*)floatAction {
    SKAction *down = [SKAction moveByX:0 y:-10 duration:2];
    [down setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *up = [down reversedAction];
    return [SKAction sequence:@[down,up]];
}

- (void)runColorChangeOnLabel:(SKLabelNode*)label interval:(CGFloat)interval {
    SKAction *changeToRed = [SKAction runBlock:^{
        [label setFontColor:[SKColor redColor]];
    }];
    
    SKAction *changeToBlue = [SKAction runBlock:^{
        [label setFontColor:[SKColor blueColor]];
    }];
    SKAction *wait = [SKAction waitForDuration:interval];
    
    SKAction *sequence = [SKAction repeatActionForever:[SKAction sequence:@[changeToRed, wait, changeToBlue, wait]]];
    
    NSString *actionKey = @"colorChangeKey";
    if (![label actionForKey:actionKey]) {
        [label runAction:sequence withKey:actionKey];
    }
}

#pragma mark - Convenience
- (SKLabelNode *)createNewLabelWithText:(NSString*)text withFontSize:(CGFloat)fontSize {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter"];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setFontColor:[SKColor whiteColor]];
    [label setText:text];
    [label setFontSize:fontSize];
    return label;
}

- (void)runAction:(SKAction*)action onNode:(SKNode*)node {
    [node runAction:action];
}

- (PPPlayer*)currentPlayer {
    return (PPPlayer*)[self.worldNode childNodeWithName:@"player"];
}

#pragma mark - Remove all nodes 
- (void)removeAllChildrenOfScene {
    for (SKNode* node in self.children) {
        for (SKNode *child in node.children) {
            [child removeAllActions];
            [child removeFromParent];
        }
        [node removeFromParent];
        [node removeAllActions];
    }
}

- (void)removeUnparentedNodes {
    // Remove all "Removeable" nodes without a scene parent
    [self enumerateChildNodesWithName:kRemoveName usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    // Remove Snow
    [self.snowEmitter removeFromParent];
}

#pragma mark - Collisions
- (void)resolveCollisionFromFirstBody:(SKPhysicsBody *)firstBody secondBody:(SKPhysicsBody *)secondBody {
    if (self.gameState == Playing) {
        [self.worldNode runAction:[SKAction shakeWithDuration:.1 amplitude:CGPointMake(10, 10)]];
        [self gameEnd];
    }
}

#pragma mark - Boost
- (void)boostActionGroup {
    if ([self actionForKey:@"boostKey"]) return;
    if ([self currentBoostMeter].currentProgress < 0.49f) return;
    
    SKAction *startBoost = [self adjustBoostSpeed:ParallaxMultiplierBoost];
    SKAction *wait = [SKAction waitForDuration:3.0];
    SKAction *endBoost = [self adjustBoostSpeed:ParallaxMultiplierNormal];
    SKAction *snowAccelDown = [self snowAccelerationNormal];
    SKAction *snowAccelUp = [self snowAccelerationBoost];
    SKAction *starExplosion = [self runStarExplosionAtPosition:[self currentPlayer].position];
    SKAction *starEmitterOn = [self setStarEmitterBirthrate:_playerStarBirthrate];
    SKAction *starEmitterOff = [self stopStarEmitterAction];
    SKAction *adjustBoostMeter = [self adjustBoostMeterAction:-0.5];
    
    SKAction *sequence = [SKAction sequence:@[starExplosion,startBoost,snowAccelUp,starEmitterOn,adjustBoostMeter,wait,
                                              endBoost,snowAccelDown,starEmitterOff]];
    
    [self runAction:sequence withKey:@"boostKey"];
}

- (SKAction*)adjustBoostSpeed:(NSUInteger)speed {
    return [SKAction runBlock:^{
        _currentParallaxMultiplier = speed;
        
        // Spawning nodes
        [self setNodeSpeed:speed withNodeName:kCoinName withActionName:kCoinMoveKey];
        [self setNodeSpeed:speed withNodeName:kObstacleName withActionName:kObstacleMoveKey];
        [self setNodeSpeed:speed withNodeName:kFishName withActionName:kFishMoveKey];
        
        // Parallax Nodes
        self.cloudFast.parallaxLayer.moveSpeedMultiplier = speed;
        self.cloudSlow.parallaxLayer.moveSpeedMultiplier = speed;
    }];
}

- (void)setNodeSpeed:(CGFloat)speed withNodeName:(NSString*)nodeName withActionName:(NSString*)actionName {
    [self.worldNode enumerateChildNodesWithName:nodeName usingBlock:^(SKNode *node, BOOL *stop) {
        SKAction *moveAction = [node actionForKey:actionName];
        [moveAction setSpeed:speed];
    }];
}

#pragma mark - Boost meter
- (void)adjustBoostMeter:(CGFloat)amount {
    PPBoostMeter *meter = [self currentBoostMeter];
    [meter animateToProgress:(meter.currentProgress + amount)];
}

- (SKAction*)adjustBoostMeterAction:(CGFloat)amount {
    return [SKAction runBlock:^{
        [self adjustBoostMeter:amount];
    }];
}

- (PPBoostMeter*)currentBoostMeter {
    return (PPBoostMeter*)[self.hudNode childNodeWithName:@"boostMeter"];
}

#pragma mark - Snow 
- (SKAction*)snowAccelerationNormal {
    return [SKAction runBlock:^{
        self.snowEmitter.xAcceleration = -10;
    }];
}

- (SKAction*)snowAccelerationBoost {
    return [SKAction runBlock:^{
        self.snowEmitter.xAcceleration = -300;
    }];
}

#pragma mark - Gestures
- (void)addGestureRecognizers {
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe {
    // Make sure swipe occurs during game
    if (!self.gameState == PreGame && !self.gameState == Playing) return;
    if (_gamePaused) return;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_currentParallaxMultiplier == 1) {
            [self boostActionGroup];
        }
    }
}

#pragma mark - Touch Input
- (void)interactionBeganAtPosition:(CGPoint)position {
    if (self.gameState == PreGame) {
        [self gameStart];
    }
    
    if (self.gameState == Playing && !_gamePaused) {
        if (self.worldNode.xScale >= kWorldScaleCap) {
            [[self currentPlayer] setPlayerShouldDive:YES];
        }
    }
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    [[self currentPlayer] setPlayerShouldDive:NO];
    
    if (_gamePaused) {
        [self toggleGamePause];
    }
}

- (void)interactionCancelledAtPosition:(CGPoint)position {
    [[self currentPlayer] setPlayerShouldDive:NO];
}

#pragma mark - Scene Transfer
- (void)loadMenuScene {
    [PPMenuScene loadSceneAssetsWithCompletionHandler:^{
        SKScene *menuScene = [PPMenuScene sceneWithSize:self.size];
        SKTransition *fade = [SKTransition fadeWithColor:[SKColor whiteColor] duration:1];
        [self.view presentScene:menuScene transition:fade];
    }];
}

#pragma mark - Scene Processing
- (void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    
    if (self.gameState == PreGame || self.gameState == Playing) {
        if (_gamePaused) return;

        [self updatePlayer:self.deltaTime];
        [self updateGravity];
        [self updateStarEmitterPosition];
    }
    
    if (self.gameState == Playing) {
        [self checkCoinsDidIntersect];
        [self checkFishDidIntersect];
    }

    //Background
    [self updateParallaxNodesWithTime:self.deltaTime];
    
    //Water surface
    [self trackPlayerForSplash];
    [self.waterSurface update:self.deltaTime];
    
    //Bubbles
    [self trackPlayerForBubbles];
}

- (void)didEvaluateActions {
    if (!(self.gameState == GameOver)) {
    }
}

- (void)didSimulatePhysics {
    if (!(self.gameState == GameOver)) {
        [self updateWorldZoom];
    }
}

#pragma mark - Parallaxing
- (void)updateParallaxNodesWithTime:(NSTimeInterval)dt {
    [self.cloudSlow update:dt];
    [self.cloudFast update:dt];
}

#pragma mark - World Zoom
- (void)updateWorldZoom {
    if ([self playerIsAboveTopBoundary]) {

        [self setNewWorldScaleWithRatio:[self topZoomRatio]];
        [self setNewWorldPositionWithOffset:[self amountToOffsetTop]];
    }
    
    else if ([self playerIsBelowBottomBoundary]) {
//        [self setNewWorldScaleWithRatio:[self bottomZoomRatio]];
//        [self setNewWorldPositionWithOffset:[self amountToOffsetBottom]];
    }
    
    else {
        [self resetWorldZoom];
    }
}

- (void)resetWorldZoom {
    [self.worldNode setScale:1];
    [self.worldNode setPosition:CGPointZero];
}

- (void)setNewWorldScaleWithRatio:(CGFloat)zoomRatio {
    CGFloat newScale = 1 - ([self percentageOfMaxScaleWithRatio:zoomRatio]);
    [self.worldNode setScale:newScale];
}

- (void)setNewWorldPositionWithOffset:(CGVector)amountToOffset {
    [self.worldNode setPosition:CGPointMake(amountToOffset.dx, amountToOffset.dy)];
}

- (CGVector)amountToOffsetTop {
    return CGVectorMake(-([self distanceFromCenterToTopRight].dx * [self percentageOfMaxScaleWithRatio:[self topZoomRatio]]),
                        -([self distanceFromCenterToTopRight].dy * [self percentageOfMaxScaleWithRatio:[self topZoomRatio]]));
}

- (CGVector)amountToOffsetBottom {
    return CGVectorMake(-([self distanceFromCenterToTopRight].dx * [self percentageOfMaxScaleWithRatio:[self bottomZoomRatio]]),
                        [self distanceFromCenterToTopRight].dy * [self percentageOfMaxScaleWithRatio:[self bottomZoomRatio]]);
}

- (CGFloat)topZoomRatio {
    CGFloat ratioDistanceFromTop = fabs(([self currentPlayerDistanceFromTopBoundary]/[self distanceFromBoundaryToMaxZoomBoundary]));
    if (ratioDistanceFromTop > 1) {
        ratioDistanceFromTop = 1;
    }
    return ratioDistanceFromTop;
}

- (CGFloat)bottomZoomRatio {
    CGFloat ratioDistanceFromBottom = fabs(([self currentPlayerDistanceFromBottomBoundary]/[self distanceFromBoundaryToMaxZoomBoundary]));
    if (ratioDistanceFromBottom > 1) {
        ratioDistanceFromBottom = 1;
    }
    return ratioDistanceFromBottom;
}

- (CGVector)distanceFromCenterToTopRight {
    return SSKDistanceBetweenPoints(CGPointZero, CGPointMake(self.size.width/2, self.size.height/2));
}

- (CGFloat)currentPlayerDistanceFromTopBoundary {
    return ([self currentPlayer].position.y - [self topZoomBoundary]);
}

- (CGFloat)currentPlayerDistanceFromBottomBoundary {
    return ([self currentPlayer].position.y - [self bottomZoomBoundary]);
}

- (CGFloat)distanceFromBoundaryToMaxZoomBoundary {
    return (self.size.height - [self topZoomBoundary]);
}

- (CGFloat)topZoomBoundary {
    return self.size.height/5;
}

- (CGFloat)bottomZoomBoundary {
    return -self.size.height/5;
}

- (CGFloat)percentageOfMaxScaleWithRatio:(CGFloat)ratio {
    return ([self scaleCapInversion] * ratio);
}

- (CGFloat)scaleCapInversion {
    return (1 - kWorldScaleCap);
}

- (BOOL)playerIsBelowBottomBoundary {
    return ([self currentPlayer].position.y < [self bottomZoomBoundary]);
}

- (BOOL)playerIsAboveTopBoundary {
    return ([self currentPlayer].position.y > [self topZoomBoundary]);
}

@end
