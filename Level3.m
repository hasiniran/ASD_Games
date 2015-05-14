//
//  Level3.m
//  ASD_Game
//
//  Created by Matthew Perez on 2/23/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import "Level1.h"
#import "Level5.h"

@implementation Level3{
    SKSpriteNode *_train;
    SKSpriteNode *station;
    SKSpriteNode *rail;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    SKNode *_text;
    NSTimeInterval *_dt;
    NSTimeInterval *_lastUpdateTime;
    SKSpriteNode *blueBoy;
    SKSpriteNode *yellowBoy;
    SKSpriteNode *purpleBoy;
    SKSpriteNode *head;
    SKLabelNode *skip;
    double speed;
    int count;
    int check; //keep track of train states
    int count2;
    int chances;
    //check 0 = moving, check 1 = stop, check 2 = moving, check 4 display
}



-(id)initWithSize:(CGSize)size{
    count = 0;
    check = 0;
    speed = 1;
    chances = 3; //lives
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
        [self addClouds];
        
        //[self initScrollingBackground]; //scolling background (buildings, hills, etc.) but speed is 0 so no scrolling
        [self initScrollingForeground]; //scolling tracks speed is 0
        [self train];   //train object with physics body
        [self station]; //station object
        [self yellowBoy];
        [self blueBoy];
        [self purpleBoy];
        [station.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        [yellowBoy.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        [blueBoy.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        [purpleBoy.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        
        skip= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP"; //Set the button text
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [_HUDLayer addChild:skip]; //add node to screen
    }
    return self;
}

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

-(void)initScrollingForeground{ //Scrolling tracks function
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
-(void)initScrollingBackground{   //scrolling background function
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
-(void)nextLevel{
        NSString * retrymessage;            //Display Go Level 4 message
        retrymessage = @"Go to Level 4";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor redColor];
        retryButton.position = CGPointMake(self.size.width/2, self.size.height/2);
        retryButton.name = @"level4";
        [_text addChild:retryButton];
}

-(void)stopTrain{
    if(check ==0){
        check++;
        speed = 0;
        [_bgLayer removeFromParent];
        [_gameLayer removeFromParent];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        [self train];
        [self station];
        station.position = CGPointMake(620, 160);
        //[self initScrollingBackground];
        [self initScrollingForeground];
        
        rail = [SKSpriteNode spriteNodeWithImageNamed:@"Rail.png"];//change to train png
        rail.position = CGPointMake(917, 36);
        [_bgLayer addChild:rail];
        [self addClouds];
        NSString *question;            //Display question message
        SKLabelNode *display = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        question = @"Say the color of this passenger to pick him up";
        display.text=question;
        display.fontColor = [SKColor purpleColor];
        display.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self blueBoy];
        [self yellowBoy];
        [self purpleBoy];
        [self hint];
        [_text addChild:display];
    }
}
-(void)hint{
    SKSpriteNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];//change to train png
    if(check == 1 )
        arrow.position = CGPointMake(850, 250);
    else if(check == 2)
        arrow.position = CGPointMake(750, 250);
    else if(check ==3)
        arrow.position = CGPointMake(650, 250);
    arrow.zPosition = 100;
    [arrow setScale:.5];
    [_text addChild:arrow];
}
-(void)blueBoy{
    blueBoy = [SKSpriteNode spriteNodeWithImageNamed:@"BlueBoy.png"];
    blueBoy.name = @"blueBoy";
    if(check == 0)
        blueBoy.position=CGPointMake(930, 167);
    else if(check ==1){
        blueBoy.position = CGPointMake(700, 167);
        /*SKLabelNode *blue= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        blue.text = @"Blue"; //Set the button text
        blue.name = @"Blue";
        blue.fontSize = 20;
        blue.fontColor = [SKColor blueColor];
        blue.position = CGPointMake(700,250);
        blue.zPosition = 50;
        [_text addChild:blue]; //add node to screen*/
    }
    blueBoy.zPosition = 30;
    [blueBoy setScale:.5];
    blueBoy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    blueBoy.physicsBody.affectedByGravity = NO;
    blueBoy.physicsBody.allowsRotation=NO;
    blueBoy.physicsBody.collisionBitMask=NO;
    [_gameLayer addChild:blueBoy];
}
-(void)purpleBoy{
    purpleBoy = [SKSpriteNode spriteNodeWithImageNamed:@"PurpleBoy.png"];
    purpleBoy.name = @"purpleBoy";
    if(check ==0)
        purpleBoy.position=CGPointMake(1020, 170);
    else{
        purpleBoy.position = CGPointMake(800, 170);
        /*SKLabelNode *purple= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        purple.text = @"Purple"; //Set the button text
        purple.name = @"Purple";
        purple.fontSize = 20;
        purple.fontColor = [SKColor purpleColor];
        purple.position = CGPointMake(800,250);
        purple.zPosition = 50;
        [_text addChild:purple]; //add node to screen*/
    }
    purpleBoy.zPosition = 30;
    [purpleBoy setScale:.5];
    purpleBoy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    purpleBoy.physicsBody.affectedByGravity = NO;
    purpleBoy.physicsBody.allowsRotation=NO;
    purpleBoy.physicsBody.collisionBitMask = NO;
    [_gameLayer addChild:purpleBoy];
}

-(void)yellowBoy{
    yellowBoy = [SKSpriteNode spriteNodeWithImageNamed:@"YellowBoy.png"];
    yellowBoy.name = @"yellowBoy";
    if(check ==0)
        yellowBoy.position = CGPointMake(840, 170);
    else{
        yellowBoy.position = CGPointMake(600, 170);
        /*SKLabelNode *yellow = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        yellow.text = @"Yellow"; //Set the button text
        yellow.name = @"Yellow";
        yellow.fontSize = 20;
        yellow.fontColor = [SKColor yellowColor];
        yellow.position = CGPointMake(600,250);
        yellow.zPosition = 50;
        [_text addChild:yellow]; //add node to screen*/
    }
    yellowBoy.zPosition = 31;
    [yellowBoy setScale:.5];
    yellowBoy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    yellowBoy.physicsBody.affectedByGravity = NO;
    yellowBoy.physicsBody.allowsRotation=NO;
    yellowBoy.physicsBody.collisionBitMask = NO;
    [_gameLayer addChild:yellowBoy];
}

-(void)labels{
    if(check == 1){
        purpleBoy.position = CGPointMake(800, 170);
        SKLabelNode *purple= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        purple.text = @"Purple"; //Set the button text
        purple.name = @"Purple";
        purple.fontSize = 20;
        purple.fontColor = [SKColor purpleColor];
        purple.position = CGPointMake(800,250);
        purple.zPosition = 50;
        [_text addChild:purple]; //add node to screen
    }
    if(check <= 2){
        blueBoy.position = CGPointMake(700, 167);
        SKLabelNode *blue= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        blue.text = @"Blue"; //Set the button text
        blue.name = @"Blue";
        blue.fontSize = 20;
        blue.fontColor = [SKColor blueColor];
        blue.position = CGPointMake(700,250);
        blue.zPosition = 50;
        [_text addChild:blue]; //add node to screen
    }
    if(check <=3){
        yellowBoy.position = CGPointMake(600, 170);
        SKLabelNode *yellow = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        yellow.text = @"Yellow"; //Set the button text
        yellow.name = @"Yellow";
        yellow.fontSize = 20;
        yellow.fontColor = [SKColor yellowColor];
        yellow.position = CGPointMake(600,250);
        yellow.zPosition = 50;
        [_text addChild:yellow]; //add node to screen
    }
}

-(void)station{
    station = [SKSpriteNode spriteNodeWithImageNamed:@"Station2.png"];//change to train png
    station.position = CGPointMake(850, 160);
    station.zPosition = 0;
    station.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    station.physicsBody.affectedByGravity = NO;
    station.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:station];
}

-(void)train{   //Moving object
    _train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];//change to train png
    _train.position = CGPointMake(250, 100);
    _train.zPosition = 50;
    _train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    _train.physicsBody.dynamic = YES;
    _train.physicsBody.affectedByGravity = NO;
    _train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:_train];
}

-(void)addHeadToTrain{
    [_text removeFromParent];
    if(check ==1 ){
        head = [SKSpriteNode spriteNodeWithImageNamed:@"purpHead.png"];
        head.position = CGPointMake(330, 120);
        [head setScale:.7];
    }
    else if( check ==2){
        head = [SKSpriteNode spriteNodeWithImageNamed:@"blueHead.png"];
        head.position = CGPointMake(280, 120);
        [head setScale:.5];
    }
    else if(check==3){
        head = [SKSpriteNode spriteNodeWithImageNamed:@"yellowHead.png"];
        head.position = CGPointMake(170, 120);
        [head setScale:.5];
    }
    head.zPosition = 60;
    head.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    head.physicsBody.affectedByGravity = NO;
    head.physicsBody.allowsRotation=NO;
    head.physicsBody.collisionBitMask = NO;
    [_gameLayer addChild:head];
    check++;
}
-(void)tryAgain{
    chances--;
    NSString *question;            //Display question message
    SKLabelNode *display = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    question = @"Try Again. Say the color of this passenger";
    display.text=question;
    if(check == 1)
        display.fontColor = [SKColor purpleColor];
    else if(check == 2)
        display.fontColor = [SKColor blueColor];
    else if(check == 3)
        display.fontColor = [SKColor yellowColor];
    
    display.position = CGPointMake(self.size.width/2, self.size.height/2);
    lives.text =[NSString stringWithFormat:@"Chances: %i", chances];
    lives.fontColor = [SKColor redColor];
    lives.position =CGPointMake(self.size.width/2, self.size.height/2 + 100);
    
    SKAction *flashAction = [SKAction sequence:@[[SKAction fadeInWithDuration:1/3.0],[SKAction waitForDuration:2], [SKAction fadeOutWithDuration:1/3.0]]];
    // run the sequence then delete the label
    [lives runAction:flashAction completion:^{[lives removeFromParent];}];
    
    [display removeFromParent];
    [_text addChild:lives];
    [_text addChild:display];
    
    if(chances == 2){
        [self hint];
    }
    else if(chances == 1){
        [self hint];
        [self labels];
    }
    else if(chances <= 0){
        [self hint];
        [self help];
    }
}
-(void)help{
    speed = 1;
    if(check == 1){
        [purpleBoy removeFromParent];
        [self addHeadToTrain];
    }
    if(check == 2){
        [blueBoy removeFromParent];
        [self addHeadToTrain];
    }
    if(check == 3){
        [yellowBoy removeFromParent];
        [self addHeadToTrain];
    }
    [_bgLayer removeFromParent];
    //[_gameLayer removeFromParent];
    _bgLayer = [SKNode node];
    [self addChild: _bgLayer];
    [self initScrollingForeground];
    [self initScrollingBackground];
    [station.physicsBody applyForce:CGVectorMake(-35, 0)];
    //[yellowBoy.physicsBody applyForce:CGVectorMake(-35, 0)];
    //[blueBoy.physicsBody applyForce:CGVectorMake(-35, 0)];
    //[_train.physicsBody applyForce:CGVectorMake(25, 0)];
   // [head.physicsBody applyForce:CGVectorMake(25, 0)];
    count =0;
    count2 =0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
     CGPoint location = [[touches anyObject] locationInNode:self];
     SKNode *node = [self nodeAtPoint:location];
    if(check == 1 && [node.name  isEqual: @"purpleBoy"]){
        speed = 1;
        [purpleBoy removeFromParent];
        [self addHeadToTrain];
        count2=0;
    }
    else if(check==1 && [node.name  isEqual: @"yellowBoy"]){
        [_text removeFromParent];   //erase and re-add text
        _text = [SKNode node];
        [self addChild:_text];
        [self tryAgain];
    }
    else if(check ==1 &&[node.name  isEqual: @"blueBoy"]){
        [_text removeFromParent];   //erase and re-add text
        _text = [SKNode node];
        [self addChild:_text];
        [self tryAgain];
    }
    
    if(check == 2 && [node.name  isEqual: @"blueBoy"]){ //blue chck
        [blueBoy removeFromParent];
        [self addHeadToTrain];
        count2 = 0;
    }
    else if(check==2 && [node.name  isEqual: @"yellowBoy"]){
        [_text removeFromParent];   //erase and re-add text
        _text = [SKNode node];
        [self addChild:_text];
        [self tryAgain];
    }
    
    if(check == 3&& [node.name  isEqual: @"yellowBoy"]){
        [yellowBoy removeFromParent];
        [self addHeadToTrain];
        
        [_bgLayer removeFromParent];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        [self initScrollingForeground];
        [self initScrollingBackground];
        [station.physicsBody applyForce:CGVectorMake(-35, 0)];
        count2 = 0;
        count = 0;
    }
    
    
    if(check==4 && [node.name isEqual: @"level4"]){
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level5 *scene = [Level5 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    if ([node.name isEqualToString:@"Skip"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level5 *scene = [Level5 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
}


-(void)update:(NSTimeInterval)currentTime{
    count++;
    if(check == 2 && count2==0){//purple head in train
        count2++;
        [_text removeFromParent];   //clear text
        _text = [SKNode node];  //re init text
        [self addChild:_text];
        NSString *question;            //Display question message
        SKLabelNode *display = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        question = @"Say the color of this passenger to pick him up";
        display.text=question;
        display.fontColor = [SKColor blueColor];
        display.position = CGPointMake(self.size.width/2, self.size.height/2);
        [_text addChild:display];
        //display arrow
        if(chances == 1)
            [self labels];
        [self hint];
    }
    if(check == 3 && count2 ==0){//blue and purp in train
        count2++;
        [_text removeFromParent];   //clear text
        _text = [SKNode node];  //re init text
        [self addChild:_text];
        NSString *question;            //Display question message
        SKLabelNode *display = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        question = @"Say the color of this passenger to pick him up";
        display.text=question;
        display.fontColor = [SKColor yellowColor];
        display.position = CGPointMake(self.size.width/2, self.size.height/2);
        [_text addChild:display];
        //display arrow
        if(chances == 1)
            [self labels];
        [self hint];
    }
    if(check == 4 && count2 == 0){
        if(count >= 30){
            count2++;
            [_text removeFromParent];   //erase and re-add text
            _text = [SKNode node];
            [self addChild:_text];
            NSLog(@"hi");
            //_train.physicsBody.velocity = CGVectorMake(0, 0);
            //head.physicsBody.velocity=CGVectorMake(0, 0);
            [self nextLevel];
        }
        
    }
    else if(count >= 28){   //call next level function once train reaches right side of screen
        [self stopTrain];
    }
}


@end
