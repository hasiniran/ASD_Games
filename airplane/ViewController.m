//
//  ViewController.m
//  airplane
//
//  Created by Hasini Yatawatte on 10/22/14.
//  Copyright (c) 2014 Hasini Yatawatte. All rights reserved.
//

#import "ViewController.h"
//#import "GameStartScene.h"  //not needed, unknown functionality
//#import "AirplaneScene1.h" //not needed either, imported in ViewController.h from StartUpMenu.h

@implementation ViewController

SKScene * scene;

- (void)viewDidLoad
{
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        scene = [StartupMenu sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
   }

-(BOOL)prefersStatusBarHidden{
    return YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

//- (IBAction)GoButton:(id)sender {
//    
//    SKSpriteNode *ship = ((MyScene *)scene).ship ;
//    [ship runAction:((MyScene *)scene).actionMoveUp];
//    
//    
//}
//- (IBAction)goAction:(id)sender {
//    
//    SKSpriteNode *ship = ((MyScene *)scene).ship ;
//    
//    if(ship.position.y < [[UIScreen mainScreen] bounds].size.height*0.75){
//    
//    [ship.physicsBody applyImpulse:CGVectorMake(0, 30)];
//    }else{
//        
//        [ship setPosition:CGPointMake(ship.position.x, [[UIScreen mainScreen] bounds].size.height*0.75)];
//        ship.physicsBody.dynamic = NO;
//        
//    }
//    
//   // [ship runAction:((MyScene *)scene).actionMoveUp];
//    
//    //SKSpriteNode *bg = ((MyScene *)scene).bg;
//    //[bg runAction:((MyScene *)scene).actionMoveUp];
//    
//     [(MyScene *)scene moveBgContinuously];
//     
//
//     NSLog(@"clicked !!!!");
//}
//

- (IBAction)LaunchAirplaneGame:(id)sender {
    
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        scene = [AirplaneScene1 sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }

    
    NSLog(@"clicked !!!!");
}

@end
