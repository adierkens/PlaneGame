//
//  PGViewController.m
//  PlaneGame
//
//  Created by Adam Dierkens on 2/4/14.
//  Copyright (c) 2014 Adam Dierkens. All rights reserved.
//

#import "PGViewController.h"
#import "PGMainLevel.h"
@implementation PGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self playGame];


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

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"PRESSED BUTTON");
    [self playGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
