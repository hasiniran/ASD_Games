//
//  Level4.m
//  ASD_Game
//
//  Created by Kim Forbes on 3/19/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level4.h"

@implementation Level4{
    SKSpriteNode *train;
    SKSpriteNode *stop;
   /* SKSpriteNode *cow1;
    SKSpriteNode *cow2;
    SKSpriteNode *cow3;
    SKSpriteNode *cow4;
    SKSpriteNode *cow5; */
    SKSpriteNode *rail;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    double speed;
   // int numCows;
}


-(id)initWithSize:(CGSize)size{
    speed = 1; //start with train moving
   // numCows = (arc4random_uniform(4)+1); //random number of cows, 1-5
    if(self = [super initWithSize:size]){
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        /*
        //text to count the cows
        SKLabelNode *count = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        count.text = @"LEVEL 4";
        count.name = @"Count";
        count.fontSize = 40;
        count.fontColor = [SKColor redColor];
        count.position = CGPointMake(500,500);
        count.zPosition = 50;
        [_HUDLayer addChild:count];
        */
        
        [self initScrollingBackground]; //scolling sky
        [self initScrollingForeground]; //scolling tracks
        [self train];
       // [self addCows];
        [self addMountain];
        
        //move train(LtoR) and cows (RtoL)
        [train.physicsBody applyImpulse:CGVectorMake(1, 0)];
/*        [cow1.physicsBody applyImpulse:CGVectorMake(-2, 0)];
        [cow2.physicsBody applyImpulse:CGVectorMake(-2, 0)];
        [cow3.physicsBody applyImpulse:CGVectorMake(-2, 0)];
        [cow4.physicsBody applyImpulse:CGVectorMake(-2, 0)];
        [cow5.physicsBody applyImpulse:CGVectorMake(-2, 0)];*/
        
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
        [_gameLayer addChild:sprite];
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


-(void)nextLevel{ //transition to level 3
    NSString * retrymessage;
    retrymessage = @"Go to Level 3";
    SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    retryButton.text = retrymessage;
    retryButton.fontColor = [SKColor blueColor];
    retryButton.color = [SKColor yellowColor];
    retryButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    retryButton.name = @"level3";
    [self addChild:retryButton];
}

-(void)train{
    train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];
    train.position = CGPointMake(60, 100);
    train.zPosition = 50;
    train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(25, 20)];
    train.physicsBody.dynamic = YES;
    train.physicsBody.affectedByGravity = NO;
    train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:train];
    
}

/*
//set each cow as a physics body, give starting position (no overlap)
-(void)cow1{
    cow1 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow1.name = @"cow1";
    cow1.position = CGPointMake(1075,300);
    cow1.zPosition = 100;
    cow1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    cow1.physicsBody.dynamic = YES;
    cow1.physicsBody.affectedByGravity = NO;
    cow1.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:cow1];
}

-(void)cow2{
    cow2 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow2.position = CGPointMake(1150,400);
    cow2.zPosition = 100;
    cow2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    cow2.physicsBody.dynamic = YES;
    cow2.physicsBody.affectedByGravity = NO;
    cow2.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:cow2];
}

-(void)cow3{
    cow3 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow3.position = CGPointMake(1175,200);
    cow3.zPosition = 100;
    cow3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    cow3.physicsBody.dynamic = YES;
    cow3.physicsBody.affectedByGravity = NO;
    cow3.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:cow3];
}

-(void)cow4{
    cow4 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow4.position = CGPointMake(1275,250);
    cow4.zPosition = 100;
    cow4.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    cow4.physicsBody.dynamic = YES;
    cow4.physicsBody.affectedByGravity = NO;
    cow4.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:cow4];
}

-(void)cow5{
    cow5 = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow5.position = CGPointMake(1275,350);
    cow5.zPosition = 100;
    cow5.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    cow5.physicsBody.dynamic = YES;
    cow5.physicsBody.affectedByGravity = NO;
    cow5.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:cow5];
}

-(void)addCows { //put random number of cows into scene
    if(numCows == 1){
        [self cow1];
    }
    else if(numCows == 2){
        [self cow1];
        [self cow2];
    }
    else if(numCows == 3){
        [self cow1];
        [self cow2];
        [self cow3];
    }
    else if(numCows == 4){
        [self cow1];
        [self cow2];
        [self cow3];
        [self cow4];
    }
    else if(numCows == 5){
        [self cow1];
        [self cow2];
        [self cow3];
        [self cow4];
        [self cow5];
    }
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if([node.name  isEqual: @"cow1"]){ //display level 3
        [self nextLevel];
    }
    /* transition to next level
    else if ([node.name isEqualToString:@"level3"]) { //transition to level 3
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level5 *scene = [Level5 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    */
}



@end

