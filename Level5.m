//
//  Level5.m
//  ASD_Game
//
//  Created by Matthew Perez on 3/20/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import "Level5.h"
#import <AVFoundation/AVFoundation.h>

@implementation Level5{
    SKSpriteNode *_train;
    SKSpriteNode *barn;
    SKSpriteNode *rail;
    SKSpriteNode *cow;
    SKSpriteNode *pig;
    SKSpriteNode *horse;
    AVAudioPlayer *_audio;
    SKNode *_bgLayer;   //Permanent Layer (Mountains)
    SKNode *_HUDLayer;  //Static Layer
    SKNode *_gameLayer; //Moving Layer
    SKNode *_text;      //TextLayer
    double speed;
    int count;
    int state; //keep track of train states
    int count2;
    int chances;
    //check 0 = moving, check 1 = stop, check 2 = moving, check 4 display
}

/******MAIN******/
-(id)initWithSize:(CGSize)size{
    count = 0;
    state = 0;
    speed = 1;
    chances = 3;
    if(self = [super initWithSize:size]){
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        _text = [SKNode node];
        [self addChild:_text];
        
        [self addMountain];
        [self initScrollingClouds];
        [self addBarn];
        [self addTracks];
        [self train];
        [_train.physicsBody applyForce:CGVectorMake(65, 0)];
        
    }
    return self;
}

/******STATIONARY OBJECTS**********/
-(void)addMountain{
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

-(void)addClouds{
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

-(void)addTracks{
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

-(void)addBarn{
    barn = [SKSpriteNode spriteNodeWithImageNamed:@"BarnLarge.png"];//change to train png
    barn.position = CGPointMake(550, 300);
    barn.zPosition = 5;
    barn.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    barn.physicsBody.affectedByGravity = NO;
    barn.physicsBody.allowsRotation = NO;
    barn.physicsBody.dynamic=NO;
    [_gameLayer addChild:barn];
}

-(void)train{   //Moving object
    _train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];//change to train png
    _train.position = CGPointMake(50, 100);
    _train.zPosition = 50;
    _train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    _train.physicsBody.dynamic = YES;
    _train.physicsBody.affectedByGravity = NO;
    _train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:_train];
}

-(void)addCow{
    cow = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];//change to train png
    cow.name = @"cow";
    cow.position = CGPointMake(530, 280);
    cow.zPosition = -5;
    cow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    cow.physicsBody.affectedByGravity = NO;
    cow.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:cow];
}
-(void)addPig{
    pig= [SKSpriteNode spriteNodeWithImageNamed:@"Pig.png"];//change to train png
    [pig setScale:.3];
    pig.name = @"pig";
    pig.position = CGPointMake(470, 280);
    pig.zPosition = -5;
    pig.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    pig.physicsBody.affectedByGravity = NO;
    pig.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:pig];
}
-(void)addHorse{
    horse = [SKSpriteNode spriteNodeWithImageNamed:@"Horse.png"];//change to train png
    horse.name = @"horse";
    [horse setScale:.4];
    horse.position = CGPointMake(500, 330);
    horse.zPosition = -5;
    horse.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    horse.physicsBody.affectedByGravity = NO;
    horse.physicsBody.allowsRotation = NO;
    horse.physicsBody.collisionBitMask=NO;
    [_gameLayer addChild:horse];
}

/******MOVING OBJECTS**********/
-(void)initScrollingTracks{ //Scrolling tracks function
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
        [_gameLayer addChild:sprite];
    }
}

-(void)initScrollingClouds{   //scrolling CLOUDS function
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

-(void)stopTrain{
    state++;    //train is stopped
    _train.physicsBody.velocity = CGVectorMake(0, 0);
}

-(void)spawnAnimals{
    [self addHorse];
    [self addCow];
    [self addPig];
}

-(void)animalSound{
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/Horse Whinny.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    _audio = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_audio play];
}

-(void)danceHorse{
    horse.physicsBody.allowsRotation = YES;
    [horse.physicsBody applyAngularImpulse:7];
}
-(void)dancePig{
    pig.physicsBody.allowsRotation = YES;
    [pig.physicsBody applyAngularImpulse:7];
}
-(void)danceCow{
    cow.physicsBody.allowsRotation = YES;
    [cow.physicsBody applyAngularImpulse:7];
}

-(void)horseButton{
    SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    go.text = @"Horse"; //Set the button text
    go.name = @"Horse";
    go.hidden = YES;
    go.yScale=2;
    go.fontSize = 40;
    go.fontColor = [SKColor blueColor];
    go.position = CGPointMake(500,430);
    go.zPosition = 50;
    [_gameLayer addChild:go]; //add node to screen
}
-(void)pigButton{
    SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    go.text = @"Pig"; //Set the button text
    go.name = @"Pig";
    go.hidden = YES;
    go.yScale=2;
    go.fontSize = 40;
    go.fontColor = [SKColor blueColor];
    go.position = CGPointMake(230,200);
    go.zPosition = 50;
    [_gameLayer addChild:go]; //add node to screen
}
-(void)cowButton{
    SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    go.text = @"Cow"; //Set the button text
    go.name = @"Cow";
    go.hidden = YES;
    go.yScale=2;
    go.fontSize = 40;
    go.fontColor = [SKColor blueColor];
    go.position = CGPointMake(750,200);
    go.zPosition = 50;
    [_gameLayer addChild:go]; //add node to screen
}
-(void)nextLevel{
    NSString * nxtLevel= @"Go to Level 6";
    SKLabelNode *Button = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Button.text = nxtLevel;
    Button.fontColor = [SKColor blueColor];
    Button.color = [SKColor yellowColor];
    Button.position = CGPointMake(500, 600);
    Button.name = @"level6";
    [self addChild:Button];
}
-(void)hint{
    SKSpriteNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];//change to train png
    if(state == 3){
        arrow.position = CGPointMake(530, 500);
    }
    if(state == 5){
        arrow.position = CGPointMake(290, 280);//pig
    }
    if(state == 7){
            arrow.position = CGPointMake(800, 280); //cow
    }
    [arrow setScale:.5];
    [_text addChild:arrow];

}
-(void)hint2{
    NSString *nxtLevel= @"HORSE";
    SKLabelNode *Button = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Button.text = nxtLevel;
    Button.fontColor = [SKColor brownColor];
    Button.color = [SKColor yellowColor];
    Button.position = CGPointMake(630, 510);
    Button.name = @"level6";
    [_text addChild:Button];
}
-(void)question{
    NSString *question= @"Say the animal that makes this noise";
    SKLabelNode *display = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    display.text=question;
    display.fontColor = [SKColor blackColor];
    display.position = CGPointMake(self.size.width/2, 550);
    SKAction *flashAction = [SKAction sequence:@[[SKAction fadeInWithDuration:1/3.0]]];
    [display runAction:flashAction];
    
    [_text addChild:display];
}
-(void)tryAgain{
    SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lives.text =[NSString stringWithFormat:@"Chances: %d", chances];
    lives.fontColor = [SKColor redColor];
    lives.position =CGPointMake(self.size.width/2, self.size.height/2 + 200);
    
    SKAction *flashAction = [SKAction sequence:@[[SKAction fadeInWithDuration:1/3.0],[SKAction waitForDuration:1], [SKAction fadeOutWithDuration:1/3.0]]];
    // run the sequence then delete the label
    if(chances == 2){
        [self hint];
    }
    else if(chances == 1){
        [self hint];
        [self hint2];
    }
    else if(chances <= 0){
        [_text removeFromParent];//clear text
        state++;
    }
    
    [lives runAction:flashAction completion:^{[lives removeFromParent];}];
    [_text addChild:lives];
}
-(void)update:(NSTimeInterval)currentTime{
    if(state == 0){ //train is moving
        if(_train.position.x >= 350){   //call next level function once train reaches right side of screen
            [self stopTrain];
            [self spawnAnimals];
        }
    }
    if(state ==1){  //train is stopped
        if(count >= 10){
            cow.physicsBody.velocity = CGVectorMake(0, 0);
            pig.physicsBody.velocity = CGVectorMake(0, 0);
            horse.physicsBody.velocity = CGVectorMake(0, 0);
            state++;
            count =0;
        }
        else{
            count++;
            [cow.physicsBody applyImpulse:CGVectorMake(1, .5)];
            [pig.physicsBody applyImpulse:CGVectorMake(-1, .5)];
            [horse.physicsBody applyImpulse:CGVectorMake(0, 1)];
            //sleep(.5);
            [pig.physicsBody applyImpulse:CGVectorMake(-1, -1)];
            [cow.physicsBody applyImpulse:CGVectorMake(1, -1)];
        }
    }
    if(state == 2){   //animals out of barn
        //display animals sounds
        //ask question
        [self question];
        
        [self animalSound];
        [self horseButton];
        [self pigButton];
        [self cowButton];
        state++; //make sure animal sound does not play infinitely
    }
    if(state == 3){
        //code in touchesBegan. check for horse touch
        //clear text
    }
    if(state == 4){ //text is cleared. Make horse dance
        [self danceHorse];
        [self question];
        [self animalSound]; //pig sound
        state++;
    }
    if(state == 5){
        //check for pig touch
    }
    if(state == 6){//check for pig
        [self dancePig];
        [self question];
        [self animalSound]; //cow sound
        state++;
        //horse.physicsBody.angularVelocity = 0;
        //display next level
        //[self nextLevel];
        
    }
    if(state == 7){
        //check for pig touch
    }
    if(state == 8){//check for pig
        //count++;
        [self danceCow];
        _train.physicsBody.velocity = CGVectorMake(35, 0);
        if(_train.position.x >= 750){
            [self nextLevel];
            _train.physicsBody.velocity = CGVectorMake(0, 0);
            state++;
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if(state==3 && [node.name isEqual:@"Horse"]){
        [_text removeFromParent];//clear text
        _text = [SKNode node];
        [self addChild:_text];
        state++;
    }
    if(state==3 && ([node.name isEqual:@"Cow"] || [node.name isEqual:@"Pig"])){
        chances--;
        [self tryAgain];
    }
    if(state==5 && [node.name isEqual: @"Pig"]){
        [_text removeFromParent];//clear text
        _text = [SKNode node];
        [self addChild:_text];
        state++;
    }
    if(state==5 && ([node.name isEqual:@"Cow"] || [node.name isEqual:@"Horse"])){
        chances--;
        [self tryAgain];
    }
    if(state==7 && [node.name isEqual: @"Cow"]){
        [_text removeFromParent];//clear text
        _text = [SKNode node];
        [self addChild:_text];
        state++;
    }
    if(state==7 && ([node.name isEqual:@"Pig"] || [node.name isEqual:@"Horse"])){
        chances--;
        [self tryAgain];
    }
    
    if(state==9 && [node.name isEqual: @"level6"]){
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level1 *scene = [Level1 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
}


@end
