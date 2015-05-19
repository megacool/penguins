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

- (instancetype)init {
    self = [super initWithTexture:[PPSharedAssets sharedFishTexture]];

    if (self) {
        self.name = kFishName;
        self.colorBlendFactor = 1.0;
        CGFloat randomR = SSKRandomFloatInRange(1, 255);
        CGFloat randomG = SSKRandomFloatInRange(1, 255);
        CGFloat randomB = SSKRandomFloatInRange(1, 255);
        
        // To make the fish have a better random color pallette
        CGFloat mixedB = randomB + 100 / 2;
        
        [self setColor:[SKColor colorWithR:randomR g:randomG b:mixedB]];
    }

    return self;
}

#pragma mark - Fish Actions
- (void)swimForever {
    if ([self actionForKey:kFishActionKey]) return;
    
    CGFloat rotateTime = .2;
    CGFloat moveTime = .4;
    CGFloat rotateDegrees = 20.0;
    CGFloat moveDistance = 30.0;
    
    SKAction *rotateLeft = [SKAction rotateByAngle:SSKDegreesToRadians(-rotateDegrees) duration:rotateTime];
    SKAction *rotateRight = [rotateLeft reversedAction];
    
    SKAction *rotateLeftFast = [SKAction rotateByAngle:SSKDegreesToRadians(-rotateDegrees) duration:rotateTime/2];
    SKAction *rotateRightFast = [rotateLeftFast reversedAction];
    
    SKAction *moveUp = [SKAction moveByX:0 y:moveDistance duration:moveTime];
    [moveUp setTimingMode:SKActionTimingEaseInEaseOut];
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

@end
