//
//  PPWaterSprite.m
//  PajamaPenguins
//
//  Created by Skye on 4/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPWaterSprite.h"
#import "SKTexture+SFAdditions.h"
#import "SKColor+SFAdditions.h"

#define kStartColor [SKColor colorWithR:0 g:57 b:161]
#define kEndColor [SKColor colorWithR:0 g:167 b:255]

@implementation PPWaterSprite
+ (instancetype)surfaceWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint depth:(CGFloat)depth {
    return [[self alloc] initWithStartPoint:startPoint endPoint:endPoint depth:depth];
}

- (instancetype)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint depth:(CGFloat)depth {
    CGSize bodySize = CGSizeMake(endPoint.x - startPoint.x, depth);
    SKTexture *gradient = [SKTexture textureWithGradientOfSize:bodySize startColor:kStartColor endColor:kEndColor direction:GradientDirectionVertical];
    self = [super initWithStartPoint:startPoint endPoint:endPoint depth:depth texture:gradient];
    if (self) {
        [self setSplashDamping:.05];
        [self setSplashTension:.005];
        
        [self setAlpha:.75];
    }
    return self;
}

@end
