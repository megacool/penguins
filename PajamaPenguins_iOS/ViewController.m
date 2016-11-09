//
//  ViewController.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "ViewController.h"
#import "PPMenuScene.h"
#import "PPGameScene.h"

#import "PPSharedAssets.h"

//#define DEBUG_MODE 1 // Comment/uncomment to toggle debug information.
@interface ViewController()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ViewController

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    [skView setIgnoresSiblingOrder:YES]; //Provides extra rendering optimizations. (zPositions need to be explicitly set)
    
    [self.activityIndicator startAnimating];
    
    if (!skView.scene) {
        [PPSharedAssets loadSharedAssetsWithCompletion:^{
            NSLog(@"Loading Complete.");
            
            // Present Scene
            PPMenuScene *scene = [PPMenuScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            scene.viewController = self;
            [skView presentScene:scene transition:[SKTransition moveInWithDirection:SKTransitionDirectionRight duration:1]];
            
            // Remove loading icon
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            
        }];
    }
    
#ifdef DEBUG_MODE
    skView.showsPhysics = YES;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
