//
//  PPCloudParallaxFast.m
//  PajamaPenguins
//
//  Created by Skye on 4/9/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPCloudParallaxFast.h"
#import "PPSprite.h"
#import "PPSharedAssets.h"

@implementation PPCloudParallaxFast

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        SKTexture *cloudTexture = [[PPSharedAssets sharedCloudAtlas] textureNamed:@"cloud_00"];
        
        PPSprite *cloudTallHigh = [PPSprite spriteNodeWithTexture:cloudTexture];
        [cloudTallHigh setAlpha:0.4];
        [cloudTallHigh setPosition:CGPointMake(-size.width/3, size.height/2)];
        
        PPSprite *cloudTallLow = cloudTallHigh.copy;
        [cloudTallLow setPosition:CGPointMake(size.width/4, size.height/4)];
        
        self.parallaxLayer = [SSKParallaxNode nodeWithSize:size attachedNodes:@[cloudTallHigh,cloudTallLow] moveSpeed:CGPointMake(-15, 0)];
        self.parallaxLayer.zPosition = 0;
        [self addChild:self.parallaxLayer];
    }
    
    return self;
}

@end
