//
//  PPIcebergObstacle.m
//  PajamaPenguins
//
//  Created by Skye on 2/21/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPIcebergObstacle.h"

@implementation PPIcebergObstacle
- (instancetype)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    if (self) {
        [self setTexture:texture];

        self.physicsBody = [SKPhysicsBody bodyWithTexture:texture size:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = NO;
    }
    return self;
}

@end
