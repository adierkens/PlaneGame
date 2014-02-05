//
//  PGMainLevel.m
//  PlaneGame
//
//  Created by Adam Dierkens on 2/4/14.
//  Copyright (c) 2014 Adam Dierkens. All rights reserved.
//

#import "PGMainLevel.h"

@interface PGMainLevel()
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic) CGFloat midScreenX;
@property (nonatomic) CGFloat midScreenY;
@property (nonatomic, strong) SKSpriteNode* ship;
@property (nonatomic, strong) NSMutableArray* obsticles;
@end

@implementation PGMainLevel
@synthesize touchLocation = _touchLocation;
@synthesize ship = _ship;
@synthesize midScreenY = _midScreenY;
@synthesize midScreenX = _midScreenX;
@synthesize obsticles = _obsticles;
@synthesize viewController = _viewController;

-(SKSpriteNode *)ship {
    if (!_ship) {
        _ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        [_ship setName:@"ship"];
    }
    return _ship;
}

-(NSMutableArray *)obsticles{
    if (!_obsticles) _obsticles = [[NSMutableArray alloc] init];
    return _obsticles;
}

-(id)initWithSize:(CGSize)size {
    NSLog(@"TEST");
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self setMidScreenX:CGRectGetMidX(self.frame)];
        [self setMidScreenY:CGRectGetMidY(self.frame)];

        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self ship].position = CGPointMake(50, CGRectGetMidY(self.frame));
        
        [self addChild:[self ship]];
    }
    return self;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch moves */
    
    for (UITouch *touch in touches) {
        [self setTouchLocation:[touch locationInNode:self]];
    }
    

}

-(void)updateShipPosition {
    CGFloat delta = ([self touchLocation].y - [self midScreenY]) / [self midScreenY];
    CGFloat angle =  (M_PI/2) * delta;
    CGFloat Ychange = 10 * delta;
    
    // Check if new delta Y is off the screen
    CGFloat new_position = [self ship].position.y + Ychange;
    if (new_position > self.frame.size.height) {
        new_position = self.frame.size.height;
    } else if (new_position < 0) {
        new_position = 0;
    }
    SKAction * rotate = [SKAction rotateToAngle:angle duration:.1];
    SKAction * move = [SKAction moveToY:new_position duration:.01];
    
    [[self ship] runAction:move];
    [[self ship] runAction:rotate];
}

-(void)addObsticles:(NSSet *)objects {
    for (SKSpriteNode* node in objects) {
        [self addChild:node];
    }
}

-(void)addAsteroid{
    NSMutableSet* objectSet = [[NSMutableSet alloc] init];
    SKSpriteNode* asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    asteroid.position = CGPointMake(self.frame.size.width, arc4random() % ((int)self.frame.size.height));
    SKAction* move = [SKAction moveByX:-10 y:0 duration:.1];
    SKAction* moveForever = [SKAction repeatActionForever:move];
    [asteroid runAction:moveForever];
    [objectSet addObject:asteroid];
    [self addChild:asteroid];
}

-(void)checkForContact{
    NSArray* nodes = [self nodesAtPoint:[self ship].position];
    if ([nodes count] > 1) {
        NSLog(@"CONTACT!");
        [self stopGame];
    }
}

-(void)stopGame{
    [self setPaused:YES];    
    
    NSString* scoreString = [@"Score: " stringByAppendingFormat:@"%d", [self score]];
    UIAlertView* scoreAlertView = [[UIAlertView alloc] initWithTitle:@"Crashed" message: scoreString delegate:self.viewController cancelButtonTitle:@"Cancel" otherButtonTitles: @"Play Again", nil];
    [scoreAlertView show];
}

-(void)update:(CFTimeInterval)currentTime {
    [self updateShipPosition];
    
    if (self.paused) {
        return;
    }
    
    // Add an astroid to the view
    if (((currentTime - (int)currentTime) < .01) ) {
        [self addAsteroid];
    }
    
    // Check if you hit an astroid
    [self checkForContact];
    [self setScore:[self score] + 1];
}

@end
