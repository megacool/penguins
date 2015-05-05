//
//  PPSkyManager.h
//  PajamaPenguins
//
//  Created by Skye on 5/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPBackgroundManager : NSObject
@property (nonatomic, readonly) NSUInteger timeOfDay;

+ (instancetype)sharedManager;
- (void)incrementDay;

@end
