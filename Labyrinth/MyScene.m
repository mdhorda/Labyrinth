//
//  MyScene.m
//  Labyrinth
//
//  Created by Mehul Dhorda on 9/6/14.
//  Copyright (c) 2014 Mehul Dhorda. All rights reserved.
//

#import "MyScene.h"
#import <math.h>

#define BALL_DIAM 50
#define BALL_RADIUS BALL_DIAM / 2

#define BACKGROUND_COLOR [SKColor colorWithRed:0.85 green:0.85 blue:0.66 alpha:1.0]
#define BLACK_COLOR [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0]

@interface MyScene()
{
    SKSpriteNode *ball;
    SKSpriteNode *hole;
}
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = BACKGROUND_COLOR;
        
        // Set physics body so that ball doesn't go outside the screen bounds
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        // Create wall
        SKSpriteNode *wall = [SKSpriteNode spriteNodeWithColor:BLACK_COLOR size:CGSizeMake(600, 10)];
        wall.position = CGPointMake(0, 200);
        wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
        wall.physicsBody.dynamic = NO;
        wall.physicsBody.resting = YES;
        [self addChild:wall];
        
        // Create hole
        hole = [SKSpriteNode spriteNodeWithImageNamed:@"BlackHole"];
        hole.size = CGSizeMake(BALL_DIAM, BALL_DIAM);
        hole.position = CGPointMake(self.size.width - BALL_RADIUS, BALL_RADIUS);
        [self addChild:hole];
        
        // Create ball
        ball = [SKSpriteNode spriteNodeWithImageNamed:@"GreenBall"];
        ball.size = CGSizeMake(BALL_DIAM, BALL_DIAM);
        ball.position = CGPointMake(BALL_RADIUS, self.size.height - BALL_RADIUS);
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:BALL_RADIUS];
        ball.physicsBody.dynamic = YES;
        [self addChild:ball];
    }
    return self;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Use touch event to apply impulse to ball and make it move
    UITouch *touch = [touches anyObject];
    CGPoint newLocation = [touch locationInView:self.view];
    CGPoint prevLocation = [touch previousLocationInView:self.view];
    float xOffset = newLocation.x - prevLocation.x;
    
    [ball.physicsBody applyImpulse:CGVectorMake(xOffset / 10, 0)];
}

-(void)update:(CFTimeInterval)currentTime
{
    // Check if ball is in the hole
    if (fabsf(ball.position.x - hole.position.x) < 3 &&
        fabsf(ball.position.y - hole.position.y) < 3)
        ball.position = CGPointMake(BALL_RADIUS, self.size.height - BALL_RADIUS);
}

@end
