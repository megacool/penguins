//
//  PPBoostMeter.h
//  PajamaPenguins
//
//  Created by Skye on 5/28/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKProgressBarNode.h"

@interface PPBoostMeter : SSKProgressBarNode
- (instancetype)initWithSize:(CGSize)size;

- (void)animateToProgress:(CGFloat)newProgress;
@end
