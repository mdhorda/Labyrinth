//
//  ViewController.m
//  Labyrinth
//
//  Created by Mehul Dhorda on 9/6/14.
//  Copyright (c) 2014 Mehul Dhorda. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    SKView * skView = (SKView *)self.view;
    if (!skView.scene)
    {
        // Create and configure the scene.
        SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

// Fixed orientation since we're using accelerometer to control the ball
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
