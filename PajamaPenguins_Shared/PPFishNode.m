//
//  PPFishNode.m
//  PajamaPenguins
//
//  Created by Skye on 4/28/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPFishNode.h"
#import "PPSharedAssets.h"

NSString * const kFishActionKey = @"fishActionKey";

@implementation PPFishNode

- (instancetype)init {
    self = [super initWithTexture:[[PPSharedAssets sharedFishAtlas] textureNamed:@"fish_background"]];

    if (self) {
    }
    
    return self;
}

#pragma mark - Fish Actions
- (void)swimForever {
    if ([self actionForKey:kFishActionKey]) return;
    
    CGFloat rotateTime = .2;
    CGFloat moveTime = .4;
    CGFloat rotateDegrees = 35.0;
    CGFloat moveDistance = 40.0;
    
    SKAction *rotateLeft = [SKAction rotateByAngle:SSKDegreesToRadians(-rotateDegrees) duration:rotateTime];
    SKAction *rotateRight = [rotateLeft reversedAction];
    
    SKAction *rotateLeftFast = [SKAction rotateByAngle:SSKDegreesToRadians(-rotateDegrees) duration:rotateTime/2];
    SKAction *rotateRightFast = [rotateLeftFast reversedAction];
    
    SKAction *moveUp = [SKAction moveByX:0 y:moveDistance duration:moveTime];
    SKAction *moveDown = [moveUp reversedAction];
    
    SKAction *swimDownGroup = [SKAction group:@[rotateLeft, moveDown]];
    SKAction *swimUpGroup = [SKAction group:@[rotateRight, moveUp]];
    
    SKAction *swimForeverSequence = [SKAction repeatActionForever:[SKAction sequence:@[swimUpGroup,rotateLeftFast,swimDownGroup,rotateRightFast]]];
    
    [self runAction:swimForeverSequence withKey:kFishActionKey];
}

@end
