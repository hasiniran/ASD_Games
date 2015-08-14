//
//  StartUpMenu.m
//  ASD_Game
//
//  Created by Hasini Yatawatte on 2/4/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartupMenu.h"


@implementation StartupMenu {
    int instructions;
    NSTimer *instructionTimer;
}


SKScene * scene;
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //initialize synthesizer
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        
        SKLabelNode *Game1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        Game1.text = @"Airplane Game"; //Set the button text
        Game1.name = @"Airplane";
        Game1.fontSize = 40;
        Game1.fontColor = [SKColor yellowColor];
        Game1.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        
        SKLabelNode *Game2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];   //Second button goes to train game
        Game2.text = @"Train Game";
        Game2.name = @"Train";
        Game2.fontSize = 40;
        Game2.fontColor = [SKColor redColor];
        Game2.position = CGPointMake(self.size.width/2, self.size.height/4);    //Put train button underneath, airplane button
        
        [self addChild:Game1];
        [self addChild:Game2];
        
        instructions = 0;
    }
    [self timer];
    
    return self;
}


-(void)timer {
    instructionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(instructionSpeech) userInfo:nil repeats:YES];
}


-(void)instructionSpeech { //keep repeating different instructions
    instructions++;
    
    if (instructions == 1) { //initial instructions
        AVSpeechUtterance *instruction1 = [[AVSpeechUtterance alloc] initWithString:@"Click on the train or airplane to start playing!"];
        instruction1.rate = 0.1;
        [self.synthesizer speakUtterance:instruction1];
    }
    else if (instructions == 10) { //wait 10 secs -- follow up 1
        AVSpeechUtterance *instruction2 = [[AVSpeechUtterance alloc] initWithString:@"Choose a game!"];
        instruction2.rate = 0.1;
        [self.synthesizer speakUtterance:instruction2];
    }
    else if (instructions == 20) { //wait 10 secs -- follow up 2
        AVSpeechUtterance *instruction3 = [[AVSpeechUtterance alloc] initWithString:@"Pick a game to play!"];
        instruction3.rate = 0.1;
        [self.synthesizer speakUtterance:instruction3];
    }
    else if (instructions > 29) { //wait another 10 secs -- restart instructions
        instructions = 0;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { //When selection is made
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //stop repeating instructions
    [instructionTimer invalidate];
    instructionTimer = nil;
    
    if ([node.name isEqualToString:@"Airplane"]) {
        AVSpeechUtterance *airplaneTransition = [[AVSpeechUtterance alloc] initWithString:@"Let's play the airplane game!"];
        airplaneTransition.rate = 0.1;
        [self.synthesizer speakUtterance:airplaneTransition];
        
        //Transition to airplane level 1
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration :1.0];
        AirplaneScene1 * scene = [AirplaneScene1 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    
    //if train button is pressed, Go to train game
    else if ([node.name isEqualToString:@"Train"]) {
        AVSpeechUtterance *trainTransition = [[AVSpeechUtterance alloc] initWithString:@"Let's play the train game!"];
        trainTransition.rate = 0.1;
        [self.synthesizer speakUtterance:trainTransition];
        
        //Transition to train level 1
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration :1.0];
        Level1  *scene= [Level1 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
}


@end