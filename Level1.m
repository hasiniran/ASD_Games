//
//  GameScene.m
//  Autism_train
//
//  Created by Matthew Perez on 1/28/15.
//  Copyright (c) 2015 Matthew Perez. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Level1.h"
#import "Level2.h"

//LEVEL1
@implementation Level1{
    SKSpriteNode *_train;
    SKSpriteNode *station;
    SKSpriteNode *rail;
    SKSpriteNode *mountain;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    NSTimeInterval *_dt;
    NSTimeInterval *_lastUpdateTime;
    double speed;
    bool first;
    bool firstTouch;
}

-(id)initWithSize:(CGSize)size{
    speed = 0;
    first = true;
    firstTouch = true;
    if(self = [super initWithSize:size]){
        //self.backgroundColor = [SKColor colorWithRed:.15 green:.15 blue:.3 alpha:1];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        go.text = @"Go"; //Set the button text
        go.name = @"Go";
        go.fontSize = 40;
        go.fontColor = [SKColor blueColor];
        go.position = CGPointMake(300,70);
        go.zPosition = 50;  
        [self addChild:go]; //add node to screen
        
        
        [self addMountain];
        [self addClouds];
        
        //[self initScrollingBackground]; //scolling background (buildings, hills, etc.) but speed is 0 so no scrolling
        [self initScrollingForeground]; //scolling tracks speed is 0
        [self train];   //train object with physics body
        rail = [SKSpriteNode spriteNodeWithImageNamed:@"Rail.png"];//change to train png
        rail.position = CGPointMake(917, 36);
        [_gameLayer addChild:rail];
        
        [self station]; //station object
    
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

-(void)nextLevel{
    _train.physicsBody.velocity = CGVectorMake(0, 0);   //stop train
    
    if(first == true){
        NSString * retrymessage;            //Display Level 2 message
        retrymessage = @"Go to Level 2";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blueColor];
        retryButton.color = [SKColor yellowColor];
        retryButton.position = CGPointMake(self.size.width/2, self.size.height/2);
        retryButton.name = @"level2";
        [self addChild:retryButton];
        first = false;
    }
}

-(void)station{
    station = [SKSpriteNode spriteNodeWithImageNamed:@"station.png"];//change to train png
    station.position = CGPointMake(150, 170);
    station.zPosition = 20;
    station.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    station.physicsBody.affectedByGravity = NO;
    station.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:station];
}

-(void)train{   //Moving object
    _train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];//change to train png
    _train.position = CGPointMake(60, 100);
    _train.zPosition = 50;
    _train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    _train.physicsBody.dynamic = YES;
    _train.physicsBody.affectedByGravity = NO;
    _train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:_train];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    speed = 1;  //set speed to 1 which starts background scrolling
    if (firstTouch==true){  //initial touch
        [_HUDLayer removeFromParent];
        [_bgLayer removeFromParent];
        [_gameLayer removeFromParent];
        
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        
        [self addMountain];
        [self station];
        [self train];
        [self initScrollingBackground]; //start background scrolling
        [self initScrollingForeground];
        [station.physicsBody applyForce:CGVectorMake(-25, 0)];
        firstTouch = false; //any touches after are not initial touch
    }
    //Level 2 connection
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"level2"]) {
        
        
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level3 *scene = [Level3 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];

    }else if ([node.name isEqualToString:@"Go"]) {
        
        [_train.physicsBody applyImpulse:CGVectorMake(1, 0)];
        
    }
    
    
}


-(void)update:(NSTimeInterval)currentTime{
    if(_train.position.x >= 600){   //call next level function once train reaches right side of screen
        [self nextLevel];
    
    }
}
    

@end
