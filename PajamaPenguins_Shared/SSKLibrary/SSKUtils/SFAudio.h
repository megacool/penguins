//
//  SFAudio.h
//  PajamaPenguins
//
//  Created by Skye on 5/16/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SFAudio : NSObject
- (instancetype)initWithFileNamed:(NSString*)fileName;

- (void)startSound;
- (void)stopSound;

- (void)setVolume:(CGFloat)level;

@end
