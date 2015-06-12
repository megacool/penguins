//
//  SSKProgressBarNode.h
//  PajamaPenguins
//
//  Created by Skye on 3/4/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, BarType) {
    BarTypeHorizontal = 0,
    BarTypeVertical,
};

@interface SSKProgressBarNode : SKNode

+ (instancetype)barWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size barType:(BarType)barType;
- (instancetype)initWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size barType:(BarType)barType;

+ (instancetype)barWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size;
- (instancetype)initWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size;

- (void)setProgress:(CGFloat)progress;
- (SKAction*)setProgressAction:(CGFloat)progress;

- (void)startFlash;
- (void)stopFlash;

@property (nonatomic) BarType barType;

@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGFloat currentProgress;

@property (nonatomic) SKSpriteNode *bar;
@property (nonatomic) SKShapeNode *barFrame;
@property (nonatomic) SKSpriteNode *barBackground;

@end
