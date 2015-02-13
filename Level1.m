//
//  GameScene.m
//  Autism_train
//
//  Created by Matthew Perez on 1/28/15.
//  Copyright (c) 2015 Matthew Perez. All rights reserved.
//

#import "Level1.h"
//LEVEL1
@implementation Level1{
    SKSpriteNode *_train;
    SKSpriteNode *station;
    //SKSpriteNode *background;
    //SKSpriteNode *foreground;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    NSTimeInterval *_dt;
    NSTimeInterval *_lastUpdateTime;
    double speed;
    bool first;
}

-(id)initWithSize:(CGSize)size{
    speed = 1;
    //first = true;
    if(self = [super initWithSize:size]){
        //self.backgroundColor = [SKColor colorWithRed:.15 green:.15 blue:.3 alpha:1];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        //init static background, erase in touch function
      /*  background = [SKSpriteNode spriteNodeWithImageNamed:@"Sky.png"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:background];
        
        foreground = [SKSpriteNode spriteNodeWithImageNamed:@"Runway.png"];
        foreground.position = CGPointMake(CGRectGetMidX(self.frame),9);
        [self addChild:foreground];
        */
        
        [self initScrollingBackground]; //scolling background (buildings, hills, etc.)
        [self initScrollingForeground]; //scolling tracks
        [self train];   //train object with physics body
        [self station];
        [station.physicsBody applyForce:CGVectorMake(-20, 0)];
    
    }
    return self;
}

-(void)initScrollingForeground{ //Scrolling tracks function
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"Runway.png"]; //change runway to train tracks
    SKAction *moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:.02*speed*groundTexture.size.width*2];
    SKAction *resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction *moveGroundSpriteForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for(int i=0; i<2 +self.frame.size.width/(groundTexture.size.width*2);i++){      //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [sprite setScale:1];
        sprite.zPosition = 10;
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(i*sprite.size.width, -100);
        [sprite runAction:moveGroundSpriteForever];
        [_gameLayer addChild:sprite];
    }
}
-(void)initScrollingBackground{   //scrolling background function
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Sky.png"];        //reuse sky image
    SKAction *moveBg= [SKAction moveByX:-backgroundTexture.size.width*2 y:0 duration: 0.1*speed*backgroundTexture.size.width]; //move Bg
    SKAction *resetBg = [SKAction moveByX:backgroundTexture.size.width*2 y:0 duration:0];   //reset background
    SKAction *moveBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];    //repeat moveBg and resetBg
    for(int i =0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++){     //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 100);
        [sprite runAction:moveBackgroundForever];
        [_bgLayer addChild:sprite];
    }
}

-(void)nextLevel{
    _train.physicsBody.velocity = CGVectorMake(0, 0);   //stop train
    
    NSString * retrymessage;
    retrymessage = @"Go to Level 2";
    SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    retryButton.text = retrymessage;
    retryButton.fontColor = [SKColor blueColor];
    retryButton.color = [SKColor yellowColor];
    retryButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    retryButton.name = @"level2";
    [self addChild:retryButton];
}

-(void)station{
    station = [SKSpriteNode spriteNodeWithImageNamed:@"station.png"];//change to train png
    station.position = CGPointMake(150, 200);
    station.zPosition = 20;
    station.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    station.physicsBody.affectedByGravity = NO;
    station.physicsBody.allowsRotation = NO;
    //station.centerRect = CGRectMake(100, 200, 50, 50);
    [_gameLayer addChild:station];
}

-(void)train{   //Moving object
    _train = [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];//change to train png
    _train.position = CGPointMake(60, 50);
    _train.zPosition = 50;
    _train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    _train.physicsBody.dynamic = YES;
    _train.physicsBody.affectedByGravity = NO;
    _train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:_train];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_train.physicsBody applyImpulse:CGVectorMake(1, 0)];
}

-(void)update:(NSTimeInterval)currentTime{
    if(_train.position.x >= 600){
        [self nextLevel];
    
    }
}

@end
