//
//  PPBoostMeter.m
//  PajamaPenguins
//
//  Created by Skye on 5/28/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPBoostMeter.h"
#import "SKColor+SFAdditions.h"

@implementation PPBoostMeter

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithFrameColor:[SKColor whiteColor] barColor:[SKColor boostMeterColor] size:size barType:BarTypeVertical];
    if (self) {
        self.barBackground.color = [SKColor whiteColor];
        self.barBackground.alpha = 0.65;
    }
    
    return self;
}

#pragma mark - Segment Decrease
- (void)animateToProgress:(CGFloat)newProgress {
    [self removeActionForKey:@"barAnimating"];
    
    CGFloat currentProgress = self.currentProgress;
    CGFloat difference = (currentProgress - newProgress) * -1;

    CGFloat animationTime = fabs(difference * 2); // 1.0 == 2 seconds, 0.5 = 1 second etc...
    CGFloat intervals = fabs(difference/0.01);
    
    NSMutableArray *actions = [NSMutableArray new];
    for (int i = 0; i < intervals; i++) {
        
        // Adjust current progress by 1 percent per interval
        if (currentProgress > newProgress) {
            currentProgress = currentProgress - 0.01;
        } else {
            currentProgress = currentProgress + 0.01;
        }
        
        // Set new progress from interval
        SKAction *block = [self setProgressAction:currentProgress];
        
        // Wait a segment of the animation time
        SKAction *wait = [SKAction waitForDuration:animationTime/intervals];
        
        [actions addObject:wait];
        [actions addObject:block];
    }
    
    [self runAction:[SKAction sequence:actions] withKey:@"barAnimating"];
}

@end
