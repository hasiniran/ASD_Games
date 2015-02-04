//
//  StartUpMenu.m
//  ASD_Game
//
//  Created by Hasini Yatawatte on 2/4/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartupMenu.h"



@implementation StartupMenu

SKScene * scene;


-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {

        SKLabelNode *Game1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        Game1.text = @"Airplane Game"; //Set the button text
        Game1.name = @"Airplane";
        Game1.fontSize = 40;
        Game1.fontColor = [SKColor yellowColor];
        Game1.position = CGPointMake(self.size.width/2, self.size.height/2);
      
        [self addChild:Game1];
    }
    
    return self;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //launch the first scene of the airplane game if the Airplane button is touched
   
    if ([node.name isEqualToString:@"Airplane"]) {
        
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration :1.0];
        AirplaneScene1 * scene = [AirplaneScene1 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }
    
}


@end
