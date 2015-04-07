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
    SKSpriteNode *rail;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    double speed;
}


-(id)initWithSize:(CGSize)size{
    speed = 1; //start with train moving
    if(self = [super initWithSize:size]){
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        [self initScrollingBackground]; //scolling sky
        [self initScrollingForeground]; //scolling tracks
        [self train];
        [self stop];
        [self addMountain];
        
        [train.physicsBody applyImpulse:CGVectorMake(1, 0)];
        [stop.physicsBody applyImpulse:CGVectorMake(-2, 0)];
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
    retrymessage = @"Go to Level 5";
    SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    retryButton.text = retrymessage;
    retryButton.fontColor = [SKColor blueColor];
    retryButton.color = [SKColor yellowColor];
    retryButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    retryButton.name = @"level5";
    [self addChild:retryButton];
}


-(void)stopTrain{
    //code to stop the train, instead of message display
    NSString * stopmessage;
    stopmessage = @"stopped";
    SKLabelNode *stopButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    stopButton.text = stopmessage;
    stopButton.fontColor = [SKColor blueColor];
    stopButton.color = [SKColor yellowColor];
    stopButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    stopButton.name = @"stopped";
    [self addChild:stopButton];
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


-(void)stop{
    stop = [SKSpriteNode spriteNodeWithImageNamed:@"StopSign.png"];
    stop.name = @"stop";
    stop.position = CGPointMake(1075,260);
    stop.zPosition = 40;
    stop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    stop.physicsBody.dynamic = YES;
    stop.physicsBody.affectedByGravity = NO;
    stop.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:stop];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name  isEqual: @"stop"]) {
        [self stopTrain];
    }
    else if([node.name  isEqual: @"level5"]){ //display level 5, pick new node to click on...
        [self nextLevel];
    }
    /* transition to next level
    else if ([node.name isEqualToString:@"level5"]) { //transition to level 5
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level5 *scene = [Level5 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    */
}



@end

