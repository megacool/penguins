//
//  PPUser.m
//  PajamaPenguins
//
//  Created by Skye on 4/16/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPUserManager.h"

NSString * const kUserHighScoreKey = @"UserHighScore";
NSString * const kUserTotalCoinKey = @"UserTotalCoins";

@implementation PPUserManager
+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static PPUserManager *sharedManager = nil;
    dispatch_once(&once, ^ {
        sharedManager = [[PPUserManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - High Score
- (void)saveHighScore:(NSNumber*)score {
    if (!(score > [self getHighScore])) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:score forKey:kUserHighScoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber*)getHighScore {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserHighScoreKey];
}

#pragma mark - Coins
- (void)saveCoins:(NSNumber*)coins {
    NSInteger currentTotal = [[PPUserManager sharedManager] getTotalCoins].integerValue;
    NSInteger newTotal = currentTotal + coins.integerValue;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:newTotal] forKey:kUserTotalCoinKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber*)getTotalCoins {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserTotalCoinKey];
}

#pragma mark - Settings

@end
