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

@property (nonatomic) SKColor *startBarColor;
@property (nonatomic) SKColor *startBackgroundBarColor;

@property (nonatomic, readwrite) CGFloat currentProgress;

@end

@implementation SSKProgressBarNode

+ (instancetype)barWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size barType:(BarType)barType {
    return [[self alloc] initWithFrameColor:frameColor barColor:barColor size:size barType:barType];
}

- (instancetype)initWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size barType:(BarType)barType {
    self = [super init];
    
    if (self) {
        self.startBarColor = barColor;
        self.startBackgroundBarColor = [SKColor blackColor];
        self.barType = barType;
        self.currentProgress = 1.0;
        _size = size;
        
        self.barBackground = [SKSpriteNode spriteNodeWithColor:self.startBackgroundBarColor size:size];
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

+ (instancetype)barWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size {
    return [[self alloc] initWithFrameColor:frameColor barColor:barColor size:size];
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

- (SKAction*)setProgressAction:(CGFloat)progress {
    return [SKAction runBlock:^{
        NSLog(@"called after");
        [self setProgress:progress];
    }];
}

#pragma mark - Bar Actions
- (void)startFlash {
    if ([self actionForKey:@"flashKey"]) return;
    
    SKAction *flashOn = [SKAction runBlock:^{
        [self.bar setColor:[SKColor whiteColor]];
    }];
    SKAction *flashOff = [SKAction runBlock:^{
        [self.bar setColor:self.startBarColor];
    }];
    SKAction *wait = [SKAction waitForDuration:.15];
    SKAction *seq = [SKAction sequence:@[flashOn,wait,flashOff,wait]];
    [self runAction:[SKAction repeatActionForever:seq] withKey:@"flashKey"];
}

- (void)stopFlash {
    [self removeActionForKey:@"flashKey"];
    [self.bar setColor:self.startBarColor];
}

@end
