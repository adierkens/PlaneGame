//
//  PGStartScreen.m
//  PlaneGame
//
//  Created by Adam Dierkens on 2/5/14.
//  Copyright (c) 2014 Adam Dierkens. All rights reserved.
//

#import "PGStartScreen.h"

@interface PGStartScreen()
@property (nonatomic, strong) SKLabelNode* startLabel;
@property (nonatomic, strong) SKLabelNode* leaderBoardLabel;
@end

@implementation PGStartScreen
@synthesize viewController = _viewController;
@synthesize startLabel = _startLabel;
@synthesize leaderBoardLabel = _leaderBoardLabel;


-(SKLabelNode*)leaderBoardLabel{
    if (!_leaderBoardLabel) {
        _leaderBoardLabel = [[SKLabelNode alloc] init];
        _leaderBoardLabel.text = @"View Leaderboard";
        _leaderBoardLabel.fontColor = [UIColor whiteColor];
        _leaderBoardLabel.fontSize = 20;
        _leaderBoardLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 10);
    }
    return _leaderBoardLabel;
}

-(SKLabelNode*) startLabel {
    if (!_startLabel) {
        _startLabel = [[SKLabelNode alloc] init];
        _startLabel.text = @"Play Game";
        _startLabel.fontColor = [UIColor whiteColor];
        _startLabel.fontSize = 20;
        _startLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 10);
    }
    return _startLabel;
}

-(id)initWithSize:(CGSize)size {
    NSLog(@"TEST");
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self addChild:[self leaderBoardLabel]];
        [self addChild:[self startLabel]];
        
    }
    return self;
}

-(void)startClicked{
    // Animation of start
    [[self viewController] playGame];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Clicked Screen");
    /* Called when a touch moves */
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (CGRectContainsPoint(self.startLabel.calculateAccumulatedFrame, location)) {
            [self startClicked];
        }
        else if (CGRectContainsPoint(self.leaderBoardLabel.calculateAccumulatedFrame, location)){
            [[self viewController] showLeaderBoard];
        }
    }
}

@end
