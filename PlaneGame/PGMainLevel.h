//
//  PGMainLevel.h
//  PlaneGame
//
//  Created by Adam Dierkens on 2/4/14.
//  Copyright (c) 2014 Adam Dierkens. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PGViewController.h"
#import "PGGameCenterManager.h"

@interface PGMainLevel : SKScene
<SKPhysicsContactDelegate, PGGameCenterManagerDelegate>
@property (nonatomic) NSInteger score;
@property (nonatomic, weak) PGViewController* viewController;
@end
