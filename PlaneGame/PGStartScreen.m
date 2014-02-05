//
//  PGStartScreen.m
//  PlaneGame
//
//  Created by Adam Dierkens on 2/5/14.
//  Copyright (c) 2014 Adam Dierkens. All rights reserved.
//

#import "PGStartScreen.h"

@implementation PGStartScreen

-(id)initWithSize:(CGSize)size {
    NSLog(@"TEST");
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        SKSpriteNode* startShip = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
    }
    return self;
}

@end
