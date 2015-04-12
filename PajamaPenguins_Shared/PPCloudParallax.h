//
//  PPCloudParallax.h
//  PajamaPenguins
//
//  Created by Skye on 4/9/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKParallaxNode.h"

@interface PPCloudParallax : SKNode
- (instancetype)initWithSize:(CGSize)size;
- (void)update:(NSTimeInterval)dt;

@property (nonatomic) SSKParallaxNode *parallaxLayer;
@end
