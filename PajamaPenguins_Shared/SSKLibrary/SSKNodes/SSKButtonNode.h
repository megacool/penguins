//
//  SSKButtonNode.h
//
//  Created by Skye Freeman on 12/22/14.
//  Copyright (c) 2014 skyefreeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SSKButtonNode : SKSpriteNode

@property (nonatomic, readonly) SEL SELTouchUpInside;
@property (nonatomic, readonly) SEL SELTouchUpOutside;
@property (nonatomic, readonly) SEL SELTouchDownInside;

@property (nonatomic, readonly, weak) id targetTouchUpInside;
@property (nonatomic, readonly, weak) id targetTouchUpOutside;
@property (nonatomic, readonly, weak) id targetTouchDownInside;

@property (nonatomic, readwrite) SKTexture *idleTexture;
@property (nonatomic, readwrite) SKTexture *selectedTexture;

@property (nonatomic, readwrite) SKColor *idleColor;
@property (nonatomic, readwrite) SKColor *selectedColor;

@property (nonatomic, readwrite) SKShapeNode *idleShape;
@property (nonatomic, readwrite) SKShapeNode *selectedShape;

@property (nonatomic, readwrite) SKLabelNode *label;
@property (nonatomic) SKColor *idleLabelColor;
@property (nonatomic) SKColor *selectedLabelColor;

@property (nonatomic) BOOL isSelected;

// Create button with textures
+ (instancetype)buttonWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture;
+ (instancetype)buttonWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName;
+ (instancetype)buttonWithTexture:(SKTexture*)texture idleSize:(CGSize)idleSize selectedSize:(CGSize)selectedSize;

// Create rectangle button with colors
+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size label:(SKLabelNode*)label;
+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size labelWithText:(NSString*)text;
+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size;

// Create button with two custom shapes, one color
+ (instancetype)buttonWithIdleShape:(SKShapeNode*)idleShape selectedShape:(SKShapeNode*)selectedShape label:(SKLabelNode*)label;
+ (instancetype)buttonWithIdleShape:(SKShapeNode*)idleShape selectedShape:(SKShapeNode*)selectedShape labelWithText:(NSString*)text;
+ (instancetype)buttonWithIdleShape:(SKShapeNode*)idleShape selectedShape:(SKShapeNode*)selectedShape;

// Create button with one custom shape, two colors
+ (instancetype)buttonWithShape:(SKShapeNode*)shape idleFillColor:(SKColor*)idleFillColor selectedFillColor:(SKColor*)selectedFillColor label:(SKLabelNode*)label;
+ (instancetype)buttonWithShape:(SKShapeNode*)shape idleFillColor:(SKColor*)idleFillColor selectedFillColor:(SKColor*)selectedFillColor labelWithText:(NSString*)text;
+ (instancetype)buttonWithShape:(SKShapeNode*)shape idleFillColor:(SKColor*)idleFillColor selectedFillColor:(SKColor*)selectedFillColor;

// Create button with two circles, one color
+ (instancetype)buttonWithIdleCircleOfRadius:(CGFloat)idleRadius selectedCircleOfRadius:(CGFloat)selectedRadius fillColor:(SKColor*)fillColor label:(SKLabelNode*)label;
+ (instancetype)buttonWithIdleCircleOfRadius:(CGFloat)idleRadius selectedCircleOfRadius:(CGFloat)selectedRadius fillColor:(SKColor*)fillColor labelWithText:(NSString*)text;
+ (instancetype)buttonWithIdleCircleOfRadius:(CGFloat)idleRadius selectedCircleOfRadius:(CGFloat)selectedRadius fillColor:(SKColor*)fillColor;

// Create button with one circle, two colors
+ (instancetype)buttonWithCircleOfRadius:(CGFloat)radius idleFillColor:(SKColor*)idleFillColor selectedFillColor:(SKColor*)selectedFillColor label:(SKLabelNode*)label;
+ (instancetype)buttonWithCircleOfRadius:(CGFloat)radius idleFillColor:(SKColor*)idleFillColor selectedFillColor:(SKColor*)selectedFillColor labelWithText:(NSString*)text;
+ (instancetype)buttonWithCircleOfRadius:(CGFloat)radius idleFillColor:(SKColor*)idleFillColor selectedFillColor:(SKColor*)selectedFillColor;

// Set responding selectors
- (void)setTouchUpInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchDownInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchUpOutsideTarget:(id)theTarget selector:(SEL)theSelector;

@end

@interface SKLabelNode (SSKButtonNode)
+ (SKLabelNode*)centeredLabelWithText:(NSString*)text;
+ (SKLabelNode*)centeredLabelWithLabel:(SKLabelNode*)label;
@end

@interface SKShapeNode (SSKButtonNode)
+ (SKShapeNode*)shapeNodeWithCircleOfRadius:(CGFloat)radius fillColor:(SKColor*)fillColor;
@end