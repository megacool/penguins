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
        
        PPSprite *cloudTallOne = [PPSprite spriteNodeWithTexture:cloudTexture];
        [cloudTallOne setAlpha:0.4];
        [cloudTallOne setPosition:CGPointMake(size.width/3, size.height/2)];
        
        PPSprite *cloudTallTwo = cloudTallOne.copy;
        [cloudTallTwo setPosition:CGPointMake(-size.width/4, size.height/3)];

        PPSprite *cloudTallThree = cloudTallOne.copy;
        [cloudTallThree setPosition:CGPointMake(-size.width/2, size.height)];
        
        PPSprite *cloudTallFour = cloudTallOne.copy;
        [cloudTallFour setPosition:CGPointMake(-size.width/8, size.height/4 * 3)];

        
        self.parallaxLayer = [SSKParallaxNode nodeWithSize:size attachedNodes:@[cloudTallOne,cloudTallTwo,cloudTallThree,cloudTallFour] moveSpeed:CGPointMake(-22.5, 0)];
        self.parallaxLayer.zPosition = 0;
        [self addChild:self.parallaxLayer];
    }
    
    return self;
}

@end
