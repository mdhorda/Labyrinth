//
//  MazeGenerator.h
//  Labyrinth
//
//  Created by Mehul Dhorda on 9/7/14.
//  Copyright (c) 2014 Mehul Dhorda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    N = 1,
    S = 2,
    E = 4,
    W = 8
} Directions;

// Uses Recursive Backtracing algorithm for maze generation
// http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking

@interface Maze : NSObject

-(id)initWithRows:(int)rows andColumns:(int)columns;
-(int)getDirectionAtRow:(int)row andColumn:(int)column;
-(void)printGrid;

@end
