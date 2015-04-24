//
//  PPSkyManager.h
//  PajamaPenguins
//
//  Created by Skye on 4/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSkySprite.h"

@interface PPSkyManager : NSObject
@property (nonatomic, readonly) SKNode *allSkies;

+ (instancetype)sharedManager;

@end
