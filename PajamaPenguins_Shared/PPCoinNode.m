//
//  PPCoinNode.m
//  PajamaPenguins
//
//  Created by Skye on 4/29/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPCoinNode.h"
#import "SSKGraphicsUtils.h"
#import "PPSharedAssets.h"

NSUInteger const kCoinFrames = 6;
NSString * const kCoinAnimationKey = @"coinAnimation";

CGFloat const kCoinAnimationSpeed = 0.075;

@interface PPCoinNode()
@property (nonatomic) NSArray *coinTextures;
@end

@implementation PPCoinNode

- (instancetype)init {
    self = [super initWithTexture:[[PPSharedAssets sharedCoinTextures] objectAtIndex:0]];
    if (self) {
        self.size = CGSizeMake(self.size.width/3 * 2, self.size.height/3 * 2);
    }
    
    return self;
}

#pragma mark - Animations
- (void)spinAnimation {
    if ([self actionForKey:kCoinAnimationKey]) return;
    
    SKAction *animation = [SKAction animateWithTextures:[PPSharedAssets sharedCoinTextures] timePerFrame:kCoinAnimationSpeed];
    [self runAction:[SKAction repeatActionForever:animation] withKey:kCoinAnimationKey];
}

@end
