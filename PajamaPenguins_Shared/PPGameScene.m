//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPMenuScene.h"
#import "PPSharedAssets.h"
#import "PPPlayer.h"
#import "PPIcebergObstacle.h"
#import "PPSkySprite.h"
#import "PPWaterSprite.h"
#import "PPCloudParallaxSlow.h"
#import "PPCloudParallaxFast.h"
#import "PPUserManager.h"

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

typedef enum {
    backgroundLayer,
    parallaxLayer,
    obstacleLayer,
    foregroundLayer,
    playerLayer,
    waterSurfaceLayer,
    bubbleLayer,
    hudLayer,
    gameOverLayer,
    buttonLayer,
    fadeOutLayer,
}Layers;

//Texture Constants
CGFloat const kLargeTileWidth  = 30.0;
CGFloat const kSmallTileWidth  = 15.0;
CGFloat const kBackgroundAlpha = 0.55;

//Physics Constants
static const uint32_t playerCategory   = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t edgeCategory     = 0x1 << 2;

CGFloat const kAirGravityStrength      = -2.75;
CGFloat const kWaterGravityStrength    = 6;
CGFloat const kGameOverGravityStrength = -9.8;

CGFloat const kObstacleSplashStrength = 10;
CGFloat const kMaxSplashStrength      = 20;

//Clamped Constants
CGFloat const kMaxBreathTimer = 6.0;
CGFloat const kWorldScaleCap  = 0.55;

CGFloat const kPlayerUpperVelocityLimit      = 700.0;
CGFloat const kPlayerLowerAirVelocityLimit   = -700.0;
CGFloat const kPlayerLowerWaterVelocityLimit = -550.0;

//Name Constants
NSString * const kPixelFontName = @"Fipps-Regular";

//Action Constants
CGFloat const kMoveAndFadeTime     = 0.2;
CGFloat const kMoveAndFadeDistance = 20;

//Parallax Constants
CGFloat const kParallaxMinSpeed = -20.0;

@interface PPGameScene()
@property (nonatomic) GameState gameState;

@property (nonatomic) PPCloudParallaxSlow *cloudSlow;
@property (nonatomic) PPCloudParallaxFast *cloudFast;

@property (nonatomic) PPSkySprite *skySprite;
@property (nonatomic) PPWaterSprite *waterSurface;

@property (nonatomic) NSMutableArray *obstacleTexturePool;
@property (nonatomic) SKEmitterNode *snowEmitter;

@property (nonatomic) SKNode *worldNode;
@property (nonatomic) SKNode *hudNode;
@property (nonatomic) SKNode *gameOverNode;
@end

@implementation PPGameScene {
    NSTimeInterval _lastUpdateTime;
    CGFloat _lastPlayerHeight;
    CGFloat _breathTimer;
    
    CGFloat _playerBubbleBirthrate;
}

- (instancetype)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
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
    [self setBackgroundColor:[SKColor whiteColor]];
    
    //Sky
    self.skySprite = [PPSkySprite spriteWithSize:CGSizeMake(self.size.width * 3, self.size.height * 2) skyType:SkyTypeDay];
    [self.skySprite setPosition:CGPointMake(0, -self.size.height/2)];
    [self.worldNode addChild:self.skySprite];

    //Parallaxing Nodes
    self.cloudSlow = [[PPCloudParallaxSlow alloc] initWithSize:self.size];
    self.cloudSlow.zPosition = parallaxLayer;
    [self.worldNode addChild:self.cloudSlow];
    
    self.cloudFast = [[PPCloudParallaxFast alloc] initWithSize:self.size];
    self.cloudFast.zPosition = parallaxLayer;
    [self.worldNode addChild:self.cloudFast];
    
    //Snow Emitter
    self.snowEmitter = [PPSharedAssets sharedSnowEmitter].copy;
    [self.snowEmitter setZPosition:foregroundLayer];
    [self.snowEmitter setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [self.snowEmitter setName:@"snowEmitter"];
    [self addChild:self.snowEmitter];

    //Water Surface
    CGPoint surfaceStart = CGPointMake(-self.size.width/2, 0);
    CGPoint surfaceEnd = CGPointMake(self.size.width/kWorldScaleCap, 0);
    
    self.waterSurface = [PPWaterSprite surfaceWithStartPoint:surfaceStart endPoint:surfaceEnd depth:self.size.height/2];
    [self.waterSurface setName:@"water"];
    [self.waterSurface setZPosition:waterSurfaceLayer];
    [self.worldNode addChild:self.waterSurface];

    //Player
    PPPlayer *player = [self blackPenguin];
    [self.worldNode addChild:player];
    
    //Setting Players initial position height (for water surface tracking)
    _lastPlayerHeight = player.position.y;
    
    //Player's bubble emitter
    SKNode *bubbleTarget = [SKNode new];
    [bubbleTarget setZPosition:bubbleLayer];
    [self addChild:bubbleTarget];
    
    SKEmitterNode *playerBubbleEmitter = [PPSharedAssets sharedBubbleEmitter].copy;
    [playerBubbleEmitter setName:@"bubbleEmitter"];
    [playerBubbleEmitter setZPosition:self.waterSurface.zPosition + 1];
    [playerBubbleEmitter setTargetNode:bubbleTarget];
    [self.worldNode addChild:playerBubbleEmitter];
    
    _playerBubbleBirthrate = playerBubbleEmitter.particleBirthRate; //To reset the simulation
    
    //Screen Physics Boundary
    SKSpriteNode *boundary = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.size.width,self.size.height)];
    boundary.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:boundary.frame];
    [boundary.physicsBody setFriction:0];
    [boundary.physicsBody setRestitution:0];
    [boundary.physicsBody setCategoryBitMask:edgeCategory];
    [self addChild:boundary];
}

#pragma mark - HUD layer
- (void)createHudLayer {
    self.hudNode = [SKNode new];
    [self.hudNode setZPosition:hudLayer];
    [self.hudNode setName:@"hud"];
    [self.hudNode setAlpha:0];
    [self.hudNode setPosition:CGPointMake(-kMoveAndFadeDistance, 0)];
    [self addChild:self.hudNode];
    
    SSKScoreNode *scoreCounter = [SSKScoreNode scoreNodeWithFontNamed:@"AmericanTypewriter" fontSize:12 fontColor:[SKColor blackColor]];
    [scoreCounter setName:@"scoreCounter"];
    [scoreCounter setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [scoreCounter setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    [scoreCounter setPosition:CGPointMake(-self.size.width/2 + 5, self.size.height/2 - 5)];
    [self.hudNode addChild:scoreCounter];
    
    SSKProgressBarNode *breathMeter = [[SSKProgressBarNode alloc] initWithFrameColor:[SKColor blackColor] barColor:[SKColor redColor] size:CGSizeMake(150, 20)];
    [breathMeter setName:@"progressBar"];
    [breathMeter setPosition:CGPointMake(0, self.size.height/2 - 20)];
    [self.hudNode addChild:breathMeter];
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
    [self.gameOverNode setZPosition:gameOverLayer];
    [self.gameOverNode setName:@"gameOver"];
    [self.gameOverNode setAlpha:0];
    [self.gameOverNode setPosition:CGPointMake(-kMoveAndFadeDistance, 0)];
    [self addChild:self.gameOverNode];
    
    // Game over text label
    SKLabelNode *gameOverLabel = [self createNewLabelWithText:@"Game Over" withFontSize:40];
    [gameOverLabel setFontColor:[SKColor colorWithR:150 g:5 b:5]];
    [gameOverLabel setPosition:CGPointMake(0, self.size.height/3)];
    [self.gameOverNode addChild:gameOverLabel];
    
    // Score string
    NSString *currentScoreString = [(SSKScoreNode*)[self.hudNode childNodeWithName:@"scoreCounter"] text];
    
    // Score label
    SKLabelNode *scoreLabel = [self createNewLabelWithText:[NSString stringWithFormat:@"%@ meters.",currentScoreString] withFontSize:30];
    [scoreLabel setPosition:CGPointMake(gameOverLabel.position.x, gameOverLabel.position.y - 50)];
    [self.gameOverNode addChild:scoreLabel];
    
    // Buttons
    [self.gameOverNode addChild:[self menuButton]];
    [self.gameOverNode addChild:[self retryButton]];
}

- (void)gameOverFadeInAnimation {
    [self.gameOverNode runAction:[SKAction moveDistance:CGVectorMake(kMoveAndFadeDistance, 0) fadeInWithDuration:kMoveAndFadeTime]];
}

#pragma mark - GameState Playing
- (void)gameStart {
    self.gameState = Playing;

    [self runAction:[SKAction fadeOutWithDuration:.5] onNode:[self childNodeWithName:@"menu"]];
    
    [self resetBreathTimer];
    [self createHudLayer];
    [self hudLayerFadeInAnimation];
    
    [self populateObstacleTexturePool];
    [self startObstacleSpawnSequence];
    
    [self startScoreCounter];
}

- (void)startGameAnimations {
    [self runAction:[SKAction waitForDuration:.5] completion:^{
    }];
}

#pragma mark - GameState GameOver
- (void)gameEnd {
    self.gameState = GameOver;
    
    [self stopScoreCounter];
    [self checkIfHighScore];
    
    [self stopObstacleSpawnSequence];
    [self stopObstacleMovement];
    [self stopObstacleSplash];
    
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
    [fadeNode setZPosition:fadeOutLayer];
    [fadeNode setAlpha:0];
    [self addChild:fadeNode];
    
    [fadeNode runAction:[SKAction fadeInWithDuration:.8] completion:^{
//        [self.worldNode removeFromParent];
//        [self.hudNode removeFromParent];
//        [self.gameOverNode removeFromParent];
        [self removeAllChildrenOfScene];
        [self createNewGame];
        [fadeNode runAction:[SKAction fadeOutWithDuration:.5] completion:^{
            [fadeNode removeFromParent];
        }];
    }];
    
    NSLog(@"%@",[[PPUserManager sharedManager] getHighScore]);
}

#pragma mark - Buttons
- (SSKButtonNode*)gameButtonNodeWithText:(NSString*)text {
    SSKButtonNode *button = [SSKButtonNode buttonWithCircleOfRadius:45 idleFillColor:[SKColor clearColor] selectedFillColor:[SKColor whiteColor] labelWithText:text];
    [button.idleShape setStrokeColor:[SKColor whiteColor]];
    [button.selectedShape setStrokeColor:[SKColor whiteColor]];
    [button setIdleLabelColor:[SKColor whiteColor]];
    [button setSelectedLabelColor:[SKColor blueColor]];
    [button setZPosition:buttonLayer];
    return button;
}

- (SSKButtonNode*)menuButton {
    SSKButtonNode *menuButton = [self gameButtonNodeWithText:@"Menu"];
    [menuButton setTouchUpInsideTarget:self selector:@selector(loadMenuScene)];
    [menuButton setPosition:CGPointMake(self.size.width/5, -self.size.height/4)];
    return menuButton;
}

- (SSKButtonNode*)retryButton {
    SSKButtonNode *retryButton = [self gameButtonNodeWithText:@"Retry"];
    [retryButton setTouchUpInsideTarget:self selector:@selector(resetGame)];
    [retryButton setPosition:CGPointMake(-self.size.width/5, -self.size.height/4)];
    return retryButton;
}

#pragma mark - Breath Meter
- (void)updateBreathMeter {
    [(SSKProgressBarNode*)[self.hudNode childNodeWithName:@"progressBar"] setProgress:_breathTimer/kMaxBreathTimer];
}

- (void)checkBreathMeterForGameOver {
    if ([(SSKProgressBarNode*)[self.hudNode childNodeWithName:@"progressBar"] currentProgress] == 0.0) {
        [self gameEnd];
    }
}

- (void)resetBreathTimer {
    _breathTimer = kMaxBreathTimer;
}

- (void)updateBreathTimer:(NSTimeInterval)dt {
    if ([self currentPlayer].position.y < [self.worldNode childNodeWithName:@"water"].position.y) {
        _breathTimer -= dt;
    } else {
        _breathTimer += dt;
    }
    
    if (_breathTimer < 0.0) {
        _breathTimer = 0.0;
    }
    else if (_breathTimer > kMaxBreathTimer) {
        _breathTimer = kMaxBreathTimer;
    }
}

#pragma mark - Penguin Types
- (PPPlayer*)penguinWithType:(PlayerType)type atlas:(SKTextureAtlas*)atlas {
    PPPlayer *penguin = [PPPlayer playerWithType:type atlas:atlas];
    [penguin setPosition:CGPointMake(-self.size.width/4, 50)];
    [penguin setName:@"player"];
    [penguin setZRotation:SSKDegreesToRadians(90)];
    [penguin setZPosition:playerLayer];
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
    [player.physicsBody applyImpulse:CGVectorMake(1, 70)];
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
- (void)trackPlayerForSplash {
    CGFloat newPlayerHeight = [self currentPlayer].position.y;
    
    //Cross surface from bottom
    if (_lastPlayerHeight < 0 && newPlayerHeight > 0) {
        CGFloat splashRatio = [self currentPlayer].physicsBody.velocity.dy / kPlayerUpperVelocityLimit;
        CGFloat splashStrength = kMaxSplashStrength * splashRatio;
        
        [self.waterSurface splash:[self currentPlayer].position speed:splashStrength];
        [self runOneShotEmitter:[PPSharedAssets sharedPlayerSplashUpEmitter] location:[self currentPlayer].position];
        
        _lastPlayerHeight = newPlayerHeight;
    }
    //Cross surface from top
    else if (_lastPlayerHeight > 0 && newPlayerHeight < 0) {
        CGFloat splashRatio = [self currentPlayer].physicsBody.velocity.dy / kPlayerLowerAirVelocityLimit;
        CGFloat splashStrength = kMaxSplashStrength * splashRatio;
        
        [self.waterSurface splash:[self currentPlayer].position speed:-splashStrength];
        [self runOneShotEmitter:[PPSharedAssets sharedPlayerSplashDownEmitter] location:[self currentPlayer].position];
        
        _lastPlayerHeight = newPlayerHeight;
    }
}

- (void)startSplashAtObstaclesForever {
    if ([self actionForKey:@"obstacleSplash"]) {
        NSLog(@"An action with name obstacleSplash is already active");
        return;
    }
    
    SKAction *splashBlock = [SKAction runBlock:^{
        [self.worldNode enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
            PPIcebergObstacle *obstacle = (PPIcebergObstacle*)node;
            CGPoint splashLocation = CGPointMake(obstacle.position.x - obstacle.frame.size.width/2, obstacle.position.y);
            
            [self.waterSurface splash:splashLocation speed:kObstacleSplashStrength];
            [self runOneShotEmitter:[PPSharedAssets sharedObstacleSplashEmitter] location:CGPointMake(splashLocation.x, splashLocation.y + 30)];
        }];
    }];
    
    SKAction *wait = [SKAction waitForDuration:.4];
    SKAction *sequence = [SKAction sequence:@[wait,splashBlock]];
    [self runAction:[SKAction repeatActionForever:sequence] withKey:@"obstacleSplash"];
    
}

- (void)stopObstacleSplash {
    [self removeActionForKey:@"obstacleSplash"];
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


#pragma mark - Emitters
- (void)runOneShotEmitter:(SKEmitterNode*)emitter location:(CGPoint)location {
    SKEmitterNode *splashEmitter = emitter.copy;
    [splashEmitter setPosition:location];
    [splashEmitter setZPosition:waterSurfaceLayer];
    [self.worldNode addChild:splashEmitter];
    [SSKGraphicsUtils runOneShotActionWithEmitter:splashEmitter duration:0.15];
}

- (SKEmitterNode*)playerBubbleEmitter {
    return (SKEmitterNode*)[self.worldNode childNodeWithName:@"bubbleEmitter"];
}

#pragma mark - Icebergs
- (PPIcebergObstacle*)newIceBergWithTexture:(SKTexture*)texture {
    PPIcebergObstacle *obstacle = [PPIcebergObstacle spriteNodeWithTexture:texture];
    [obstacle setName:@"obstacle"];
    [obstacle setZPosition:obstacleLayer];
    [obstacle.physicsBody setCategoryBitMask:obstacleCategory];
    return obstacle;
}

- (SKNode*)newObstacle {
    PPIcebergObstacle *newObstacle = [self newIceBergWithTexture:[[PPSharedAssets sharedIcebergAtlas] textureNamed:@"iceberg_morning"]];
    [newObstacle setPosition:CGPointMake((self.size.width/kWorldScaleCap) + newObstacle.size.width/2, newObstacle.size.height / 10)];
    return newObstacle;
}

- (SKNode*)generateNewRandomObstacle {
    CGFloat randomNum = SSKRandomFloatInRange(0, self.obstacleTexturePool.count);
    SKTexture *randomTexture = [self.obstacleTexturePool objectAtIndex:randomNum];
    
    PPIcebergObstacle *newIceberg = [self newIceBergWithTexture:randomTexture];
    [newIceberg setPosition:CGPointMake((self.size.width/kWorldScaleCap) + newIceberg.size.width/2, 0)];
    return newIceberg;
}

- (void)populateObstacleTexturePool {
    self.obstacleTexturePool = nil;
    self.obstacleTexturePool = [NSMutableArray new];
    
//    [self.obstacleTexturePool addObject:[PPSharedAssets sharedObstacleMediumTexture]];
//    [self.obstacleTexturePool addObject:[PPSharedAssets sharedObstacleLargeTexture]];
}

#pragma mark - Obstacle Spawn Sequence
- (void)startObstacleSpawnSequence {
    SKAction *wait = [SKAction waitForDuration:1.5];
    SKAction *spawnFloatMove = [SKAction runBlock:^{
//        SKNode *obstacle = [self generateNewRandomObstacle];
        SKNode *obstacle = [self newObstacle];
        [self.worldNode addChild:obstacle];
        [obstacle runAction:[SKAction repeatActionForever:[self floatAction]]];
        [obstacle runAction:[SKAction moveToX:-self.size.width duration:4] withKey:@"moveObstacle" completion:^{
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
        [node removeActionForKey:@"moveObstacle"];
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
    NSInteger currentScore = [(SSKScoreNode*)[self.hudNode childNodeWithName:@"scoreCounter"] score];
    NSInteger highScore = [[PPUserManager sharedManager] getHighScore].integerValue;
    
    if (currentScore > highScore) {
        [[PPUserManager sharedManager] saveHighScore:[NSNumber numberWithInteger:currentScore]];
        [self isNewHighScore];
    }
}

- (void)isNewHighScore {
    SKLabelNode *highScoreLabel = [self createNewLabelWithText:@"Highscore!" withFontSize:20];
    [highScoreLabel setZRotation:SSKDegreesToRadians(35.0)];
    [highScoreLabel setFontColor:[SKColor redColor]];
    [highScoreLabel setZPosition:gameOverLayer];
    [highScoreLabel setPosition:CGPointMake(self.size.width/3, self.size.height/3 + 25)];
    [self addChild:highScoreLabel];
    
    [self runColorChangeOnLabel:highScoreLabel interval:.35];
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

- (CGFloat)getWaterSurfaceScale {
    CGFloat waterWidth = self.size.width/5;
    return (waterWidth/kLargeTileWidth);
}

#pragma mark - Remove all nodes 
- (void)removeAllChildrenOfScene {
    for (SKNode* node in self.children) {
        for (SKNode *child in node.children) {
            [child removeFromParent];
        }
        [node removeFromParent];
    }
}

#pragma mark - Collisions
- (void)resolveCollisionFromFirstBody:(SKPhysicsBody *)firstBody secondBody:(SKPhysicsBody *)secondBody {
    if (self.gameState == Playing) {
        [self gameEnd];
    }
}

#pragma mark - Input
- (void)interactionBeganAtPosition:(CGPoint)position {
    if (self.gameState == PreGame) {
        [self gameStart];
    }
    
    if (self.gameState == Playing) {
        if (self.worldNode.xScale >= kWorldScaleCap) {
            [[self currentPlayer] setPlayerShouldDive:YES];
        }
    }
}

- (void)interactionEndedAtPosition:(CGPoint)position {
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
        [self updatePlayer:self.deltaTime];
        [self updateGravity];
    }
    
    if (self.gameState == Playing) {
        [self updateBreathTimer:self.deltaTime];
        [self updateBreathMeter];
        [self checkBreathMeterForGameOver];
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
