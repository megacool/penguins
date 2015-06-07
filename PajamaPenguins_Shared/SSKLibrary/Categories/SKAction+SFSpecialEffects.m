//
//  SKAction+SFSpecialEffects.m
//  PajamaPenguins
//
//  Created by Skye on 6/6/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SKAction+SFSpecialEffects.h"

@implementation SKAction (SFSpecialEffects)

+ (SKAction*)shakeWithDuration:(CGFloat)duration amplitude:(CGPoint)amp {
    CGFloat shakeDuration = 0.015;
    CGFloat numberOfShakes = duration/shakeDuration/2.0;
    
    NSMutableArray *actions = [NSMutableArray array];
    for (int i = 0; i < numberOfShakes; i++) {
        CGFloat randX = arc4random_uniform(amp.x) - amp.x/2;
        CGFloat randY = arc4random_uniform(amp.y) - amp.y/2;
        SKAction *shake = [SKAction moveBy:CGVectorMake(randX, randY) duration:shakeDuration];
        SKAction *reverseShake = [shake reversedAction];
        [actions addObject:shake];
        [actions addObject:reverseShake];
    }
    
    return [SKAction sequence:actions];
}

@end
