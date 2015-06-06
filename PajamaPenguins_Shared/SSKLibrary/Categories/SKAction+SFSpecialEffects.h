//
//  SKAction+SFSpecialEffects.h
//  PajamaPenguins
//
//  Created by Skye on 6/6/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKAction (SFSpecialEffects)
+ (SKAction*)shakeWithDuration:(CGFloat)duration amplitude:(CGPoint)amp;
@end
