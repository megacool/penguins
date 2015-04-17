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

// High Scores
- (void)saveHighScore:(NSNumber*)score;
- (NSNumber*)getHighScore;

// Settings

@end
