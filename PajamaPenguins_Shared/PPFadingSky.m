//
//  PPFadingSky.m
//  PajamaPenguins
//
//  Created by Skye on 4/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPFadingSky.h"

@interface PPFadingSky()
@property (nonatomic) SKNode *topLayer;
@end

@implementation PPFadingSky

+ (instancetype)skyWithDayDuration:(NSUInteger)duration {
    return [[self alloc] initWithDayDuration:duration];
}

- (instancetype)initWithDayDuration:(NSUInteger)duration {
    self = [super init];
    if (self) {
        self.dayDuration = duration;
        [self populateSkyLayers];
        [self setNewTopLayer];
    }
    return self;
}

- (void)populateSkyLayers {
    NSUInteger zPosition = 0;
    for (int i = 4; i >= 0; i--) {
        PPSkySprite *skyLayer = [PPSkySprite skyWithType:i];
        [skyLayer setZPosition:zPosition];
        [self addChild:skyLayer];
        
        zPosition++;
    }
}

#pragma mark - Fading
- (void)startFade {
    [self.topLayer runAction:[SKAction fadeOutWithDuration:self.dayDuration] completion:^{
        [self adjustAllSkyLayerPositions];
        [self.topLayer setZPosition:0];
        [self.topLayer setAlpha:1];
        [self setNewTopLayer];
        [self startFade];
    }];
}

- (void)adjustAllSkyLayerPositions {
    for (SKNode *layer in self.children) {
        layer.zPosition++;
    }
}

- (void)setNewTopLayer {
    SKNode *newTopLayer;
    
    for (SKNode *layer in self.children) {
        if (newTopLayer.zPosition < layer.zPosition) {
            newTopLayer = layer;
        }
    }
    self.topLayer = newTopLayer;
}

@end
