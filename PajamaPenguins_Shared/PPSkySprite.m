//
//  PPSkySprite.m
//  PajamaPenguins
//
//  Created by Skye on 4/4/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSkySprite.h"
#import "SKColor+SFAdditions.h"

@interface PPSkySprite()
@end

@implementation PPSkySprite

#pragma mark - Sky Type Color
+ (SKColor*)colorForSkyType:(SkyType)skyType {
    SKColor *skyColor;
    
    switch (skyType) {
        case SkyTypeMorning:
            skyColor = [SKColor skyMorning];
            break;
            
        case SkyTypeDay:
            skyColor = [SKColor skyDay];
            break;
            
        case SkyTypeAfternoon:
            skyColor = [SKColor skyAfternoon];
            break;
            
        case SkyTypeSunset:
            skyColor = [SKColor skySunset];
            break;
            
        case SkyTypeNight:
            skyColor = [SKColor skyNight];
            break;
            
        default:
            break;
    }
    
    return skyColor;
}

@end
