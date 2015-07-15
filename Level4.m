//
//  Level4.m
//  ASD_Game
//  Previously Level5
//
//  Created by Matthew Perez on 3/20/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Level4.h"
#import <AVFoundation/AVFoundation.h>


@implementation Level4 {
    SKSpriteNode *train;
    SKSpriteNode *barn;
    SKSpriteNode *rail;
    SKSpriteNode *cow;
    SKSpriteNode *pig;
    SKSpriteNode *horse;
    AVAudioPlayer *audio;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    SKNode *text;
    SKNode *button;
    SKLabelNode *skip;
    SKLabelNode *horseButton;
    SKLabelNode *pigButton;
    SKLabelNode *cowButton;
    SKLabelNode *tryAgainButton;
    SKLabelNode *display;
    NSTimer *sounds;
    double speed;
    int count;
    int state;
    int chances;
    int interval; //used to increment animal sounds
    int mult;
    int space;
}


-(id)initWithSize:(CGSize)size {
    count = 0;
    state = -1;
    speed = 1;
    chances = 3;
    interval = 1;
    mult = 1;
    
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
        [self addChild:text];
        
        //add objects
        [self mountain];
        [self ScrollingForeground];
        [self ScrollingBackground];
        [self barn];
        [self train];
        [train.physicsBody applyForce:CGVectorMake(65, 0)];
        
        //skip button
        skip= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP";
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [_HUDLayer addChild:skip];
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


-(void)tracks {
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Rail.png"];
    
    for (int i=0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 0);
        [_bgLayer addChild:sprite];
    }
}


-(void)barn {
    barn = [SKSpriteNode spriteNodeWithImageNamed:@"BarnLarge.png"];
    [barn setScale:1.5]; //make barn proportionately larger
    barn.position = CGPointMake(550, 330);
    barn.zPosition = 5;
    barn.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    barn.physicsBody.affectedByGravity = NO;
    barn.physicsBody.allowsRotation = NO;
    barn.physicsBody.dynamic = NO;
    [_gameLayer addChild:barn];
}


-(void)train {
    train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];
    train.position = CGPointMake(50, 100);
    train.zPosition = 50;
    train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    train.physicsBody.dynamic = YES;
    train.physicsBody.affectedByGravity = NO;
    train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:train];
}


-(void)cow {
    cow = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow.name = @"cow";
    cow.position = CGPointMake(740, 280);
    cow.zPosition = -5;
    cow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    cow.physicsBody.affectedByGravity = NO;
    cow.physicsBody.allowsRotation = NO;
    [_HUDLayer addChild:cow];
}


-(void)pig {
    pig= [SKSpriteNode spriteNodeWithImageNamed:@"Pig.png"];
    [pig setScale:.3];
    pig.name = @"pig";
    pig.position = CGPointMake(380, 340);
    pig.zPosition = -5;
    pig.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    pig.physicsBody.affectedByGravity = NO;
    pig.physicsBody.allowsRotation = NO;
    [_HUDLayer addChild:pig];
}


-(void)horse {
    horse = [SKSpriteNode spriteNodeWithImageNamed:@"Horse.png"];
    horse.name = @"horse";
    [horse setScale:.4];
    horse.position = CGPointMake(720, 330);
    horse.zPosition = -5;
    horse.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    horse.physicsBody.affectedByGravity = NO;
    horse.physicsBody.allowsRotation = NO;
    horse.physicsBody.collisionBitMask = NO;
    [_HUDLayer addChild:horse];
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
        [_bgLayer addChild:sprite];
    }
}


-(void)ScrollingBackground {   //scrolling clouds
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


-(void)stopTrain {
    state++;    //train is stopped
    train.physicsBody.velocity = CGVectorMake(0, 0);
}


-(void)animals {
    [self cow];
    [self pig];
    [self horse];
}


-(void)timer { //keep accessing displayText until child starts playing
    sounds = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animalSound) userInfo:nil repeats:YES];
}


-(void)animalSound {
    // Construct URL to sound file
    NSString *path;
    
    if(interval == 1 || interval == (mult*space)) { //Play sound immediately with instructions, then incrementally (different increments set depending on length of recording)
        if(state == 3) {//horse
            path = [NSString stringWithFormat:@"%@/Horse Whinny-3.mp3", [[NSBundle mainBundle] resourcePath]]; //changed to pig.mp3 from Horse Whinny.mp3
        }
        else if(state == 4) {//pig
            path = [NSString stringWithFormat:@"%@/pig.mp3", [[NSBundle mainBundle] resourcePath]];
        }
        else if(state == 5) {//cow
            path = [NSString stringWithFormat:@"%@/cow.mp3", [[NSBundle mainBundle] resourcePath]];
        }
        mult++;
    
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
        // Create audio player object and initialize with URL to sound
        audio = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        [audio play];
    }
    interval++;
}


//buttons for each animal to register click -- placed over the sprite of the animal
-(void)horseButton {
    horseButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    horseButton.text = @"Horse";
    horseButton.name = @"horseButton";
    horseButton.hidden = YES; //hide button so it appears to be just the image
    horseButton.yScale=2;
    horseButton.fontSize = 40;
    horseButton.fontColor = [SKColor blueColor];
    horseButton.position = CGPointMake(720,380); //x,y values of position are different from the object
    horseButton.zPosition = 50;
    [_gameLayer addChild:horseButton];
}


-(void)pigButton {
    pigButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    pigButton.text = @"Pig";
    pigButton.name = @"pigButton";
    pigButton.hidden = YES;
    pigButton.yScale=2;
    pigButton.fontSize = 40;
    pigButton.fontColor = [SKColor blueColor];
    pigButton.position = CGPointMake(214,265);
    pigButton.zPosition = 50;
    [_gameLayer addChild:pigButton];
}


-(void)cowButton {
    cowButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    cowButton.text = @"Cow";
    cowButton.name = @"cowButton";
    cowButton.hidden = YES;
    cowButton.yScale=2;
    cowButton.fontSize = 40;
    cowButton.fontColor = [SKColor blueColor];
    cowButton.position = CGPointMake(905,210);
    cowButton.zPosition = 50;
    [_gameLayer addChild:cowButton];
}


-(void)instructions {
    [text removeFromParent];//clear text
    text = [SKNode node];
    [self addChild:text];
    
    display = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    display.fontColor = [SKColor redColor];
    display.position = CGPointMake(self.size.width/2, 550);
    [text addChild:display];
}


-(void)nextLevel {
    NSString * nxtLevel= @"Go to Level 5";
    SKLabelNode *Button = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Button.text = nxtLevel;
    Button.fontColor = [SKColor blueColor];
    Button.color = [SKColor yellowColor];
    Button.position = CGPointMake(500, 600);
    Button.name = @"level5";
    [self addChild:Button];
    
    AVSpeechUtterance *next = [[AVSpeechUtterance alloc] initWithString:@"Good Job! Continue on to level 5."];
    next.rate = 0.1;
    [self.synthesizer speakUtterance:next];
}


-(void)hint { //points arrow at animal to be chosen
    SKSpriteNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];
    
    if(state == 3){ //horse
        arrow.position = CGPointMake(780, 480);
    }
    if(state == 4){
        arrow.position = CGPointMake(280, 360);//pig
    }
    if(state == 5){
        arrow.position = CGPointMake(945, 310); //cow
    }
    
    [arrow setScale:.8];
    [text addChild:arrow];
}

/*
-(void)hint2 {
    SKLabelNode *Button = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    NSString *nxtLevel;
    
    if(state == 3){
        nxtLevel= @"HORSE";
        Button.position = CGPointMake(630, 510);
        Button.fontColor = [SKColor brownColor];
    }
    if(state == 5 || state == 4){
        nxtLevel= @"PIG";
        Button.position = CGPointMake(350, 290);
        Button.fontColor = [SKColor magentaColor];
    }
    if(state == 7 || state == 6){
        nxtLevel= @"COW";
        Button.position = CGPointMake(870, 290);
        Button.fontColor = [SKColor grayColor];
    }
    Button.text = nxtLevel;
    [text addChild:Button];
}
*/

-(void)incorrect {
    SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lives.text =[NSString stringWithFormat:@"Chances: %d", chances];
    lives.fontColor = [SKColor redColor];
    lives.position =CGPointMake(self.size.width/2, self.size.height/2 + 200);
    
    SKAction *flashAction = [SKAction sequence:@[[SKAction fadeInWithDuration:1/3.0],[SKAction waitForDuration:1], [SKAction fadeOutWithDuration:1/3.0]]];
    // run the sequence then delete the label
    
    if(chances <= 0) {
        //stop timer for playing sounds
        [sounds invalidate];
        sounds = nil;
        
        [text removeFromParent];//clear text
        [self tryAgain]; //try level again if all chances are used up
    }
    
    [lives runAction:flashAction completion:^{[lives removeFromParent];}];
    [text addChild:lives];
}


-(void)tryAgain { //replay level 4 if not completed
    [text removeFromParent];   //clear text
    text = [SKNode node];
    [self addChild:text];
    
    AVSpeechUtterance *again = [[AVSpeechUtterance alloc] initWithString:@"Let's try level 4 again."];
    again.rate = 0.1;
    [self.synthesizer speakUtterance:again];
    
    tryAgainButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    tryAgainButton.text = @"Try Again";
    tryAgainButton.fontColor = [SKColor blueColor];
    tryAgainButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    tryAgainButton.zPosition = 10;
    tryAgainButton.name = @"level4";
    [text addChild:tryAgainButton];
}


-(void)update:(NSTimeInterval)currentTime {
    if(state == -1) {
        //level name
        [self instructions];
        display.text = @"Level 4";
        AVSpeechUtterance *level = [[AVSpeechUtterance alloc] initWithString:@"Level 4."];
        level.rate = 0.1;
        [self.synthesizer speakUtterance:level];
        
        state++;
    }
    if(state == 0) { //train is moving
        if(train.position.x >= 350){ //stop train movement in front of barn
            [_bgLayer removeFromParent];
            _bgLayer = [SKNode node];
            [self addChild: _bgLayer];
            
            [self mountain];
            [self clouds];
            [self tracks];
            [self barn];
            [self stopTrain];
            [self animals];
        }
    }
    if(state == 1) {  //train is stopped
        if(count >= 10) {
            cow.physicsBody.velocity = CGVectorMake(0, 0);
            pig.physicsBody.velocity = CGVectorMake(0, 0);
            horse.physicsBody.velocity = CGVectorMake(0, 0);
            state++;
            count = 0;
        }
        else { //move animals out from behind barn
            count++;
            [cow.physicsBody applyImpulse:CGVectorMake(2, -.5)];
            [pig.physicsBody applyImpulse:CGVectorMake(-2, -.5)];
            [horse.physicsBody applyImpulse:CGVectorMake(0, 1)];
        }
    }
    if(state == 2) {   //animals out of barn
        //display animals sounds
        //ask question
        [self instructions];
        display.text = @"Say the animal that makes this noise";
        
        AVSpeechUtterance *instruction1 = [[AVSpeechUtterance alloc] initWithString:@"Say the animal that makes this noise"];
        instruction1.rate = 0.1;
        [self.synthesizer speakUtterance:instruction1];
        
        space = 2; //play horse whinny every other time
        [self timer];
        [self horseButton];
        [self pigButton];
        [self cowButton];
        state++; //make sure animal sound does not play infinitely
    }
    //state 3 == wait for Horse touch
    //state 4 == wait for Pig touch
    //state 5 == wait for Cow touch
    if(state == 6) { //level complete
        //stop timer for playing sounds
        [sounds invalidate];
        sounds = nil;
        
        train.physicsBody.velocity = CGVectorMake(55, 0);
        if(train.position.x >= 750){
            [self nextLevel];
            train.physicsBody.velocity = CGVectorMake(0, 0);
        }
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self instructions];
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    button = [self nodeAtPoint:location];
    
    if(state==3) {
        if([button.name isEqual:@"horseButton"]) { //correct
            display.text = @"Say the animal that makes this noise";
            
            AVSpeechUtterance *instruction2 = [[AVSpeechUtterance alloc] initWithString:@"Say the animal that makes this noise"];
            instruction2.rate = 0.1;
            [self.synthesizer speakUtterance:instruction2];
            
            space = 1; //play pig oink every time
            interval = 1; //restart interval
            mult = 1;
            
            state++;
        }
        else if([button.name isEqual:@"cowButton"] || [button.name isEqual:@"pigButton"]) { //incorrect
            chances--;
            [self incorrect];

            if(chances == 2) {
                display.text = @"What animal makes this sound?";
                AVSpeechUtterance *instruction1a = [[AVSpeechUtterance alloc] initWithString:@"What animal makes this sound?"];
                instruction1a.rate = 0.1;
                [self.synthesizer speakUtterance:instruction1a];
                [self hint];
            }
            else if(chances == 1) {
                display.text = @"It's the horse.  Can you say HORSE?";
                AVSpeechUtterance *instruction1b = [[AVSpeechUtterance alloc] initWithString:@"It's the horse. Can you say HORSE?"];
                instruction1b.rate = 0.1;
                [self.synthesizer speakUtterance:instruction1b];
                [self hint];
            }
        }
    }
    else if(state==4) {
        if([button.name isEqual: @"pigButton"]) { //correct
            display.text = @"Say the animal that makes this noise";
            
            AVSpeechUtterance *instruction3 = [[AVSpeechUtterance alloc] initWithString:@"Say the animal that makes this noise"];
            instruction3.rate = 0.1;
            [self.synthesizer speakUtterance:instruction3];
            
            space = 4; //play cow moo every fourth time
            interval = 1; //restart interval
            mult = 1;
            
            state++;
        }
        else if([button.name isEqual:@"cowButton"] || [button.name isEqual:@"horseButton"]) { //incorrect
            chances--;
            [self incorrect];
            
            if(chances == 2) {
                display.text = @"What animal makes this sound?";
                AVSpeechUtterance *instruction2a = [[AVSpeechUtterance alloc] initWithString:@"What animal makes this sound?"];
                instruction2a.rate = 0.1;
                [self.synthesizer speakUtterance:instruction2a];
                [self hint];
            }
            else if(chances == 1) {
                display.text = @"It's the pig.  Can you say PIG?";
                AVSpeechUtterance *instruction2b = [[AVSpeechUtterance alloc] initWithString:@"It's the pig. Can you say PIG?"];
                instruction2b.rate = 0.1;
                [self.synthesizer speakUtterance:instruction2b];
                [self hint];
            }
        }
    }
    else if(state==5) {
        if([button.name isEqual: @"cowButton"]) { //correct -> display next level
            [text removeFromParent];//clear text
            text = [SKNode node];
            [self addChild:text];
            state++;
            [self nextLevel];
        }
        else if([button.name isEqual:@"pigButton"] || [button.name isEqual:@"horseButton"]) { //incorrect
            chances--;
            [self incorrect];
            
            if(chances == 2) {
                display.text = @"What animal makes this sound?";
                AVSpeechUtterance *instruction3a = [[AVSpeechUtterance alloc] initWithString:@"What animal makes this sound?"];
                instruction3a.rate = 0.1;
                [self.synthesizer speakUtterance:instruction3a];
                [self hint];
            }
            else if(chances == 1) {
                display.text = @"It's the cow.  Can you say COW?";
                AVSpeechUtterance *instruction3b = [[AVSpeechUtterance alloc] initWithString:@"It's the cow.  Can you say COW?"];
                instruction3b.rate = 0.1;
                [self.synthesizer speakUtterance:instruction3b];
                [self hint];
            }
        }
    }
    
    if([button.name isEqual: @"level5"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level5 *scene = [Level5 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    if([button.name isEqual:@"level4"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level4 *scene = [Level4 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    else if([button.name isEqual:@"Skip"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level5 *scene = [Level5 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
}


@end