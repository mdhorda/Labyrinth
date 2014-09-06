//
//  MyScene.m
//  Labyrinth
//
//  Created by Mehul Dhorda on 9/6/14.
//  Copyright (c) 2014 Mehul Dhorda. All rights reserved.
//

#import "MyScene.h"

#define BALL_SIZE 50

@interface MyScene()
{
    SKSpriteNode *ball;
}
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.85 green:0.85 blue:0.66 alpha:1.0];
        
        ball = [SKSpriteNode spriteNodeWithImageNamed:@"GreenBall"];
        ball.size = CGSizeMake(BALL_SIZE, BALL_SIZE);
        ball.position = CGPointMake(BALL_SIZE / 2, self.size.height - (BALL_SIZE / 2));
        SKAction *action = [SKAction moveByX:BALL_SIZE y:0 duration:0.5];
        [ball runAction:[SKAction repeatActionForever:action]];
        [self addChild:ball];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (ball.position.x >= (self.size.width - (BALL_SIZE / 2)))
    {
        [ball removeAllActions];
    }
}

@end
