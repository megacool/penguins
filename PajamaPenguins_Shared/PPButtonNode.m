//
//  PPButtonNode.m
//  PajamaPenguins
//
//  Created by Skye on 4/23/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPButtonNode.h"
#import "PPSharedAssets.h"

@implementation PPButtonNode

+ (instancetype)buttonWithIdleTextureNamed:(NSString*)idleTexture selectedTextureNamed:(NSString*)selTexture {
    return [[self alloc] initWithIdleTextureNamed:idleTexture selectedTextureNamed:selTexture];
}

- (instancetype)initWithIdleTextureNamed:(NSString*)idleTexture selectedTextureNamed:(NSString*)selTexture {
    self = [PPButtonNode buttonWithIdleTexture:[[PPSharedAssets sharedButtonAtlas] textureNamed:idleTexture] selectedTexture:[[PPSharedAssets sharedButtonAtlas] textureNamed:selTexture]];
    
    if (self) {
        [self setSize:CGSizeMake(150, 50)];
    }
    
    return self;
}

@end
