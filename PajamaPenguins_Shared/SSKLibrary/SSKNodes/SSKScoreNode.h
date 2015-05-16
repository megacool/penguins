//
//  SSKScoreNode.h
//  PajamaPenguins
//
//  Created by Skye on 2/20/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SSKScoreNode : SKLabelNode

@property (nonatomic, readonly) NSInteger count;

+ (instancetype)scoreNodeWithFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(SKColor*)fontColor;
- (instancetype)initWithFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(SKColor*)fontColor;

- (void)setScore:(NSInteger)newScore;

- (void)increment;
- (void)decrement;
- (void)resetScore;

@end
