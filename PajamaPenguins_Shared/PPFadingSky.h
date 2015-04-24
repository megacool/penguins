//
//  PPSkyFadingSky.h
//  PajamaPenguins
//
//  Created by Skye on 4/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PPSkySprite.h"

@interface PPFadingSky : SKNode

@property (nonatomic) NSUInteger dayDuration;

+ (instancetype)skyWithDayDuration:(NSUInteger)duration;
- (void)startFade;


@end
