//
//  PPPlayer.m
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPPlayer.h"
#import "SSKGraphicsUtils.h"

#define kAcceleration 60.0

CGFloat const kIdleFrames = 7;
CGFloat const kSwimFrames = 4;
CGFloat const kFlyFrames = 2;
CGFloat const kDiveFrames = 1;

CGFloat const kAnimationSpeed = 0.05;
CGFloat const kIdleAnimationSpeed = 0.075;

@interface PPPlayer()
@property (nonatomic) CGFloat currentAccelleration;

@property (nonatomic) NSArray *idleTextures;
@property (nonatomic) NSArray *swimTextures;
@property (nonatomic) NSArray *flyTextures;
@property (nonatomic) NSArray *diveTextures;
@end

@implementation PPPlayer
+ (instancetype)playerWithType:(PlayerType)playerType atlas:(SKTextureAtlas*)atlas {
    return [[self alloc] initWithType:playerType atlas:atlas];
}

- (instancetype)initWithType:(PlayerType)playerType atlas:(SKTextureAtlas*)atlas {
    self.playerType = playerType;
    NSString *initialTexture = [NSString stringWithFormat:@"penguin_%@_idle_00",[self playerTypeStringVal:playerType]];
    
    self = [super initWithTexture:[atlas textureNamed:initialTexture]];
    if (self) {
        //Idle
        NSString *baseIdleString = [NSString stringWithFormat:@"penguin_%@_idle_",[self playerTypeStringVal:self.playerType]];
        self.idleTextures = [SSKGraphicsUtils loadFramesFromAtlas:atlas baseFileName:baseIdleString frameCount:kIdleFrames];
        
        //Dive
        NSString *baseDiveString = [NSString stringWithFormat:@"penguin_%@_dive_",[self playerTypeStringVal:self.playerType]];
        self.diveTextures = [SSKGraphicsUtils loadFramesFromAtlas:atlas baseFileName:baseDiveString frameCount:kDiveFrames];

        //Swim
        NSString *baseSwimString = [NSString stringWithFormat:@"penguin_%@_swim_",[self playerTypeStringVal:self.playerType]];
        self.swimTextures = [SSKGraphicsUtils loadFramesFromAtlas:atlas baseFileName:baseSwimString frameCount:kSwimFrames];
        
        //Fly
        NSString *baseFlyString = [NSString stringWithFormat:@"penguin_%@_fly_",[self playerTypeStringVal:self.playerType]];
        self.flyTextures = [SSKGraphicsUtils loadFramesFromAtlas:atlas baseFileName:baseFlyString frameCount:kFlyFrames];
    }
    
    return self;
}

#pragma mark - Physics Body
- (void)createPhysicsBody {
    if (!self.physicsBody) {
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2 - 2];
        [self.physicsBody setDynamic:YES];
        [self.physicsBody setFriction:0];
        [self.physicsBody setRestitution:0];
    }
}

#pragma mark - Rotation
- (void)setPlayerRotation:(NSTimeInterval)dt {
    CGFloat rotateSpeed = .02 * dt;
    [self setZRotation:(M_PI * self.physicsBody.velocity.dy * rotateSpeed) + SSKDegreesToRadians(90)];
    
    //Clamp rotation
    if (self.zRotation >= SSKDegreesToRadians(30)) {
        [self setZRotation:SSKDegreesToRadians(30)];
    }
    
    if (self.zRotation <= SSKDegreesToRadians(150)) {
        [self setZRotation:SSKDegreesToRadians(150)];
    }
}

#pragma mark - Update
- (void)update:(NSTimeInterval)dt {
    
    //Rotation
    if (self.playerShouldRotate) {
        [self setPlayerRotation:dt];
    }

    //Diving Physics
    if (_playerShouldDive) {
        [self.physicsBody setVelocity:CGVectorMake(0, self.physicsBody.velocity.dy - kAcceleration)];
    }
    
    //Animation
    switch (self.playerState) {
        case PlayerStateIdle:
            [self runAnimationWithTextures:self.idleTextures speed:kIdleAnimationSpeed key:@"playerIdle"];
            break;
            
        case PlayerStateDive:
            [self runAnimationWithTextures:self.diveTextures speed:kAnimationSpeed key:@"playerDive"];
            break;
            
        case PlayerStateSwim:
            [self runAnimationWithTextures:self.swimTextures speed:kAnimationSpeed key:@"playerSwim"];
            break;
            
        case PlayerStateFly:
            [self runAnimationWithTextures:self.flyTextures speed:kAnimationSpeed key:@"playerFly"];
            break;
            
        default:
            break;
    }
}

#pragma mark - Player Type String Parsing
- (NSString*)playerTypeStringVal:(PlayerType)playerType {
    NSString *type = nil;
    
    switch (playerType) {
        case PlayerTypeGrey:
            type = @"grey";
            break;
            
        case PlayerTypeBlack:
            type = @"black";
            break;
            
        default:
            type = @"";
            NSLog(@"Player Type not recognized");
            break;
    }
    return type;
}

@end