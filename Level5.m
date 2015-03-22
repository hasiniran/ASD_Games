//
//  Level5.m
//  ASD_Game
//
//  Created by Matthew Perez on 3/20/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import "Level5.h"

@implementation Level5{
    SKSpriteNode *_train;
    SKSpriteNode *barn;
    SKSpriteNode *rail;
    SKNode *_bgLayer;   //Permanent Layer (Mountains)
    SKNode *_HUDLayer;  //Static Layer
    SKNode *_gameLayer; //Moving Layer
    SKNode *_text;      //TextLayer
    double speed;
    int count;
    int check; //keep track of train states
    int count2;
    //check 0 = moving, check 1 = stop, check 2 = moving, check 4 display
}

/******MAIN******/
-(id)initWithSize:(CGSize)size{
    count = 0;
    check = 0;
    speed = 1;
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
        [self addBarn];
        [self addTracks];
        
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
    barn.zPosition = 0;
    barn.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    barn.physicsBody.affectedByGravity = NO;
    barn.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:barn];
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

/*-(void)initScrollingTracks{ //Scrolling tracks function
    
    for(int i=0; i<2 +self.frame.size.width/(rail.size.width);i++){      //place image
        //SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        rail = [SKSpriteNode spriteNodeWithImageNamed:@"Rail.png"]; //change runway to train tracks
        [rail setScale:1];
        rail.zPosition = 10;
        rail.anchorPoint = CGPointZero;
        rail.position = CGPointMake(i*rail.size.width, 0);
        //[rail runAction:moveGroundSpriteForever];
        [_gameLayer addChild:rail];
    }
}
*/
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
    _train.physicsBody.velocity = CGVectorMake(0, 0);
}

-(void)update:(NSTimeInterval)currentTime{
    count++;
    if(count >= 28){   //call next level function once train reaches right side of screen
        [self stopTrain];
    }
}


@end
