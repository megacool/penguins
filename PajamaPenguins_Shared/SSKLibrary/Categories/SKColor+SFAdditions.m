//
//  UIColor+SFAdditions.m
//  PajamaPenguins
//
//  Created by Skye on 3/28/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SKColor+SFAdditions.h"

@implementation SKColor (SFAdditions)
+ (SKColor*)colorWithR:(int)r g:(int)g b:(int)b {
    return [SKColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

+ (SKColor*)waterMorning{
    return [SKColor colorWithR:255 g:90 b:75];
};

+ (SKColor*)waterDay{
    return [SKColor colorWithR:40 g:210 b:253];
};

+ (SKColor*)waterAfternoon{
    return [SKColor colorWithR:48 g:140 b:255];
};

+ (SKColor*)waterSunset{
    return [SKColor colorWithR:255 g:80 b:180];
};

+ (SKColor*)waterNight{
    return [SKColor colorWithR:30 g:20 b:138];
};

+ (SKColor*)skyMorning{
    return [SKColor colorWithR:255 g:130 b:100];
};

+ (SKColor*)skyDay{
    return [SKColor colorWithR:80 g:250 b:240];
};

+ (SKColor*)skyAfternoon{
    return [SKColor colorWithR:110 g:200 b:253];
};

+ (SKColor*)skySunset{
    return [SKColor colorWithR:255 g:135 b:215];
};

+ (SKColor*)skyNight{
    return [SKColor colorWithR:55 g:58 b:175];
};


@end
