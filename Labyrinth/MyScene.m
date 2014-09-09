//
//  MyScene.m
//  Labyrinth
//
//  Created by Mehul Dhorda on 9/6/14.
//  Copyright (c) 2014 Mehul Dhorda. All rights reserved.
//

#import "MyScene.h"
#import "Maze.h"
#import <CoreMotion/CoreMotion.h>
#import <math.h>

#define BALL_DIAM 50
#define BALL_RADIUS BALL_DIAM / 2

// Width of walls
#define WALL_SIZE 10

#define MAZE_ROWS 5
#define MAZE_COLUMNS 8

// Twice then normal gravity constant in m/s
#define GRAVITY_CONSTANT 9.8 * 2

// Margin which will be considered when checking if ball is in hole
#define BALL_IN_HOLE_MARGIN 5

#define BACKGROUND_COLOR [SKColor colorWithRed:0.85 green:0.85 blue:0.66 alpha:1.0]
#define BLACK_COLOR [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0]

@interface MyScene()
{
    SKSpriteNode *ball;
    SKSpriteNode *hole;
    NSMutableArray *walls;
    CMMotionManager *motionManager;
}
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = BACKGROUND_COLOR;
        
        // Set physics body so that ball doesn't go outside the screen bounds
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
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
        ball.physicsBody.friction = 0.1;
        [self addChild:ball];
        
        // Create walls
        walls = [NSMutableArray array];
        [self createRandomMaze];
        
        // Adjust gravity direction based on accelerometer
        motionManager = [[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval = .1;
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                self.physicsWorld.gravity = CGVectorMake(-accelerometerData.acceleration.y * GRAVITY_CONSTANT,
                                                                                         accelerometerData.acceleration.x * GRAVITY_CONSTANT);
                                            }];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime
{
    // If ball is in the hole, reset ball position and create new maze
    if (fabsf(ball.position.x - hole.position.x) < BALL_IN_HOLE_MARGIN &&
        fabsf(ball.position.y - hole.position.y) < BALL_IN_HOLE_MARGIN)
    {
        ball.position = CGPointMake(BALL_RADIUS, self.size.height - BALL_RADIUS);
        ball.physicsBody.velocity = CGVectorMake(0, 0);
        [self createRandomMaze];
    }
}

-(void)createRandomMaze
{
    [self removeChildrenInArray:walls];
    [walls removeAllObjects];
    
    // Get maze layout
    Maze *maze = [[Maze alloc] initWithRows:MAZE_ROWS andColumns:MAZE_COLUMNS];
    [maze printGrid];
    
    // Calculate wall size
    float horzWallWidth = self.size.width / MAZE_COLUMNS;
    float vertWallHeight = self.size.height / MAZE_ROWS;
    
    // Create walls from grid
    float width, height, posX, posY;
    for (int y = 0; y < MAZE_ROWS; y++)
    {
        for (int x = 0; x < MAZE_COLUMNS; x++)
        {
            int direction = [maze getDirectionAtRow:x andColumn:y];
            
            // Draw a horizontal wall on the south edge if the direction is available and we're not on the last row
            if (((direction & S) == 0) && (y < MAZE_ROWS-1))
            {
                width = horzWallWidth + WALL_SIZE;
                height = WALL_SIZE;
                posX = (horzWallWidth / 2) + (horzWallWidth * x);
                posY = vertWallHeight * (MAZE_ROWS - y - 1);
                [self addWallWithPosition:CGPointMake(posX, posY) andSize:CGSizeMake(width, height)];
            }
            
            // Draw a vertical wall on the east edge if the direction is available and we're not on the last column
            if (((direction & E) == 0) && (x < MAZE_COLUMNS-1))
            {
                width = WALL_SIZE;
                height = vertWallHeight + WALL_SIZE;
                posX = horzWallWidth * (x + 1);
                posY = (vertWallHeight * (MAZE_ROWS - y - 1)) + (vertWallHeight / 2);
                [self addWallWithPosition:CGPointMake(posX, posY) andSize:CGSizeMake(width, height)];
            }
        }
    }
}

-(void)addWallWithPosition:(CGPoint)position andSize:(CGSize)size
{
    SKSpriteNode *wall = [SKSpriteNode spriteNodeWithColor:BLACK_COLOR size:size];
    wall.position = position;
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
    wall.physicsBody.dynamic = NO;
    wall.physicsBody.resting = YES;
    [self addChild:wall];
    [walls addObject:wall];
}

@end
