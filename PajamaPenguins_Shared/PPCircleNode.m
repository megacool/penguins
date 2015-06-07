//
//  PPCircleNode.m
//  PajamaPenguins
//
//  Created by Skye on 6/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPCircleNode.h"

@implementation PPCircleNode

- (void)expandAndFade {
    if ([self actionForKey:@"expandAndFadeKey"]) return;
    
    CGFloat duration = 0.3;
    
    SKAction *expand = [SKAction scaleTo:5 duration:duration];
    [expand setTimingMode:SKActionTimingEaseOut];
    
    SKAction *fade = [SKAction fadeOutWithDuration:duration];
    [fade setTimingMode:SKActionTimingEaseOut];
    
    SKAction *remove = [SKAction runBlock:^{
        [self removeFromParent];
    }];
    
    SKAction *group = [SKAction group:@[expand,fade]];
    
    [self runAction:[SKAction sequence:@[group,remove]] withKey:@"expandAndFadeKey"];
}

@end
