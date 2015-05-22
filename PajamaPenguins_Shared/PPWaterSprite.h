//
//  PPWaterSprite.h
//  PajamaPenguins
//
//  Created by Skye on 4/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKWaterSurfaceNode.h"

typedef NS_ENUM(NSUInteger, WaterType) {
    WaterTypeMorning = 0,
//    WaterTypeDay,
    WaterTypeAfternoon,
    WaterTypeSunset,
    WaterTypeNight,
};


@interface PPWaterSprite : SSKWaterSurfaceNode
@property (nonatomic) WaterType waterType;

+ (instancetype)surfaceWithStartPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint
                                depth:(CGFloat)depth
                            waterType:(WaterType)waterType;
@end
