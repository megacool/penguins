//
//  SSKColor+Additions.m
//
//  Created by Skye on 1/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <SpriteKit/SpriteKit.h>

@interface SKColor (SFAdditions)
+ (SKColor*)colorWithR:(int)r g:(int)g b:(int)b;

+ (SKColor*)waterMorning;
+ (SKColor*)waterDay;
+ (SKColor*)waterAfternoon;
+ (SKColor*)waterSunset;
+ (SKColor*)waterNight;

+ (SKColor*)skyMorning;
+ (SKColor*)skyDay;
+ (SKColor*)skyAfternoon;
+ (SKColor*)skySunset;
+ (SKColor*)skyNight;

@end