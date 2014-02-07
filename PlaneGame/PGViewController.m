//
//  PGViewController.m
//  PlaneGame
//
//  Created by Adam Dierkens on 2/4/14.
//  Copyright (c) 2014 Adam Dierkens. All rights reserved.
//

#import "PGViewController.h"
#import "PGMainLevel.h"
#import "PGStartScreen.h"

@interface PGViewController()
@property (nonatomic, strong) PGGameCenterManager* manager;

@end

@implementation PGViewController
@synthesize manager = _manager;

-(PGGameCenterManager*)manager{
    if (!_manager) _manager = [[PGGameCenterManager alloc] init];
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self manager].delegate = self;
    
    BOOL avail = [PGGameCenterManager isGameCenterAvailable];
    
    NSLog(@"Is Game Center Avail: %hhd", avail);
    if (avail) {
        [[self manager] authenticateLocalUser];
    }
    
   // [self showLeaderBoard];
    [self startScreen];

}

-(void)startScreen {
    SKView* skView = (SKView*) self.view;
    PGStartScreen* startScreen = [[PGStartScreen alloc] initWithSize:skView.bounds.size];
    startScreen.scaleMode = SKSceneScaleModeAspectFill;
    startScreen.viewController = self;
    [skView presentScene:startScreen];
}

-(void) playGame {
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    PGMainLevel * scene = [[PGMainLevel alloc] initWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.viewController = self;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void) processGameCenterAuth: (NSError*) error {
    NSLog(@"Game Center Auth Error: %@", [error localizedDescription]);
}
- (void) scoreReported: (NSError*) error {
    NSLog(@"Score Reported Error: %@", error);
}
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error {
    NSLog(@"Reload Scores Complete Error: %@", error);
}
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error {
    NSLog(@"Achievent Submitted Error: %@", error);
}
- (void) achievementResetResult: (NSError*) error {
    NSLog(@"Achievement Reset Error: %@", error);
}
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error {
    NSLog(@"Map PlayerID to Player: %@", error);
}


#pragma mark GameCenter View Controllers
-(void)showLeaderBoard {
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        for (GKLeaderboard* leaderBoard in leaderboards) {
            GKGameCenterViewController* vc = [[GKGameCenterViewController alloc] init];
            vc.leaderboardIdentifier = @"PlaneGameLeaderLoard_01";
            vc.gameCenterDelegate = self;
            [self.view.window.rootViewController presentViewController:vc animated:YES completion:^{
                NSLog(@"Completed");
            }];
        }
    }];
    
    
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    NSLog(@"gameCenterViewControllerfinishCalled");
    [gameCenterViewController.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissing leaderboard view");
    }];
}

-(void)reportScore:(int64_t)score {
    [self reportScore:score forLeaderBoardID:@"PlaneGameLeaderLoard_01"];
}


-(void)reportScore:(int64_t) score forLeaderBoardID:(NSString*) identifier {
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        NSLog(@"ScoreReport Error: %@", [error localizedDescription]);
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        [self startScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
