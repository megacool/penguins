//
//  PPBoostMeter.m
//  PajamaPenguins
//
//  Created by Skye on 5/28/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPBoostMeter.h"

@implementation PPBoostMeter

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithFrameColor:[SKColor blackColor] barColor:[SKColor redColor] size:size barType:BarTypeVertical];
    if (self) {
        
    }
    return self;
}

#pragma mark - Segment Decrease
- (void)animateToProgress:(CGFloat)newProgress {
    CGFloat currentProgress = self.currentProgress;
    CGFloat difference = (currentProgress - newProgress) * -1;
    NSLog(@"Difference between progresses: %fl",difference);
    
    CGFloat animationTime = difference * 2; // 1.0 == 2 seconds, 0.5 = 1 second etc...
    CGFloat intervals = fabs(difference/0.01);
    
    NSMutableArray *actions = [NSMutableArray new];
    for (int i = 0; i < intervals; i++) {
        NSLog(@"intervals: %fl",intervals);
        
        // Adjust current progress by 1 percent per interval
        if (currentProgress > newProgress) {
            currentProgress = currentProgress - 0.01;
        } else {
            currentProgress = currentProgress + 0.01;
        }
        
        NSLog(@"New prog: %fl",currentProgress);
        SKAction *block = [SKAction runBlock:^{
            [self setProgress:currentProgress];
        }];
        
        // Wait a segment of the animation time
        SKAction *wait = [SKAction waitForDuration:animationTime/intervals];
        
        [actions addObject:block];
        [actions addObject:wait];
    }
    
    [self runAction:[SKAction sequence:actions]];
}

@end
