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

+ (SKColor*)backgroundColor {
    return [SKColor colorWithR:172 g:213 b:206];
}

@end
