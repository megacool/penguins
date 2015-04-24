//
//  PPWaterSprite.m
//  PajamaPenguins
//
//  Created by Skye on 4/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPWaterSprite.h"
#import "PPSharedAssets.h"

@implementation PPWaterSprite
+ (instancetype)surfaceWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint depth:(CGFloat)depth {
    return [[self alloc] initWithStartPoint:startPoint endPoint:endPoint depth:depth];
}

- (instancetype)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint depth:(CGFloat)depth {
    self = [super initWithStartPoint:startPoint endPoint:endPoint depth:depth texture:[PPSharedAssets sharedWaterTexture]];
    if (self) {
        [self setSplashDamping:.05];
        [self setSplashTension:.005];
        
        [self setAlpha:.5];
    }
    return self;
}

@end
