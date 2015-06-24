//
//  Level4.m
//  ASD_Game
//
//  Created by Kim Forbes on 3/19/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//


//option to stop specific node, specific actions for a node
//stop background instead of train
//wait for email from hasini

#import <Foundation/Foundation.h>
#import "Level4.h"
#import "Level3.h" //change to 5


@implementation Level4{
    SKSpriteNode *train;
    SKSpriteNode *stopSign1;
//    SKSpriteNode *stopSign2;
//    SKSpriteNode *stopSign3;
    SKSpriteNode *rail;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    SKLabelNode *skip;
    double speed;
    int click;
    int sign;
}


-(id)initWithSize:(CGSize)size{
    speed = 1; //start with train moving
    click = 0;
    sign = 0;
    if(self = [super initWithSize:size]){
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        SKLabelNode *stop = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        stop.text = @"Stop";
        stop.name = @"stop";
        stop.fontSize = 40;
        stop.fontColor = [SKColor blueColor];
        stop.position = CGPointMake(150,400);
        stop.zPosition = 50;
        [_HUDLayer addChild:stop];
        
        [self initScrollingBackground]; //scolling sky
        [self initScrollingForeground]; //scolling tracks
        [self train];
        [self stopSign1];
//        [self stopSign2];
//        [self stopSign3];
        [self addMountain];
        
        skip= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP"; //Set the button text
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [_HUDLayer addChild:skip]; //add node to screen
        
        [train.physicsBody applyImpulse:CGVectorMake(1, 0)];
        [stopSign1.physicsBody applyImpulse:CGVectorMake(-2, 0)];
//        [stopSign2.physicsBody applyImpulse:CGVectorMake(-2, 0)];
//        [stopSign3.physicsBody applyImpulse:CGVectorMake(-2, 0)];
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


-(void)stopSign1{
    stopSign1 = [SKSpriteNode spriteNodeWithImageNamed:@"StopSign.png"];
    stopSign1.name = @"stop1";
    stopSign1.position = CGPointMake(1075,260);
    stopSign1.zPosition = 40;
    stopSign1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    stopSign1.physicsBody.dynamic = YES;
    stopSign1.physicsBody.affectedByGravity = NO;
    stopSign1.physicsBody.allowsRotation = NO;
    /*[stopSign runAction:[SKAction moveTo:CGPointMake(750, 260) duration:7] completion:^{
        sign = 1;
    }];
    [stopSign runAction:[SKAction moveTo:CGPointMake(50, 260) duration:7] completion:^{
        sign = 0;
    }];*/
    [_gameLayer addChild:stopSign1];
  
}

/*
-(void)stopSign2{
    stopSign2 = [SKSpriteNode spriteNodeWithImageNamed:@"StopSign.png"];
    stopSign2.name = @"stop2";
    stopSign2.position = CGPointMake(2075,260);
    stopSign2.zPosition = 40;
    stopSign2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    stopSign2.physicsBody.dynamic = YES;
    stopSign2.physicsBody.affectedByGravity = NO;
    stopSign2.physicsBody.allowsRotation = NO;
//    [stopSign runAction:[SKAction moveTo:CGPointMake(750, 260) duration:7] completion:^{
//     sign = 1;
//     }];
//     [stopSign runAction:[SKAction moveTo:CGPointMake(50, 260) duration:7] completion:^{
//     sign = 0;
//     }];
//    [_gameLayer addChild:stopSign2];
    
}


-(void)stopSign3{
    stopSign3 = [SKSpriteNode spriteNodeWithImageNamed:@"StopSign.png"];
    stopSign3.name = @"stop3";
    stopSign3.position = CGPointMake(3075,260);
    stopSign3.zPosition = 40;
    stopSign3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    stopSign3.physicsBody.dynamic = YES;
    stopSign3.physicsBody.affectedByGravity = NO;
    stopSign3.physicsBody.allowsRotation = NO;
//    [stopSign runAction:[SKAction moveTo:CGPointMake(750, 260) duration:7] completion:^{
//     sign = 1;
//     }];
//     [stopSign runAction:[SKAction moveTo:CGPointMake(50, 260) duration:7] completion:^{
//     sign = 0;
//     }];
    [_gameLayer addChild:stopSign3];
    
}
*/

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
    retryButton.zPosition=265;
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name  isEqual: @"stop"]) {
        click = 1; //train is stopped
        self.physicsWorld.speed = 0.0;
        speed = 0;
      //  self.scene.view.paused = YES;
        [self nextLevel];
    }
    // transition to next level
    else if ([node.name isEqualToString:@"level5"]) { //transition to level 5
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level3 *scene = [Level3 sceneWithSize:self.view.bounds.size]; //change to 5
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
}



@end

