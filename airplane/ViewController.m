//
//  ViewController.m
//  airplane
//
//  Created by Hasini Yatawatte on 10/22/14.
//  Copyright (c) 2014 Hasini Yatawatte. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

SKScene * scene;

- (void)viewDidLoad
{
   [super viewDidLoad];
//
//    // Configure the view.
//    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    
//    // Create and configure the scene.
//    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    // Present the scene.
//    [skView presentScene:scene];
    [self.goButton setTitle:@"GO !!" forState:UIControlStateNormal];
    

}



- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        scene = [MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
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

- (IBAction)GoButton:(id)sender {
    
    SKSpriteNode *ship = ((MyScene *)scene).ship ;
    [ship runAction:((MyScene *)scene).actionMoveUp];
    
    
}
- (IBAction)goAction:(id)sender {
    SKSpriteNode *ship = ((MyScene *)scene).ship ;
    [ship runAction:((MyScene *)scene).actionMoveUp];
    
   // SKSpriteNode *bg = ((MyScene *)scene).bg;
    //[bg runAction:((MyScene *)scene).actionMoveUp];
    

     NSLog(@"clicked !!!!");
}

@end
