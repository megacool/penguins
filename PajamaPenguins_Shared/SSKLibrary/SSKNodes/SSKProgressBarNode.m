//
//  SSKProgressBarNode.m
//  PajamaPenguins
//
//  Created by Skye on 3/4/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKProgressBarNode.h"

@interface SSKProgressBarNode()
@property (nonatomic) SKSpriteNode *barBackground;
@property (nonatomic) SKSpriteNode *bar;
@property (nonatomic) SKShapeNode *barFrame;

@property (nonatomic, readwrite) CGFloat currentProgress;
@end

@implementation SSKProgressBarNode

- (instancetype)initWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size barType:(BarType)barType {
    self = [super init];
    
    if (self) {
        self.barType = barType;
        self.size = size;
        
        self.barBackground = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:size];
        [self addChild:self.barBackground];
        
        self.bar = [SKSpriteNode spriteNodeWithColor:barColor size:size];
        [self.bar setAnchorPoint:CGPointMake(0, 0)];
        [self.bar setPosition:CGPointMake(-size.width/2, -size.height/2)];
        [self addChild:self.bar];
        
        self.barFrame = [SKShapeNode shapeNodeWithRect:CGRectMake(-size.width/2, -size.height/2, size.width, size.height)];
        [self.barFrame setStrokeColor:frameColor];
        [self.barFrame setLineWidth:2];
        [self addChild:self.barFrame];
    }
    
    return self;
}

- (instancetype)initWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size {
    return [self initWithFrameColor:frameColor barColor:barColor size:size barType:BarTypeHorizontal];
}

#pragma mark - Set Progress
- (void)setProgress:(CGFloat)progress {
    if (progress >= 0.0 && progress <= 1.0 ) {

        if (self.barType == BarTypeHorizontal) {
            [self.bar setXScale:progress];
        }
        
        if (self.barType == BarTypeVertical) {
            [self.bar setYScale:progress];
        }
        
        self.currentProgress = progress;
    } else {
        NSLog(@"Can't set progress outside of 0 - 1.0");
    }
}

@end
