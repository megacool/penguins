//
//  PPFadingSky.m
//  PajamaPenguins
//
//  Created by Skye on 4/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPFadingSky.h"

NSUInteger const kMorningR = 255;
NSUInteger const kMorningG = 130;
NSUInteger const kMorningB = 10;

NSUInteger const kDayR = 75;
NSUInteger const kDayG = 255;
NSUInteger const kDayB = 255;

NSUInteger const kAfternoonR = 35;
NSUInteger const kAfternoonG = 122;
NSUInteger const kAfternoonB = 255;

NSUInteger const kSunsetR = 255;
NSUInteger const kSunsetG = 62;
NSUInteger const kSunsetB = 59;

NSUInteger const kNightR = 0;
NSUInteger const kNightG = 30;
NSUInteger const kNightB = 90;

@interface PPFadingSky()

@end

@implementation PPFadingSky

+ (instancetype)skyWithSize:(CGSize)size dayDuration:(NSUInteger)duration {
    return [[self alloc] initWithSize:size dayDuration:duration];
}

- (instancetype)initWithSize:(CGSize)size dayDuration:(NSUInteger)duration {
    self = [super initWithRed:kMorningR green:kMorningG blue:kMorningB size:size];
    if (self) {
        self.dayDuration = duration;
    }
    return self;
}

#pragma mark - Fading

//There has to be a better way...
- (void)startFade {
    [self crossFadeToRed:kDayR green:kDayG blue:kDayB duration:self.dayDuration completion:^{
        [self crossFadeToRed:kAfternoonR green:kAfternoonG blue:kAfternoonB duration:self.dayDuration completion:^{
            [self crossFadeToRed:kSunsetR green:kSunsetG blue:kSunsetB duration:self.dayDuration completion:^{
                [self crossFadeToRed:kNightR green:kNightG blue:kNightB duration:self.dayDuration completion:^{
                    [self crossFadeToRed:kMorningR green:kMorningG blue:kMorningB duration:self.dayDuration completion:^{
                        [self startFade];
                    }];
                }];
            }];
        }];
    }];
}

@end
