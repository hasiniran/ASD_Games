//
//  GameScene.m
//  Autism_train
//
//  Created by Matthew Perez on 1/28/15.
//  Copyright (c) 2015 Matthew Perez. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Level1.h"


@implementation Level1 {
    SKSpriteNode *train;
    SKSpriteNode *station;
    SKSpriteNode *rail;
    SKSpriteNode *smoke;
    SKLabelNode *skip;
    SKLabelNode *go;
    SKLabelNode *nextButton;
    SKLabelNode *instructionText;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    SKNode *button;
    NSTimer *instructionTimer;
    double speed;
    bool first;
    bool firstTouch;
    int instructions;
}


-(id)initWithSize:(CGSize)size {
    speed = 0;
    first = true;
    firstTouch = true;
    instructions = 0;
    
    if(self = [super initWithSize:size]) {
        //initialize synthesizer
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        
        //add layers
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        
        //skip button
        skip= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP"; //Set the button text
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [self addChild:skip]; //add node to screen
        
        //go button
        go = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        go.text = @"Go"; //Set the button text
        go.name = @"Go";
        go.fontSize = 40;
        go.fontColor = [SKColor blueColor];
        go.position = CGPointMake(500,200);
        go.zPosition = 150;
        [self addChild:go]; //add node to screen
        
        
        //instructions
        instructionText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        instructionText.name = @"instructionText";
        instructionText.fontSize = 40;
        instructionText.fontColor = [SKColor redColor];
        instructionText.position = CGPointMake(500,500);
        instructionText.zPosition = 50;
        [self addChild:instructionText];
        
        //stationary background
        [self ScrollingForeground]; //places first rail -- doesn't appear to be scrolling
        [self clouds];
        
        //add objects
        [self train];
        [self station];
        [self rail];
        [self mountain];
        
        [self timer];
    }
    return self;
}


-(void)ScrollingForeground { //Scrolling tracks (place first rail)
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"Rail.png"]; //change runway to train tracks
    SKAction *moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:.02*speed*groundTexture.size.width*2];
    SKAction *resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction *moveGroundSpriteForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for(int i=0; i<2 +self.frame.size.width/(groundTexture.size.width);i++){      //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [sprite setScale:1];
        sprite.zPosition = 10;
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(i*sprite.size.width, 0);
        [sprite runAction:moveGroundSpriteForever];
        [_bgLayer addChild:sprite];
    }
}


-(void)ScrollingBackground {  //scrolling background
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Clouds.png"];        //reuse sky image
    SKAction *moveBg= [SKAction moveByX:-backgroundTexture.size.width y:0 duration: 0.1*speed*backgroundTexture.size.width]; //move Bg
    SKAction *resetBg = [SKAction moveByX:backgroundTexture.size.width*2 y:0 duration:0];   //reset background
    SKAction *moveBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];    //repeat moveBg and resetBg
    
    for(int i =0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++){     //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 500);
        [sprite runAction:moveBackgroundForever];
        [_bgLayer addChild:sprite];
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


-(void)train {   //Moving object
    train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];
    train.position = CGPointMake(60, 100);
    train.zPosition = 50;
    train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    train.physicsBody.dynamic = YES;
    train.physicsBody.affectedByGravity = NO;
    train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:train];
}


-(void)smoke {   //Moving object
    smoke = [SKSpriteNode spriteNodeWithImageNamed:@"TrainSmoke.jpg"]; //ask Adriana to make better smoke image/sprite
    smoke.position = CGPointMake(315, 285);
    smoke.zPosition = 50;
    [smoke setScale:.5];
    smoke.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    smoke.physicsBody.dynamic = YES;
    smoke.physicsBody.affectedByGravity = NO;
    smoke.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:smoke];
}


-(void)station {
    station = [SKSpriteNode spriteNodeWithImageNamed:@"Station2.png"];
    station.position = CGPointMake(150, 170);
    station.zPosition = 20;
    station.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    station.physicsBody.affectedByGravity = NO;
    station.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:station];
}


-(void)rail {
    rail = [SKSpriteNode spriteNodeWithImageNamed:@"Rail.png"];
    rail.position = CGPointMake(917, 36);
    [_gameLayer addChild:rail];
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


-(void)timer { //keep accessing instructionSpeech until child starts playing
    instructionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(giveInstructions) userInfo:nil repeats:YES];
}


-(void)giveInstructions { //keep repeating different instructions
    //instructions start at 1 to delay for game selection message
    if (instructions == 1) { //level declaration
        instructionText.text = @"Level 1";
        
        AVSpeechUtterance *instruction1 = [[AVSpeechUtterance alloc] initWithString:@"Level 1"];
        instruction1.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction1.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction1];
    }
    else if (instructions == 3) { //initial instructions
        instructionText = (SKLabelNode *) [self childNodeWithName:@"instructionText"]; //clear previous text
        instructionText.text = @"Tell the train to go!"; //place new text
        
        AVSpeechUtterance *instruction2 = [[AVSpeechUtterance alloc] initWithString:@"Tell the train to go!"];
        instruction2.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction2.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction2];
    }
    else if (instructions == 11) { //wait 10 secs -- follow up 1
        instructionText = (SKLabelNode *) [self childNodeWithName:@"instructionText"];
        instructionText.text = @"Help the train move by saying go!";
        
        AVSpeechUtterance *instruction3 = [[AVSpeechUtterance alloc] initWithString:@"Help the train move by saying go!"];
        instruction3.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction3.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction3];
    }
    else if (instructions == 21) { //wait 10 secs -- follow up 2
        instructionText = (SKLabelNode *) [self childNodeWithName:@"instructionText"];
        instructionText.text = @"Say go!";
        
        AVSpeechUtterance *instruction4 = [[AVSpeechUtterance alloc] initWithString:@"Say go!"];
        instruction4.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction4.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction4];
    }
    else if (instructions > 30) { //wait another 10 secs -- restart instructions
        instructions = 1;
    }
    
    instructions++;
}


-(void)nextLevel {
    train.physicsBody.velocity = CGVectorMake(0, 0);   //stop train
    station.physicsBody.velocity = CGVectorMake(0, 0); //stop station from moving away
    
    //stop scrolling background
    [_bgLayer removeFromParent];
    _bgLayer = [SKNode node];
    [self addChild: _bgLayer];
    
    [self ScrollingForeground];
    [self clouds];
    
    if(first == true){ //display Level 2 message
        nextButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        nextButton.text = @"Go to Level 2";
        nextButton.fontColor = [SKColor blueColor];
        nextButton.color = [SKColor yellowColor];
        nextButton.position = CGPointMake(self.size.width/2, self.size.height/2);
        nextButton.name = @"level2";
        [_HUDLayer addChild:nextButton];
        
        AVSpeechUtterance *next = [[AVSpeechUtterance alloc] initWithString:@"Good Job! Continue on to level 2."];
        next.rate = AVSpeechUtteranceMinimumSpeechRate;
        next.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:next];
        
        first = false;
    }
}


-(void)update:(NSTimeInterval)currentTime {
    if(train.position.x >= 1350){   //call next level function once train reaches right side of screen -- 700=front reaches end, 1350=train completely off screen
        [self nextLevel];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    speed = 1;  //set speed to 1 which starts background scrolling
    
    //stop repeating instructions
    [instructionTimer invalidate];
    instructionTimer = nil;
    
    if (firstTouch==true){  //initial touch
        [_bgLayer removeFromParent];
        [_gameLayer removeFromParent];
        
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        
        //moving scene
        [self ScrollingBackground];
        [self ScrollingForeground];
        
        [self train];
        [self smoke]; //visible smoke to indicate train movement
        [self station];
        station.physicsBody.velocity = CGVectorMake(-25, 0); //move station out of scene as train moves forward
        
        firstTouch = false; //any touches after are not initial touch
    }
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    button = [self nodeAtPoint:location];
    NSLog(@"%@", button.name);
    NSLog(@"This came here");
    if ([button.name isEqualToString:@"level2"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level2 *scene = [Level2 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    else if ([button.name isEqualToString:@"Go"]) {
        NSLog(@"Pushed Go");
        [train.physicsBody applyImpulse:CGVectorMake(5, 0)];
        [smoke.physicsBody applyImpulse:CGVectorMake(5, 0)];
    }
    else if ([button.name isEqualToString:@"Skip"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level2 *scene = [Level2 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
}


@end
