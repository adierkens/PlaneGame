//
//  PGViewController.h
//  PlaneGame
//

//  Copyright (c) 2014 Adam Dierkens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import "PGGameCenterManager.h"

@interface PGViewController : UIViewController
<UIAlertViewDelegate, GKGameCenterControllerDelegate, PGGameCenterManagerDelegate>
-(void) playGame;
-(void)reportScore:(int64_t) score forLeaderBoardID:(NSString*) identifier;
-(void)reportScore:(int64_t)score;
-(void)showLeaderBoard;
@end
