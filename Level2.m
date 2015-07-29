//
//  Level2.m
//  ASD_Game
//
//  Created by Kim Forbes on 2/8/15.
//  Copyright (c) 2015 Kim Forbes. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Level2.h"


@implementation Level2 {
    SKSpriteNode *train;
    SKSpriteNode *cow1;
    SKSpriteNode *cow2;
    SKSpriteNode *cow3;
    SKSpriteNode *cow4;
    SKSpriteNode *cow5;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    SKNode *button;
    SKLabelNode *correct;
    SKLabelNode *skip;
    SKLabelNode *nextButton;
    SKLabelNode *tryAgainButton;
    SKLabelNode *instructionText;
    NSTimer *instructionTimer;
    double speed;
    int textDisplay;
    int numCows;
    int again;
}


-(id)initWithSize:(CGSize)size {
    speed = 1; //start with train moving
    textDisplay = 0;
    numCows = (arc4random_uniform(4)+1); //random number of cows, 1-5
    again = 0;
    
    if(self = [super initWithSize:size]){
        //initialize synthesizer
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        
        //add layers
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        //correct button
        correct = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        correct.text = @"Correct";
        correct.name = @"Correct";
        correct.fontSize = 40;
        correct.fontColor = [SKColor blueColor];
        correct.position = CGPointMake(150,600);
        correct.zPosition = 50;
        [_HUDLayer addChild:correct];
        
        //skip button
        skip = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP"; //Set the button text
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [_HUDLayer addChild:skip]; //add node to screen
        
        //display instructions
        instructionText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        instructionText.name = @"instructionText";
        instructionText.fontSize = 40;
        instructionText.fontColor = [SKColor redColor];
        instructionText.position = CGPointMake(500,500);
        instructionText.zPosition = 50;
        [self addChild:instructionText];
        
        [self ScrollingBackground]; //scolling sky
        [self ScrollingForeground]; //scolling tracks
        [self train];
        [self addCows];
        [self addMountain];
        
        [self timer];
    }
        
    //move train(LtoR) and cows (RtoL)
    [train.physicsBody applyImpulse:CGVectorMake(1, 0)];
    [cow1.physicsBody applyImpulse:CGVectorMake(-1.3, 0)];
    [cow2.physicsBody applyImpulse:CGVectorMake(-1.3, 0)];
    [cow3.physicsBody applyImpulse:CGVectorMake(-1.3, 0)];
    [cow4.physicsBody applyImpulse:CGVectorMake(-1.3, 0)];
    [cow5.physicsBody applyImpulse:CGVectorMake(-1.3, 0)];

    return self;
}


-(void)ScrollingBackground {  //scrolling background
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Clouds.png"];        //reuse sky image
    SKAction *moveBg = [SKAction moveByX:-backgroundTexture.size.width y:0 duration: 0.1*speed*backgroundTexture.size.width]; //move Bg
    SKAction *resetBg = [SKAction moveByX:backgroundTexture.size.width*2 y:0 duration:0];   //reset background
    SKAction *moveBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];    //repeat moveBg and resetBg
    
    for(int i=0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) {     //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 500);
        [sprite runAction:moveBackgroundForever];
        [_bgLayer addChild:sprite];
    }
}


-(void)ScrollingForeground { //Scrolling tracks
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"Rail.png"]; //change runway to train tracks
    SKAction *moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:.02*speed*groundTexture.size.width*2];
    SKAction *resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction *moveGroundSpriteForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for(int i=0; i<2 +self.frame.size.width/(groundTexture.size.width);i++) {      //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [sprite setScale:1];
        sprite.zPosition = 10;
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(i*sprite.size.width, 0);
        [sprite runAction:moveGroundSpriteForever];
        [_gameLayer addChild:sprite];
    }
}


-(void)train {
    train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];
    train.position = CGPointMake(60, 100);
    train.zPosition = 50;
    train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    train.physicsBody.dynamic = YES;
    train.physicsBody.affectedByGravity = NO;
    train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:train];
}


//set each cow as a physics body, give starting position (no overlap)
-(void)cow1 {
    cow1 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow1.name = @"cow1";
    cow1.position = CGPointMake(1075,300);
    cow1.zPosition = 100;
    cow1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 20)];
    cow1.physicsBody.dynamic = YES;
    cow1.physicsBody.affectedByGravity = NO;
    cow1.physicsBody.allowsRotation = NO;
    [cow1 runAction:[SKAction moveTo:CGPointMake(-225, 300) duration:60] completion:^{}];
    [_gameLayer addChild:cow1];
}


-(void)cow2 {
    cow2 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow2.position = CGPointMake(1150,400);
    cow2.zPosition = 100;
    cow2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 20)];
    cow2.physicsBody.dynamic = YES;
    cow2.physicsBody.affectedByGravity = NO;
    cow2.physicsBody.allowsRotation = NO;
    [cow2 runAction:[SKAction moveTo:CGPointMake(-150, 400) duration:60] completion:^{}];
    [_gameLayer addChild:cow2];
}


-(void)cow3 {
    cow3 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow3.position = CGPointMake(1175,200);
    cow3.zPosition = 100;
    cow3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 20)];
    cow3.physicsBody.dynamic = YES;
    cow3.physicsBody.affectedByGravity = NO;
    cow3.physicsBody.allowsRotation = NO;
    [cow3 runAction:[SKAction moveTo:CGPointMake(-150, 200) duration:60] completion:^{}];
    [_gameLayer addChild:cow3];
}


-(void)cow4 {
    cow4 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow4.position = CGPointMake(1275,250);
    cow4.zPosition = 100;
    cow4.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 20)];
    cow4.physicsBody.dynamic = YES;
    cow4.physicsBody.affectedByGravity = NO;
    cow4.physicsBody.allowsRotation = NO;
    [cow4 runAction:[SKAction moveTo:CGPointMake(-50, 250) duration:60] completion:^{}];
    [_gameLayer addChild:cow4];
}


-(void)cow5 {
    cow5 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow5.position = CGPointMake(1275,350);
    cow5.zPosition = 100;
    cow5.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 20)];
    cow5.physicsBody.dynamic = YES;
    cow5.physicsBody.affectedByGravity = NO;
    cow5.physicsBody.allowsRotation = NO;
    [cow5 runAction:[SKAction moveTo:CGPointMake(-50, 350) duration:60] completion:^{}];
    [_gameLayer addChild:cow5];
}


-(void)addCows { //put random number of cows into scene
    if(numCows == 1) {
        [self cow1];
    }
    else if(numCows == 2) {
        [self cow1];
        [self cow2];
    }
    else if(numCows == 3) {
        [self cow1];
        [self cow2];
        [self cow3];
    }
    else if(numCows == 4) {
        [self cow1];
        [self cow2];
        [self cow3];
        [self cow4];
    }
    else if(numCows == 5) {
        [self cow1];
        [self cow2];
        [self cow3];
        [self cow4];
        [self cow5];
    }
}


-(void)addMountain {
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"background_mount.png"];
    
    for (int i=0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:2];
        sprite.zPosition=-30;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 100);
        [_HUDLayer addChild:sprite];
    }
}


-(void)timer { //keep accessing displayText until child starts playing
    instructionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayText) userInfo:nil repeats:YES];
}


-(void)displayText { //text to count the cows
    if (textDisplay == 0) {
        instructionText.text = @"Level 2";
        
        AVSpeechUtterance *instruction1 = [[AVSpeechUtterance alloc] initWithString:@"Level 2"];
        instruction1.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction1.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction1];
    }
    else if (textDisplay == 12) {
        instructionText = (SKLabelNode *) [self childNodeWithName:@"instructionText"]; //clear previous text
        instructionText.text = @"Count the cows.";
        
        AVSpeechUtterance *instruction2 = [[AVSpeechUtterance alloc] initWithString:@"Count the cows."];
        instruction2.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction2.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction2];
    }
    else if (textDisplay == 20) {
        instructionText = (SKLabelNode *) [self childNodeWithName:@"instructionText"];
        instructionText.text = @"Count the cows.";
        
        AVSpeechUtterance *instruction3 = [[AVSpeechUtterance alloc] initWithString:@"Count the cows."];
        instruction3.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction3.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction3];
    }
    else if (textDisplay == 30) {
        instructionText = (SKLabelNode *) [self childNodeWithName:@"instructionText"];
        instructionText.text = @"Repeat after me";
        AVSpeechUtterance *instruction4 = [[AVSpeechUtterance alloc] initWithString:@"Repeat after me"];
        instruction4.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction4.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction4];
        
        if (numCows == 1) {
            AVSpeechUtterance *instruction4a = [[AVSpeechUtterance alloc] initWithString:@"One"];
            instruction4a.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction4a.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction4a];
        }
        else if (numCows == 2) {
            AVSpeechUtterance *instruction4b = [[AVSpeechUtterance alloc] initWithString:@"One Two"];
            instruction4b.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction4b.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction4b];
        }
        else if (numCows == 3) {
            AVSpeechUtterance *instruction4c = [[AVSpeechUtterance alloc] initWithString:@"One Two Three"];
            instruction4c.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction4c.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction4c];
        }
        else if (numCows == 4) {
            AVSpeechUtterance *instruction4d = [[AVSpeechUtterance alloc] initWithString:@"One Two Three Four"];
            instruction4d.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction4d.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction4d];
        }
        else if (numCows == 5) {
            AVSpeechUtterance *instruction4e = [[AVSpeechUtterance alloc] initWithString:@"One Two Three Four Five"];
            instruction4e.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction4e.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction4e];
        }
    }
    else if (textDisplay == 40) {
        instructionText = (SKLabelNode *) [self childNodeWithName:@"instructionText"];
        instructionText.text = [NSString stringWithFormat: @"Say %i", numCows];
        
        AVSpeechUtterance *instruction5 = [[AVSpeechUtterance alloc] initWithString:[NSString stringWithFormat: @"Say %i", numCows]];
        instruction5.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction5.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction5];
    }
    textDisplay++;
}


-(void)nextLevel { //transition to level 3
    nextButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    nextButton.text = @"Go to Level 3";
    nextButton.fontColor = [SKColor blueColor];
    nextButton.color = [SKColor yellowColor];
    nextButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    nextButton.name = @"level3";
    [_HUDLayer addChild:nextButton];
    
    AVSpeechUtterance *next = [[AVSpeechUtterance alloc] initWithString:@"Good Job! Continue on to level 3."];
    next.rate = AVSpeechUtteranceMinimumSpeechRate;
    next.pitchMultiplier = 1.5;
    [self.synthesizer speakUtterance:next];
}


-(void)tryAgain { //replay level 2 if not completed
    tryAgainButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    tryAgainButton.text = @"Try Again";
    tryAgainButton.fontColor = [SKColor blueColor];
    tryAgainButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    tryAgainButton.name = @"level2";
    [_HUDLayer addChild:tryAgainButton];
    
    if (again == 0) { //voice synthesis only occurs once
        AVSpeechUtterance *againSpeech = [[AVSpeechUtterance alloc] initWithString:@"Let's try Level 2 again"];
        againSpeech.rate = AVSpeechUtteranceMinimumSpeechRate;
        againSpeech.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:againSpeech];
    }
    again++;
    
    instructionText = (SKLabelNode *) [self childNodeWithName:@"instructionText"]; //clear instructions
    instructionText.text = [NSString stringWithFormat: @" "];
}


-(void)update:(NSTimeInterval) currentTime{
    if(cow1.position.x <= 0){   //call tryAgain function once cows start to disappear off screen
        [self tryAgain];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    button = [self nodeAtPoint:location];
    
    if([button.name  isEqualToString: @"Correct"]) { //display level 3
        [self nextLevel];
        
        //stop repeating instructions
        [instructionTimer invalidate];
        instructionTimer = nil;
    }
    else if ([button.name isEqualToString:@"level3"]) { //transition to level 3
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level3 *scene = [Level3 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    else if ([button.name isEqualToString:@"Skip"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level3 *scene = [Level3 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
        //stop repeating instructions
        [instructionTimer invalidate];
        instructionTimer = nil;
    }
    else if ([button.name isEqualToString:@"level2"]) { //transition to level 2 again
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level2 *scene = [Level2 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
}


@end