//
//  PPSkyManager.m
//  PajamaPenguins
//
//  Created by Skye on 5/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPBackgroundManager.h"

@interface PPBackgroundManager()
@property (nonatomic, readwrite) NSUInteger timeOfDay;
@end

@implementation PPBackgroundManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static PPBackgroundManager *sharedManager = nil;
    dispatch_once(&once, ^ {
        sharedManager = [[PPBackgroundManager alloc] init];
        sharedManager.timeOfDay = 0;
    });
    return sharedManager;
}

- (void)incrementDay {
    self.timeOfDay++;
    if (self.timeOfDay > 3) {
        self.timeOfDay = 0;
    }
}

@end
