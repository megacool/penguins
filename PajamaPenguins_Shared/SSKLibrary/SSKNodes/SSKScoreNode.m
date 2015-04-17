//
//  SSKScoreNode.m
//  PajamaPenguins
//
//  Created by Skye on 2/20/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKScoreNode.h"

@interface SSKScoreNode()
@property (nonatomic, readwrite) NSInteger score;
@end

@implementation SSKScoreNode

- (instancetype)initWithFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(SKColor*)fontColor {
    self = [super initWithFontNamed:fontName];
    
    if (self) {
        self.fontSize = fontSize;
        self.fontColor = fontColor;
        
        [self resetScore];
        [self updateText];
    }
    
    return self;
}

+ (instancetype)scoreNodeWithFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(SKColor*)fontColor {
    return [[self alloc] initWithFontNamed:fontName fontSize:fontSize fontColor:fontColor];
}

- (instancetype)initWithFontNamed:(NSString *)fontName {
    return [self initWithFontNamed:fontName fontSize:20 fontColor:[SKColor blackColor]];
}

#pragma mark - Counter controls
- (void)increment {
    self.score ++;
    [self updateText];
}

- (void)decrement {
    self.score --;
    [self updateText];
}

- (void)resetScore {
    self.score = 0;
}
#pragma mark - Node's text
- (void)updateText {
    self.text = [NSString stringWithFormat:@"%lu",self.score];
    NSLog(@"%@",self.text);
}

@end
