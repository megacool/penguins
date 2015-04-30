//
//  PPSprite.m
//  PajamaPenguins
//
//  Created by Skye on 4/9/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSprite.h"
#import "UIDevice+SFAdditions.h"

@implementation PPSprite

- (instancetype)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    if (self) {
        self.size = [self getSize];
    }
    return self;
}

#pragma mark - Automate screen sizes
- (CGSize)getSize {
    CGSize oldNodeSize = self.size;
    CGSize newNodeSize;
    
    if ([UIDevice isUserInterfaceIdiomPhone]) {
        newNodeSize = CGSizeMake(oldNodeSize.width/3, oldNodeSize.height/3);
    }
    
    else if ([UIDevice isUserInterfaceIdiomPad]) {
        newNodeSize = CGSizeMake(oldNodeSize.width * 0.8, oldNodeSize.height * 0.8);
    }
    
    return newNodeSize;
};

#pragma mark - Animation
- (void)runAnimationWithTextures:(NSArray*)textures speed:(CGFloat)speed key:(NSString*)key {
    SKAction *animation = [self actionForKey:key];
    if (animation || [textures count] < 1) return;
    
    [self runAction:[SKAction animateWithTextures:textures timePerFrame:speed] withKey:key];
}

@end
