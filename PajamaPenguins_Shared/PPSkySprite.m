//
//  PPSkySprite.m
//  PajamaPenguins
//
//  Created by Skye on 4/4/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSkySprite.h"
#import "SKTexture+SFAdditions.h"
#import "SKColor+SFAdditions.h"

#define kColorMorning [SKColor colorWithR:255 g:220 b:0]
#define kColorDay [SKColor colorWithR:0 g:218 b:255]
#define kColorAfternoon [SKColor colorWithR:0 g:118 b:255]
#define kColorSunset [SKColor colorWithR:255 g:12 b:2]
#define kColorNight [SKColor colorWithR:0 g:0 b:110]

@interface PPSkySprite()
@end

@implementation PPSkySprite
+ (instancetype)spriteWithSize:(CGSize)size skyType:(SkyType)skyType {
    return [[self alloc] initWithSize:size skyType:skyType];
}

- (instancetype)initWithSize:(CGSize)size skyType:(SkyType)skyType {
    self = [super initWithTexture:[self textureForSkyType:skyType size:size]];
    
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0);
    }
    
    return self;
}

#pragma mark - Sky Type
- (void)setSkyType:(SkyType)skyType {
    [self setTexture:[self textureForSkyType:skyType size:self.size]];
}

- (SKTexture*)textureForSkyType:(SkyType)skyType size:(CGSize)size {
    SKTexture *skyTexture;
    SKColor *white = [SKColor whiteColor];
    GradientDirection direction = GradientDirectionVertical;
    
    switch (skyType) {
        case SkyTypeMorning:
            skyTexture = [SKTexture textureWithGradientOfSize:size startColor:white endColor:kColorMorning direction:direction];
            break;
            
        case SkyTypeDay:
            skyTexture = [SKTexture textureWithGradientOfSize:size startColor:white endColor:kColorDay direction:direction];
            break;
            
        case SkyTypeAfternoon:
            skyTexture = [SKTexture textureWithGradientOfSize:size startColor:white endColor:kColorAfternoon direction:direction];
            break;
            
        case SkyTypeSunset:
            skyTexture = [SKTexture textureWithGradientOfSize:size startColor:white endColor:kColorSunset direction:direction];
            break;
            
        case SkyTypeNight:
            skyTexture = [SKTexture textureWithGradientOfSize:size startColor:white endColor:kColorNight direction:direction];
            break;
            
        default:
            break;
    }

    return skyTexture;
}

@end
