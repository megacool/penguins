//
//  PPIcebergObstacle.m
//  PajamaPenguins
//
//  Created by Skye on 2/21/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPIcebergObstacle.h"
#import "PPSharedAssets.h"

@implementation PPIcebergObstacle
- (instancetype)initWithIcebergType:(IceBergType)icebergType {
    SKTexture *texture = [self textureForIcebergType:icebergType];
    self = [super initWithTexture:texture];
    if (self) {
//        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2 - self.size.width/8];
        self.physicsBody = [SKPhysicsBody bodyWithTexture:texture size:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = NO;
    }
    return self;
}

+ (instancetype)icebergWithType:(IceBergType)icebergType {
    return [[self alloc] initWithIcebergType:icebergType];
}

#pragma mark - Iceberg Type
- (SKTexture*)textureForIcebergType:(IceBergType)icebergType {
    SKTexture *texture = nil;
    
    switch (icebergType) {
        case IceBergTypeNormal:
            texture = [[PPSharedAssets sharedIcebergAtlas] textureNamed:@"iceberg_normal"];
            break;
            
        case IceBergTypeWide:
            texture = [[PPSharedAssets sharedIcebergAtlas] textureNamed:@"iceberg_wide"];
            break;
            
        default:
            break;
    }
    return texture;
}

@end
