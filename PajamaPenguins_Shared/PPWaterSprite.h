//
//  PPWaterSprite.h
//  PajamaPenguins
//
//  Created by Skye on 4/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKWaterSurfaceNode.h"

@interface PPWaterSprite : SSKWaterSurfaceNode
+ (instancetype)surfaceWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint depth:(CGFloat)depth;
@end
