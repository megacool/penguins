//
//  PPButtonNode.m
//  PajamaPenguins
//
//  Created by Skye on 4/23/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPButtonNode.h"

@implementation PPButtonNode

+ (instancetype)buttonWithTexture:(SKTexture *)texture {
    return [self buttonWithTexture:texture idleSize:CGSizeMake(100, 100) selectedSize:CGSizeMake(90, 90)];
}

@end
