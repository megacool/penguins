//
//  PPSkyManager.m
//  PajamaPenguins
//
//  Created by Skye on 4/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSkyManager.h"

@interface PPSkyManager()
@property (nonatomic, readwrite) SKNode *allSkies;
@end

@implementation PPSkyManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static PPSkyManager *sharedManager = nil;

    dispatch_once(&once, ^ {
        sharedManager = [[PPSkyManager alloc] init];
        
        sharedManager.allSkies = [SKNode new];
        [sharedManager createSkyLayers];
    });
    
    return sharedManager;
}

#pragma mark - Sky
- (void)createSkyLayers {
    NSUInteger zPosition = 0;
    for (int i = 4; i >= 0; i--) {
        PPSkySprite *sky = [PPSkySprite skyWithType:i];
        [sky setZPosition:zPosition];
        [self.allSkies addChild:sky];
        
        zPosition++;
    }
}

@end
