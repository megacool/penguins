//
//  PPCloudParallaxSlow.m
//  PajamaPenguins
//
//  Created by Skye on 4/9/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPCloudParallaxSlow.h"
#import "PPSprite.h"
#import "PPSharedAssets.h"


@implementation PPCloudParallaxSlow

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        SKTexture *cloudTexture = [[PPSharedAssets sharedCloudAtlas] textureNamed:@"cloud_01"];
        
        PPSprite *cloudWideHigh = [PPSprite spriteNodeWithTexture:cloudTexture];
        [cloudWideHigh setAlpha:0.25];
        [cloudWideHigh setPosition:CGPointMake(-size.width/5, size.height/6)];
        
        PPSprite *cloudWideLow = cloudWideHigh.copy;
        [cloudWideLow setPosition:CGPointMake(size.width/3, size.height/8)];
        
        self.parallaxLayer = [SSKParallaxNode nodeWithSize:size attachedNodes:@[cloudWideHigh,cloudWideLow] moveSpeed:CGPointMake(-7.5,0)];
        self.parallaxLayer.zPosition = 0 ;
        [self addChild:self.parallaxLayer];
    }
    
    return self;
}

@end
