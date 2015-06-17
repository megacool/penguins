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
        
        PPSprite *cloudWideOne = [PPSprite spriteNodeWithTexture:cloudTexture];
        [cloudWideOne setAlpha:0.25];
        [cloudWideOne setPosition:CGPointMake(-size.width/5, size.height/5)];
        
        PPSprite *cloudWideTwo = cloudWideOne.copy;
        [cloudWideTwo setPosition:CGPointMake(size.width/4, size.height/10)];
        
        self.parallaxLayer = [SSKParallaxNode nodeWithSize:size attachedNodes:@[cloudWideOne,cloudWideTwo] moveSpeed:CGPointMake(-7.5,0)];
        self.parallaxLayer.zPosition = 0 ;
        [self addChild:self.parallaxLayer];
    }
    
    return self;
}

@end
