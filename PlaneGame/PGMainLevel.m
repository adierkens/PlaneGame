//
//  PGMainLevel.m
//  PlaneGame
//
//  Created by Adam Dierkens on 2/4/14.
//  Copyright (c) 2014 Adam Dierkens. All rights reserved.
//

#import "PGMainLevel.h"

static const uint32_t shipCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x01 << 1;

@interface PGMainLevel()
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic) CGFloat midScreenX;
@property (nonatomic) CGFloat midScreenY;
@property (nonatomic, strong) SKSpriteNode* ship;
@property (nonatomic, strong) NSMutableArray* obsticles;
@property (nonatomic, strong) SKLabelNode* scoreLabel;
@property (nonatomic, strong) SKSpriteNode* debugNode;
@property (nonatomic) CFTimeInterval lastAddedObject;
@property (nonatomic, strong) PGGameCenterManager* manager;

@end

@implementation PGMainLevel
@synthesize touchLocation = _touchLocation;
@synthesize ship = _ship;
@synthesize midScreenY = _midScreenY;
@synthesize midScreenX = _midScreenX;
@synthesize obsticles = _obsticles;
@synthesize viewController = _viewController;
@synthesize scoreLabel = _scoreLabel;
@synthesize debugNode = _debugNode;
@synthesize manager = _manager;


-(PGGameCenterManager*)manager{
    if (!_manager) _manager = [[PGGameCenterManager alloc] init];
    return _manager;
}

-(SKSpriteNode*)debugNode{
    if (!_debugNode) _debugNode = [[SKSpriteNode alloc] init];
    return _debugNode;
}

-(SKLabelNode*)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[SKLabelNode alloc] init];
        _scoreLabel.position = CGPointMake(100, 10);
        _scoreLabel.fontSize = 24;
        
        _scoreLabel.name = @"scoreLabel";
    }
    return _scoreLabel;
}

-(SKSpriteNode *)ship {
    if (!_ship) {
        _ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        [_ship setName:@"ship"];
        _ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:25];
        _ship.physicsBody.categoryBitMask = shipCategory;
        _ship.physicsBody.dynamic = YES;
        _ship.physicsBody.contactTestBitMask = obstacleCategory;
    }
    return _ship;
}

-(NSMutableArray *)obsticles{
    if (!_obsticles) _obsticles = [[NSMutableArray alloc] init];
    return _obsticles;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self setMidScreenX:CGRectGetMidX(self.frame)];
        [self setMidScreenY:CGRectGetMidY(self.frame)];
        [self setTouchLocation:CGPointMake(self.midScreenX, self.midScreenY)];
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self ship].position = CGPointMake(100, CGRectGetMidY(self.frame));
        [self addChild:[self scoreLabel]];
        [self addChild:[self ship]];
        [self addChild:[self debugNode]];
        [self setLastAddedObject:0];
        self.physicsWorld.contactDelegate = self;
        [[self physicsWorld] setGravity:CGVectorMake(0, 0)];
        
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
    
    CGFloat angle = (int)arc4random()%2 * -1;
    if (angle == 0) angle = 1;
    
    SKAction* move = [SKAction moveByX:-10 y:0 duration:.1];
    SKAction* moveForever = [SKAction repeatActionForever:move];
    SKAction* rotate = [SKAction rotateByAngle:M_PI_2 * angle  duration:2];
    SKAction* rotateForever = [SKAction repeatActionForever:rotate];
    
    asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:asteroid.size.width/2];
    asteroid.physicsBody.categoryBitMask = obstacleCategory;
    asteroid.physicsBody.contactTestBitMask = shipCategory;
    asteroid.physicsBody.dynamic = YES;
    
    [asteroid runAction:rotateForever];
    [asteroid runAction:moveForever];
    [objectSet addObject:asteroid];
    [self addChild:asteroid];
}

-(void)didBeginContact:(SKPhysicsContact *) contact {
    [self stopGame];

}

-(void)stopGame{
    [self setPaused:YES];    
    
    NSString* scoreString = [@"Score: " stringByAppendingFormat:@"%d", [self score]];
    UIAlertView* scoreAlertView = [[UIAlertView alloc] initWithTitle:@"Game Over" message: scoreString delegate:self.viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [scoreAlertView show];
    [[self viewController] reportScore:[self score]];
}

-(void)updateScore{
    [self setScore:[self score] + 1];
    [[self scoreLabel] setText:[NSString stringWithFormat:@"Score: %d", [self score]]];
}

-(void)update:(CFTimeInterval)currentTime {
    [self updateShipPosition];
    
    if (self.paused) {
        return;
    }
    
    // Add an astroid to the view
    if ((currentTime - self.lastAddedObject > 1) ) {
        self.lastAddedObject = currentTime;
        [self addAsteroid];
    }
    
    [self updateScore];
}


#pragma mark - PGGameCenterManager



@end
