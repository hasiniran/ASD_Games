//
//  StartUpMenu.m
//  ASD_Game
//
//  Created by Hasini Yatawatte on 2/4/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartupMenu.h"
#import "SecondLevel.h"



@implementation StartupMenu

SKScene * scene;


-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {

        //SKLabelNode *Game1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        //Game1.text = @"Airplane Game"; //Set the button text
        //Game1.name = @"Airplane";
        //Game1.fontSize = 40;
        //Game1.fontColor = [SKColor yellowColor];
        //Game1.position = CGPointMake(self.size.width/2, self.size.height/2);
      
        //
        //SKLabelNode *Game2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];   //Second button goes to train game
        //Game2.text = @"Train Game";
        //Game2.name = @"Train";
        //Game2.fontSize = 40;
        //Game2.fontColor = [SKColor redColor];
        //Game2.position = CGPointMake(self.size.width/2, self.size.height/4);    //Put train button underneath, airplane button
        //
        //[self addChild:Game1];
        //[self addChild:Game2];
        
    }
    
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    //UITouch *touch = [touches anyObject];
    //CGPoint location = [touch locationInNode:self];
    //SKNode *node = [self nodeAtPoint:location];
    //
    //SKNode *trainNode = [self nodeAtPoint:location];
    
    //launch the first scene of the airplane game if the Airplane button is touched
   
    /* For demo */
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration :1.0];
    
    SecondLevel *scene = [SecondLevel sceneWithSize:self.view.bounds.size];
    //AirplaneScene1 * scene = [AirplaneScene1 sceneWithSize:self.view.bounds.size];    //commented out in order to test Train game
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition: reveal];
    
    //if train button is pressed, Go to train game
    if ([trainNode.name isEqualToString:@"Train"]) {
        
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration :1.0];
        Level1 *scene= [Level1 sceneWithSize:self.view.bounds.size]; //changed level1 to level 4 to test
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    
    
}


@end
