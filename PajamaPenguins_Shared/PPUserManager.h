//
//  PPUserManager.h
//  PajamaPenguins
//
//  Created by Skye on 4/16/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUserManager : NSObject
+ (instancetype)sharedManager;

// Saving
- (void)saveHighScore:(NSNumber*)score;
- (void)saveCoins:(NSNumber*)scoins;

- (NSNumber*)getHighScore;
- (NSNumber*)getTotalCoins;

// Settings

@end
