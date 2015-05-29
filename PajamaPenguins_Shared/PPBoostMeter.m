//
//  PPBoostMeter.m
//  PajamaPenguins
//
//  Created by Skye on 5/28/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPBoostMeter.h"

@implementation PPBoostMeter

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithFrameColor:[SKColor blackColor] barColor:[SKColor redColor] size:size barType:BarTypeVertical];
    if (self) {
        
    }
    return self;
}

@end
