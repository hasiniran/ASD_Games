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
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    NSTimeInterval *_dt;
    NSTimeInterval *_lastUpdateTime;
    double speed;
    bool touch;
}

-(id)initWithSize:(CGSize)size{
    speed = 1;
    if(self = [super initWithSize:size]){
        self.backgroundColor = [SKColor colorWithRed:.15 green:.15 blue:.3 alpha:1];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        [self initScrollingBackground]; //scolling background (buildings, hills, etc.)
        [self initScrollingForeground]; //scolling tracks
        [self train];   //train object with physics body

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


-(void)train{   //Moving object
    _train = [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];//change to train png
    _train.position = CGPointMake(60, 50);
    _train.zPosition = 50;
    _train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(46, 18)];
    _train.physicsBody.dynamic = YES;
    _train.physicsBody.affectedByGravity = NO;
    _train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:_train];
    
    
    /*SKShapeNode *rect = [SKShapeNode node];
    rect.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-10, 10, 20, 20)].CGPath;
    rect.fillColor = [UIColor blueColor];
    rect.strokeColor = [UIColor blueColor];
    rect.glowWidth = 5;
    [_train addChild:rect];
    _train.position = CGPointMake(screenWidth/2, screenHeight/2);
    
    
    [self addChild:_train];*/
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    speed = speed/2;
    [self initScrollingBackground]; //fix speed increased for scrolling
    [self initScrollingForeground];
    
    
    /* Called when a touch begins */
    /*
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
     */
    
    
    
    
    
}
/*
-(void)initalizingScrollingBackground
{
    
    
    // Create ground
    
    groundTexture = [SKTexture textureWithImageNamed:@"runway2.png"];
    self.runway = [SKSpriteNode spriteNodeWithTexture:groundTexture];
    groundTexture.filteringMode = SKTextureFilteringNearest;
    
    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration: 0.02 * groundTexture.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
}


-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval  {
    SKAction* action = [SKAction moveByX:-width*1 y:0 duration: timeInterval* width*2];
    return action;
}


-(SKAction*)moveBgContinuously
{
    
    __block SKAction* moveRunwayForever;
    __block SKSpriteNode *runway;
    SKAction* moveBackground;
    
    [self enumerateChildNodesWithName:@"runway" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         runway = (SKSpriteNode *)node;
         SKAction* moveRunway = [self moveAction:runway.size.width: 0.005];
         SKAction* resetRunway = [self moveAction:-runway.size.width: 0.0];
         moveRunwayForever = [SKAction repeatActionForever:[SKAction sequence:@[moveRunway,resetRunway]]];
         
         
         if( !runway.hasActions){
             [runway runAction: moveRunwayForever];
         }
     }];
    
    
    return moveBackground;
    
    
}*/

@end
