//
//  SFAudio.m
//  PajamaPenguins
//
//  Created by Skye on 5/16/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SFAudio.h"

@interface SFAudio()
@property (nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation SFAudio

- (instancetype)initWithFileNamed:(NSString*)fileName {
    self = [super init];
    if (self) {
        // Load audio data
        NSError *dataError;
        NSData *data = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], fileName]
                                                      options:NSDataReadingMappedIfSafe error:&dataError];
        
        if (!data) {
            NSLog(@"Error:%@",[dataError localizedDescription]);
        }
        
        // Create the audio player from data
        NSError *audioError;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&audioError];
        if (!self.audioPlayer) {
            NSLog(@"Error:%@",[audioError localizedDescription]);
        }
    }
    
    return self;
}

#pragma mark - Audio Controls
- (void)startSound {
    [self.audioPlayer setCurrentTime:0.0];
    [self.audioPlayer play];
}

- (void)stopSound {
    [self.audioPlayer stop];
}

- (void)setVolume:(CGFloat)level {
    if (level < 0.0 || level > 1.0) {
        NSLog(@"Volume level must be between 0 - 1.0");
        return;
    }
    [self.audioPlayer setVolume:level];
}

@end
