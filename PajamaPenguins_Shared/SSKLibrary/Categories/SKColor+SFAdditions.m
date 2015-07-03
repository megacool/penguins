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

+ (SKColor*)water {
    return [SKColor colorWithR:48 g:140 b:255];
};

+ (SKColor*)skyDay {
    return [SKColor colorWithR:110 g:200 b:253];
};

+ (SKColor*)skyNight{
    return [SKColor colorWithR:55 g:58 b:175];
};

+ (SKColor*)darkRed {
    return [SKColor colorWithR:150 g:5 b:5];
}

+ (SKColor*)boostMeterColor {
    return [UIColor colorWithRed:1.000 green:0.401 blue:0.205 alpha:1.000];
}

@end
