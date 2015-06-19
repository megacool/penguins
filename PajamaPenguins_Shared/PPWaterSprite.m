//
//  PPWaterSprite.m
//  PajamaPenguins
//
//  Created by Skye on 4/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPWaterSprite.h"
#import "PPSharedAssets.h"
#import "SKColor+SFAdditions.h"

@implementation PPWaterSprite
+ (instancetype)surfaceWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint depth:(CGFloat)depth waterType:(WaterType)waterType {
    return [[self alloc] initWithStartPoint:startPoint endPoint:endPoint depth:depth waterType:waterType];
}

- (instancetype)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint depth:(CGFloat)depth waterType:(WaterType)waterType {
    self = [super initWithStartPoint:startPoint endPoint:endPoint depth:depth color:[self colorForWaterType:waterType]];
    if (self) {
        self.waterType = waterType;
        [self setSplashDamping:.05];
        [self setSplashTension:.005];
        
        [self setAlpha:.60];
    }
    return self;
}

#pragma mark - Water Type
- (SKColor*)colorForWaterType:(WaterType)waterType {
    SKColor *theColor;
    switch (waterType) {
        case WaterTypeAfternoon: {
            theColor = [SKColor waterAfternoon];
            break;
        }
            
        case WaterTypeMorning: {
//            theColor = [SKColor waterMorning];
            theColor = [SKColor waterAfternoon];
            break;
        }
//        case WaterTypeDay: {
//            theColor = [SKColor waterDay];
//            break;
//        }
            
        case WaterTypeSunset: {
//            theColor = [SKColor waterSunset];
            theColor = [SKColor waterAfternoon];
            break;
        }
        case WaterTypeNight: {
            theColor = [SKColor waterNight];
            break;
        }
        default: {
            break;
        }
    }
    return theColor;
}

@end
