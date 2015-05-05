//
//  PPSkySprite.m
//  PajamaPenguins
//
//  Created by Skye on 4/4/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSkySprite.h"
#import "PPSharedAssets.h"
#import "SKColor+SFAdditions.h"

@interface PPSkySprite()
@end

@implementation PPSkySprite
+ (instancetype)skyWithType:(SkyType)skyType {
    return [[self alloc] initWithSkyType:skyType];
}

- (instancetype)initWithSkyType:(SkyType)skyType {
    self = [super initWithTexture:[self textureForSkyType:skyType]];
    if (self) {
        self.anchorPoint = CGPointMake(0, 0);
    }
    
    return self;
}

#pragma mark - Sky Type
- (void)setSkyType:(SkyType)skyType {
    [self setTexture:[self textureForSkyType:skyType]];
}

- (SKTexture*)textureForSkyType:(SkyType)skyType {
    SKTexture *skyTexture;

    switch (skyType) {
        case SkyTypeMorning:
            skyTexture = [PPSharedAssets sharedSkyMorning];
            break;
            
        case SkyTypeDay:
            skyTexture = [PPSharedAssets sharedSkyDay];
            break;
            
        case SkyTypeAfternoon:
            skyTexture = [PPSharedAssets sharedSkyAfternoon];
            break;
            
        case SkyTypeSunset:
            skyTexture = [PPSharedAssets sharedSkySunset];
            break;
            
        case SkyTypeNight:
            skyTexture = [PPSharedAssets sharedSkyNight];
            break;
            
        default:
            break;
    }

    return skyTexture;
}

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
