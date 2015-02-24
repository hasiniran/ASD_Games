//
//  Level3.m
//  ASD_Game
//
//  Created by Matthew Perez on 2/23/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import "Level3.h"

@implementation Level3{
    SKSpriteNode *_train;
    SKSpriteNode *station;
    SKSpriteNode *rail;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    NSTimeInterval *_dt;
    NSTimeInterval *_lastUpdateTime;
    double speed;
    int count;
    int check; //keep track of train states
    //check 0 = moving, check 1 = stop, check 3 = moving, check 4 display
}

-(id)initWithSize:(CGSize)size{
    count = 0;
    check = 0;
    speed = 1;
    if(self = [super initWithSize:size]){
        //self.backgroundColor = [SKColor colorWithRed:.15 green:.15 blue:.3 alpha:1];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        
        
        [self initScrollingBackground]; //scolling background (buildings, hills, etc.) but speed is 0 so no scrolling
        [self initScrollingForeground]; //scolling tracks speed is 0
        [self train];   //train object with physics body
        [self station]; //station object
        [station.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        
    }
    return self;
    
}

-(void)initScrollingForeground{ //Scrolling tracks function
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"Rail.png"]; //change runway to train tracks
    SKAction *moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:.02*speed*groundTexture.size.width*2];
    SKAction *resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction *moveGroundSpriteForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for(int i=0; i<2 +self.frame.size.width/(groundTexture.size.width*2);i++){      //place image
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
    if(check == 3){
        NSString * retrymessage;            //Display Level 2 message
        retrymessage = @"Go to Level 4";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blueColor];
        retryButton.color = [SKColor yellowColor];
        retryButton.position = CGPointMake(self.size.width/2, self.size.height/2);
        retryButton.name = @"level4";
        [self addChild:retryButton];
        check++;
    }
}

-(void)stopTrain{
    //CGPoint stationPos = station.position;
    //NSLog(@"%@", NSStringFromCGPoint(station.position));
    if(check ==0){
        speed = 0;
        [_bgLayer removeFromParent];
        [_gameLayer removeFromParent];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        [self train];
        [self station];
        station.position = CGPointMake(500, 160);
        [self initScrollingBackground];
        [self initScrollingForeground];
        
        rail = [SKSpriteNode spriteNodeWithImageNamed:@"Rail.png"];//change to train png
        rail.position = CGPointMake(917, 36);
        [_gameLayer addChild:rail];
        
        NSString *question;            //Display question message
        SKLabelNode *display = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        question = @"Pick up the passenger in purple";
        display.text=question;
        display.fontColor = [SKColor purpleColor];
        display.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:display];
    }
    check++;
    
}


-(void)station{
    station = [SKSpriteNode spriteNodeWithImageNamed:@"station.png"];//change to train png
    station.position = CGPointMake(750, 160);
    station.zPosition = 20;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[_train.physicsBody applyImpulse:CGVectorMake(1, 0)];
    speed = 1;  //set speed to 1 which starts background scrolling
    
    //Level 2 connection
    /*
     CGPoint location = [[touches anyObject] locationInNode:self];
     SKNode *node = [self nodeAtPoint:location];
     
     if ([node.name isEqualToString:@"level2"]) {
     
     
     SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
     Level2 *scene = [Level2 sceneWithSize:self.view.bounds.size];
     scene.scaleMode = SKSceneScaleModeAspectFill;
     [self.view presentScene:scene transition: reveal];
     
     }asdfa
     */
    
}


-(void)update:(NSTimeInterval)currentTime{
    count++;
    if(count >= 40){   //call next level function once train reaches right side of screen
        [self stopTrain];
        
    }
}


@end