//
//  PPIcebergObstacle.h
//  PajamaPenguins
//
//  Created by Skye on 2/21/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PPSprite.h"

typedef NS_ENUM(NSUInteger, IceBergType) {
    IceBergTypeNormal = 0,
    IceBergTypeWide,
};

@interface PPIcebergObstacle : PPSprite
@property (nonatomic) IceBergType icebergType;

+ (instancetype)icebergWithType:(IceBergType)icebergType;
@end
