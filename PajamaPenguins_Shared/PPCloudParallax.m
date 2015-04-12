//
//  PPCloudParallax.m
//  PajamaPenguins
//
//  Created by Skye on 4/9/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPCloudParallax.h"
#import "UIDevice+SFAdditions.h"

@implementation PPCloudParallax

- (instancetype)initWithSize:(CGSize)size {
    return [super init];
}

- (void)update:(NSTimeInterval)dt {
    [self.parallaxLayer update:dt];
}

@end
