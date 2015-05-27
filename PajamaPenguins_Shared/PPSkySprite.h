//
//  PPSkySprite.h
//  PajamaPenguins
//
//  Created by Skye on 4/4/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, SkyType) {
    SkyTypeAfternoon = 0,
    SkyTypeMorning,
//    SkyTypeDay = 0,
    SkyTypeSunset,
    SkyTypeNight,
};

@interface PPSkySprite : SKSpriteNode
+ (SKColor*)colorForSkyType:(SkyType)skyType;
@end
