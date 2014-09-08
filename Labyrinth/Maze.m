//
//  MazeGenerator.m
//  Labyrinth
//
//  Created by Mehul Dhorda on 9/7/14.
//  Copyright (c) 2014 Mehul Dhorda. All rights reserved.
//

#import "Maze.h"

NSDictionary *DirectionX = nil;
NSDictionary *DirectionY = nil;
NSDictionary *Opposite = nil;

@interface Maze ()
{
    int **grid;
    int gridRows;
    int gridColumns;
}
@end

@implementation Maze

+(void)initialize
{
    DirectionX = @{@(N): @(0),
                   @(S): @(0),
                   @(E): @(1),
                   @(W): @(-1),
                   };
    
    DirectionY = @{@(N): @(-1),
                   @(S): @(1),
                   @(E): @(0),
                   @(W): @(0),
                   };
    
    Opposite = @{@(N): @(S),
                 @(S): @(N),
                 @(E): @(W),
                 @(W): @(E),
                 };
}

-(id)initWithRows:(int)rows andColumns:(int)columns;
{
    self = [super init];
    
    if (self)
    {
        // Create grid of ints to represent cells in the maze
        grid = malloc(rows * sizeof(int *));
        gridRows = rows;
        gridColumns = columns;
        for (int r = 0; r < rows; r++)
        {
            grid[r] = malloc(columns * sizeof(int));
        }
        for (int c = 0; c < columns; c++)
        {
            for (int r = 0; r < rows; r++)
            {
                // Initialize to 0 to indicate that all walls in the cell are up
                grid[r][c] = 0;
            }
        }
        
        // Create path starting from the origin of the maze
        [self createPathFromPoint:CGPointMake(0, 0)];
    }
    
    return self;
}

-(void)dealloc
{
    for (int r = 0; r < gridRows; r++)
    {
        free(grid[r]);
    }
    free(grid);
}

-(int)getDirectionAtRow:(int)row andColumn:(int)column
{
    return grid[column][row];
}

-(void)printGrid
{
    // Print top line
    printf(" ");
    for (int i = 0; i < gridColumns; i++)
        printf(" _");
    printf("\n");
    
    // Print grid
    for (int y = 0; y < gridRows; y++)
    {
        printf(" |");
        for (int x = 0; x < gridColumns; x++)
        {
            int dir = grid[y][x];
            if ((dir & S) > 0)
                printf(" ");
            else
                printf("_");
            if ((dir & E) > 0)
                printf(" ");
            else
                printf("|");
        }
        printf("\n");
    }
}

-(void)createPathFromPoint:(CGPoint)point
{
    int x = (int)point.x;
    int y = (int)point.y;
    
    // Randomize list of directions
    NSArray *directions = [self getRandomDirectionList];
    
    // Visit all directions
    for (id direction in directions)
    {
        int dir = [direction intValue];
        
        // Get coordinates of next cell in this direction
        int nextX = x + [DirectionX[@(dir)] intValue];
        int nextY = y + [DirectionY[@(dir)] intValue];
        
        // Check if next cell is in bounds and hasn't been visited yet
        if ((nextX >= 0 && nextX < gridColumns) &&
            (nextY >= 0 && nextY < gridRows) &&
            grid[nextY][nextX] == 0)
        {
            // Break down walls for this cell and the next
            grid[y][x] |= dir;
            grid[nextY][nextX] |= [Opposite[direction] intValue];
            
            // Recursively break walls from next cell using depth-first search
            [self createPathFromPoint:CGPointMake(nextX, nextY)];
        }
    }
}

-(NSArray *)getRandomDirectionList
{
    // Shuffly array of directions
    NSMutableArray *directions = [NSMutableArray arrayWithArray:@[@(N), @(S), @(E), @(W)]];
    NSUInteger count = [directions count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
        [directions exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return directions;
}

@end
