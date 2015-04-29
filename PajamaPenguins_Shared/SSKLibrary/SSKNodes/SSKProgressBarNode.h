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

- (instancetype)initWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size barType:(BarType)barType;
- (instancetype)initWithFrameColor:(SKColor*)frameColor barColor:(SKColor*)barColor size:(CGSize)size;
- (void)setProgress:(CGFloat)progress;

@property (nonatomic) BarType barType;
@property (nonatomic) CGSize size;
@property (nonatomic, readonly) CGFloat currentProgress;

@end
