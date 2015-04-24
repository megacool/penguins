//
//  PPSkyFadingSky.h
//  PajamaPenguins
//
//  Created by Skye on 4/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKColorNode.h"

@interface PPFadingSky : SSKColorNode

@property (nonatomic) NSUInteger dayDuration;

+ (instancetype)skyWithSize:(CGSize)size dayDuration:(NSUInteger)duration;
- (instancetype)initWithSize:(CGSize)size dayDuration:(NSUInteger)duration;

- (void)startFade;


@end
