//
//  PPFishNode.h
//  PajamaPenguins
//
//  Created by Skye on 4/28/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSprite.h"

typedef NS_ENUM(NSInteger, FishType) {
    FishTypeRed,
    FishTypeGreen,
    FishTypeBlue,
    FishTypeMaroon,
};

extern NSString * const kFishName;

@interface PPFishNode : PPSprite

@property (nonatomic) FishType fishType;

- (instancetype)initWithType:(FishType)fishType;
- (void)swimForever;

@end
