//
//  PPButtonNode.h
//  PajamaPenguins
//
//  Created by Skye on 4/23/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKButtonNode.h"

@interface PPButtonNode : SSKButtonNode
+ (instancetype)buttonWithIdleTextureNamed:(NSString*)idleTexture selectedTextureNamed:(NSString*)selTexture;
- (instancetype)initWithIdleTextureNamed:(NSString*)idleTexture selectedTextureNamed:(NSString*)selTexture;
@end
