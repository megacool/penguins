//
//  PPFishNode.m
//  PajamaPenguins
//
//  Created by Skye on 4/28/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPFishNode.h"
#import "SSKMathUtils.h"
#import "SKColor+SFAdditions.h"
#import "PPSharedAssets.h"

NSString * const kFishName = @"fishName";
NSString * const kFishActionKey = @"fishActionKey";

@implementation PPFishNode

- (instancetype)initWithType:(FishType)fishType {
    self = [super initWithTexture:[self textureForType:fishType]];

    if (self) {
        self.fishType = fishType;
        self.name = kFishName;
    }

    return self;
}

#pragma mark - Fish Actions
- (void)swimForever {
    if ([self actionForKey:kFishActionKey]) return;
    
    CGFloat rotateTime = .15;
    CGFloat moveTime = .25;
    CGFloat rotateDegrees = 15.0;
    CGFloat moveDistance = 20.0;
    
    SKAction *rotateLeft = [SKAction rotateByAngle:SSKDegreesToRadians(-rotateDegrees) duration:rotateTime];
    SKAction *rotateRight = [rotateLeft reversedAction];
    
    SKAction *rotateLeftFast = [SKAction rotateByAngle:SSKDegreesToRadians(-rotateDegrees) duration:rotateTime/2];
    SKAction *rotateRightFast = [rotateLeftFast reversedAction];
    
    SKAction *moveUp = [SKAction moveByX:0 y:moveDistance duration:moveTime];
    SKAction *moveDown = [moveUp reversedAction];
    
    SKAction *swimDownGroup;
    SKAction *swimUpGroup;
    SKAction *swimForeverSequence;
    
    if (self.xScale > 0) {
        swimUpGroup = [SKAction group:@[rotateRight, moveUp]];
        swimDownGroup = [SKAction group:@[rotateLeft, moveDown]];
        swimForeverSequence = [SKAction repeatActionForever:[SKAction sequence:@[swimUpGroup,rotateLeftFast,swimDownGroup,rotateRightFast]]];
    } else {
        swimUpGroup = [SKAction group:@[rotateLeft, moveUp]];
        swimDownGroup = [SKAction group:@[rotateRight, moveDown]];
        swimForeverSequence = [SKAction repeatActionForever:[SKAction sequence:@[swimUpGroup,rotateRightFast,swimDownGroup,rotateLeftFast]]];
    }
    
    [self runAction:swimForeverSequence withKey:kFishActionKey];
}

#pragma mark - Setter Override
- (void)setFishType:(FishType)fishType {
    [self setTexture:[self textureForType:fishType]];
}

#pragma mark - Fish Type
- (SKTexture*)textureForType:(FishType)fishType {
    if (fishType == FishTypeBlue) {
        return [PPSharedAssets sharedFishBlueTexture];
    }
    else if (fishType == FishTypeGreen) {
        return [PPSharedAssets sharedFishGreenTexture];
    }
    else if (fishType == FishTypeMaroon) {
        return [PPSharedAssets sharedFishMaroonTexture];
    }
    else {
        return [PPSharedAssets sharedFishRedTexture];
    }
}

@end
