//
//  PPPlayer.h
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PPSprite.h"

typedef NS_ENUM(NSUInteger, PlayerType) {
    PlayerTypeGrey = 0,
    PlayerTypeBlack,
};

typedef NS_ENUM(NSUInteger, PlayerState) {
    PlayerStateIdle = 0,
    PlayerStateDive,
    PlayerStateSwim,
    PlayerStateFly,
};

@interface PPPlayer : PPSprite
+ (instancetype)playerWithType:(PlayerType)playerType atlas:(SKTextureAtlas*)atlas;
- (instancetype)initWithType:(PlayerType)playerType atlas:(SKTextureAtlas*)atlas;

- (void)createPhysicsBody;

- (void)update:(NSTimeInterval)dt;

@property (nonatomic) PlayerState playerState;
@property (nonatomic) PlayerType playerType;

@property (nonatomic) BOOL playerShouldDive;
@property (nonatomic) BOOL playerShouldRotate;
@property (nonatomic) BOOL playerShouldAnimate;
@end
