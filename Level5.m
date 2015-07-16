//
//  Level5.m
//  ASD_Game
//  Previously Level4
//
//  Created by Kim Forbes on 3/19/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Level5.h"


@implementation Level5 {
    SKSpriteNode *train;
    SKSpriteNode *rail;
    SKSpriteNode *stopSign1;
    SKSpriteNode *stopSign2;
    SKSpriteNode *stopSign3;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    SKNode *text;
    SKNode *button;
    SKLabelNode *skip;
    SKLabelNode *nextButton;
    SKLabelNode *stop;
    SKLabelNode *tryAgainButton;
    SKLabelNode *instructions;
    NSTimer *inst1;
    double speed;
    int click;
    int sign;
    int chances;
}


-(id)initWithSize:(CGSize)size {
    speed = 1; //start with train moving
    click = 0;
    sign = 0;
    chances = 3;
    
    if(self = [super initWithSize:size]) {
        //initialize synthesizer
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        
        //add layers
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        text = [SKNode node];
        [self addChild: text];
        
        //stop button
        stop = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        stop.text = @"Stop";
        stop.name = @"stop";
        stop.fontSize = 40;
        stop.fontColor = [SKColor blueColor];
        stop.position = CGPointMake(150,400);
        stop.zPosition = 50;
        [_HUDLayer addChild:stop];
        
        [self ScrollingBackground]; //scrolling sky
        [self ScrollingForeground]; //scrolling tracks
        [self train];
        [self stopSign1];
        [self mountain];
        
        //skip button
        skip = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP"; //Set the button text
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [_HUDLayer addChild:skip]; //add node to screen
        
        //level
        instructions = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        instructions.text = @"Level 5";
        instructions.fontColor = [SKColor redColor];
        instructions.position = CGPointMake(self.size.width/2, 550);
        [text addChild:instructions];
        
        AVSpeechUtterance *level = [[AVSpeechUtterance alloc] initWithString:@"Level 5."];
        level.rate = 0.1;
        [self.synthesizer speakUtterance:level];
        [self timer]; //wait for level declaration, then play first instruction
        
        //start train moving
        [train.physicsBody applyImpulse:CGVectorMake(1, 0)];
        [stopSign1.physicsBody applyImpulse:CGVectorMake(-2, 0)];
    }
    return self;
}


-(void)mountain {
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


-(void)clouds {
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Clouds.png"];
    
    for (int i=0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 500);
        [_bgLayer addChild:sprite];
    }
}


-(void)train {
    train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];
    train.position = CGPointMake(60, 100);
    train.zPosition = 50;
    train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(55, 20)]; //x used to be 25
    train.physicsBody.dynamic = YES;
    train.physicsBody.affectedByGravity = NO;
    train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:train];
}


-(void)rail {
    rail = [SKSpriteNode spriteNodeWithImageNamed:@"Rail.png"];
    rail.position = CGPointMake(917, 36);
    [_bgLayer addChild:rail];
}


-(void)stopSign1 {
    stopSign1 = [SKSpriteNode spriteNodeWithImageNamed:@"StopSign.png"];
    stopSign1.name = @"stop1";
    stopSign1.position = CGPointMake(1075,260);
    stopSign1.zPosition = 40;
    stopSign1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 20)];
    stopSign1.physicsBody.dynamic = YES;
    stopSign1.physicsBody.affectedByGravity = NO;
    stopSign1.physicsBody.allowsRotation = NO;
    [stopSign1 runAction:[SKAction moveTo:CGPointMake(-225, 260) duration:60] completion:^{}];
    [_gameLayer addChild:stopSign1];
}


-(void)stopSign2 {
    stopSign2 = [SKSpriteNode spriteNodeWithImageNamed:@"StopSign.png"];
    stopSign2.name = @"stop2";
    stopSign2.position = CGPointMake(1275,260);
    stopSign2.zPosition = 40;
    stopSign2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 20)];
    stopSign2.physicsBody.dynamic = YES;
    stopSign2.physicsBody.affectedByGravity = NO;
    stopSign2.physicsBody.allowsRotation = NO;
    [stopSign2 runAction:[SKAction moveTo:CGPointMake(-225, 260) duration:60] completion:^{}];
    [_gameLayer addChild:stopSign2];
}


-(void)stopSign3 {
    stopSign3 = [SKSpriteNode spriteNodeWithImageNamed:@"StopSign.png"];
    stopSign3.name = @"stop3";
    stopSign3.position = CGPointMake(1275,260);
    stopSign3.zPosition = 40;
    stopSign3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 20)];
    stopSign3.physicsBody.dynamic = YES;
    stopSign3.physicsBody.affectedByGravity = NO;
    stopSign3.physicsBody.allowsRotation = NO;
    [stopSign3 runAction:[SKAction moveTo:CGPointMake(-225, 260) duration:60] completion:^{}];
    [_gameLayer addChild:stopSign3];
}


-(void)ScrollingForeground { //Scrolling tracks function
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


-(void)ScrollingBackground {   //scrolling background function
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Clouds.png"];        //reuse sky image
    SKAction *moveBg= [SKAction moveByX:-backgroundTexture.size.width y:0 duration: 0.1*speed*backgroundTexture.size.width]; //move Bg
    SKAction *resetBg = [SKAction moveByX:backgroundTexture.size.width*2 y:0 duration:0];   //reset background
    SKAction *moveBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];    //repeat moveBg and resetBg
    
    for(int i =0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) {     //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 500);
        [sprite runAction:moveBackgroundForever];
        [_bgLayer addChild:sprite];
    }
}


-(void)nextLevel { //transition to next level/finish screen
    //remove instructions
    [text removeFromParent];
    text = [SKNode node];
    [self addChild: text];
    
    nextButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    nextButton.text = @"Go to Level 5";
    nextButton.fontColor = [SKColor blueColor];
    nextButton.color = [SKColor yellowColor];
    nextButton.position = CGPointMake(self.size.width/2, 550);
    nextButton.name = @"level5";
    nextButton.zPosition=50;
    [self addChild:nextButton];
}


-(void)tryAgain { //replay level 5 if not completed
    //remove instructions
    [text removeFromParent];
    text = [SKNode node];
    [self addChild: text];
    
    tryAgainButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    tryAgainButton.text = @"Try Again";
    tryAgainButton.fontColor = [SKColor blueColor];
    tryAgainButton.position = CGPointMake(self.size.width/2, 550);
    tryAgainButton.zPosition = 50;
    tryAgainButton.name = @"level5";
    [self addChild:tryAgainButton];
}


-(void)stopTrain {
    speed = 0;
        
    [_bgLayer removeFromParent];
    [_gameLayer removeFromParent];
        
    _bgLayer = [SKNode node];
    [self addChild: _bgLayer];
    _gameLayer = [SKNode node];
    [self addChild: _gameLayer];
        
    [self ScrollingForeground];
    [self train];
    train.position = CGPointMake(250, 100);
    [self rail];
    [self clouds];
    
    if(chances == 3) {
        [self stopSign1];
        stopSign1.position = CGPointMake(550, 260);
    }
    else if(chances == 2) {
        [self stopSign2];
        stopSign2.position = CGPointMake(550, 260);
    }
    else if(chances == 1) {
        [self stopSign3];
        stopSign3.position = CGPointMake(550, 260);
    }
    
    [self nextLevel]; //after stopping, call next level function
    if (click >= 0) {
        AVSpeechUtterance *next = [[AVSpeechUtterance alloc] initWithString:@"Good Job! You completed the level"];
        next.rate = 0.1;
        [self.synthesizer speakUtterance:next];
        click = -1; //stop speech from playing more than once
    }
}


-(void)timer { //wait 5 seconds for level declaration before first instructions are displayed
    inst1 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(firstInst) userInfo:nil repeats:NO];
}


-(void)firstInst { //first instructions
    [text removeFromParent];
    text = [SKNode node];
    [self addChild: text];
    instructions = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructions.text = @"Tell the train to stop";
    instructions.fontColor = [SKColor redColor];
    instructions.position = CGPointMake(self.size.width/2, 550);
    [text addChild:instructions];
    
    AVSpeechUtterance *instruction1 = [[AVSpeechUtterance alloc] initWithString:@"Tell the train to stop"];
    instruction1.rate = 0.1;
    [self.synthesizer speakUtterance:instruction1];
}


-(void)update:(NSTimeInterval)currentTime {
    if (click == 1) {
        if (chances == 3 && stopSign1.position.x <= 550)
            [self stopTrain];
        else if (chances == 2 && stopSign2.position.x <= 550)
            [self stopTrain];
        else if (chances == 1 && stopSign3.position.x <= 550)
            [self stopTrain];
    }
    else if (click == 0) {
        if (chances == 3 && stopSign1.position.x <= 550) {
            chances--;
            [self stopSign2]; //start second stop sign
            [stopSign2.physicsBody applyImpulse:CGVectorMake(-2, 0)];
            
            //new instructions
            [text removeFromParent];
            text = [SKNode node];
            [self addChild: text];
            instructions = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            instructions.text = @"Follow the sign by telling the train to stop";
            instructions.fontColor = [SKColor redColor];
            instructions.position = CGPointMake(self.size.width/2, 550);
            [text addChild:instructions];
            
            AVSpeechUtterance *instruction2 = [[AVSpeechUtterance alloc] initWithString:@"Follow the sign by telling the train to stop"];
            instruction2.rate = 0.1;
            [self.synthesizer speakUtterance:instruction2];
        }
        else if (chances == 2 && stopSign2.position.x <= 550) {
            chances--;
            [self stopSign3]; //start third stop sign
            [stopSign3.physicsBody applyImpulse:CGVectorMake(-2, 0)];
            
            //new instructions
            [text removeFromParent];
            text = [SKNode node];
            [self addChild: text];
            instructions = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            instructions.text = @"Can you say stop?";
            instructions.fontColor = [SKColor redColor];
            instructions.position = CGPointMake(self.size.width/2, 550);
            [text addChild:instructions];
            
            AVSpeechUtterance *instruction3 = [[AVSpeechUtterance alloc] initWithString:@"Can you say stop?"];
            instruction3.rate = 0.1;
            [self.synthesizer speakUtterance:instruction3];
        }
        else if (chances == 1 && stopSign3.position.x <= 550) {
            chances--;
        }
    }
    
    if (chances == 0 && click >= 0) {
        [self tryAgain];
        
        AVSpeechUtterance *again = [[AVSpeechUtterance alloc] initWithString:@"You missed all your stops.  Let's try level 5 again"];
        again.rate = 0.1;
        [self.synthesizer speakUtterance:again];
        
        click--; //stop speech from playing more than once
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    button = [self nodeAtPoint:location];
    
    if ([button.name  isEqual: @"stop"]) {
        click = 1; //train is stopped
    }
    else if ([button.name isEqualToString:@"level5"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level5 *scene = [Level5 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    else if ([button.name isEqualToString:@"Skip"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level5 *scene = [Level5 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    //include touch to transition to next level/completion screen
}


@end