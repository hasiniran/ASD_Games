//
//  Level2.m
//  ASD_Game
//
//  Created by Kim Forbes on 2/8/15.
//  Copyright (c) 2015 Kim Forbes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level1.h"
#import "Level2.h"

//LEVEL2
@implementation Level2{
    SKSpriteNode *_train;
    SKSpriteNode *cow;
    SKSpriteNode *rail;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    NSTimeInterval *_dt;
    NSTimeInterval *_lastUpdateTime;
    bool first;
    bool firstTouch;
    double speed;
//    int count;
    int numCows;
    bool pause;
}


-(id)initWithSize:(CGSize)size{
    speed = 0;
    first = true;
    firstTouch = true;
    if(self = [super initWithSize:size]){
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        
        
        [self initBackground];
        [self initScrollingBackground]; //scolling sky
        [self initScrollingForeground]; //scolling tracks
        [self train];   //train object
        //[self cow];
        
        rail = [SKSpriteNode spriteNodeWithImageNamed:@"Rail.png"];
        rail.position = CGPointMake(917, 36);
        [_gameLayer addChild:rail];
        
    }
    return self;
    
}

-(void)initScrollingForeground{ //Scrolling train tracks function
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"Rail.png"];
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

-(void)initBackground{ //grass background, doesn't move
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Background.png"];
    for (int i=0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 100);
        [_bgLayer addChild:sprite];
    }
}

-(void)initScrollingBackground{   //scrolling background function
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Sky2.png"];
    if (pause == false){ //try to pause screen?
        SKAction *moveBg= [SKAction moveByX:-backgroundTexture.size.width*2 y:0 duration: 0.1*speed*backgroundTexture.size.width]; //move Bg
        SKAction *resetBg = [SKAction moveByX:backgroundTexture.size.width*2 y:0 duration:0];   //reset background
        SKAction *moveBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];    //repeat moveBg and resetBg
        for(int i =0; i<5+self.frame.size.width/(backgroundTexture.size.width*2); i++){
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
            [sprite runAction:moveBackgroundForever];
        }
    }
    for(int i =0; i<5+self.frame.size.width/(backgroundTexture.size.width*2); i++){     //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 500);
        [_bgLayer addChild:sprite];
    }
    
    
}

-(void)nextLevel{
    _train.physicsBody.velocity = CGVectorMake(0, 0);   //stop train - poop
    if(first == true){
        NSString * retrymessage;            //Next Level
        retrymessage = @"Go to Level 3";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blueColor];
        retryButton.color = [SKColor yellowColor];
        retryButton.position = CGPointMake(self.size.width/2, self.size.height/2);
        retryButton.name = @"level3";
        [self addChild:retryButton];
        first = false;
    }
}

-(void)train{   //Moving train object
    _train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];
    _train.position = CGPointMake(60, 100);
    _train.zPosition = 50;
    _train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    _train.physicsBody.dynamic = YES;
    _train.physicsBody.affectedByGravity = NO;
    _train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:_train];
    
}


-(void)cow{
    cow = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow.position = CGPointMake(500,300);
    cow.zPosition = 100;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_train.physicsBody applyImpulse:CGVectorMake(1, 0)];
    speed = 1;  //set speed to 1 which starts background scrolling
    if (firstTouch==true){  //initial touch
        [_bgLayer removeFromParent];
        [_gameLayer removeFromParent];
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        [self train];
        [self initBackground];
        [self initScrollingBackground]; //start background scrolling
        [self initScrollingForeground];
        pause = false;
        /*
        if (count%2 == 0) { //if game is paused, show cows
            [self cow];
            count++; //after cows, increment count to keep moving
        }
        */
        firstTouch = false; //any touches after are not initial touch
    }

}

-(void)update:(NSTimeInterval)currentTime{
    //randomly generate number of cows
  //  if ((int)_train.position.x == 300) {
        numCows = arc4random() % 9; //[self getRandomNumberBetween:1 to:10];
        for (int i=1; i<=numCows+1; i++){
    
            [_gameLayer addChild:cow];
        }
 //   }
}

/*
//randomly generate cows
int Cows = [self getRandomNumberBetween:0 to:1];
if (Cows == 1) {
    SKSpriteNode *cow = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];
    cow.position = CGPointMake(screenRect.size.height+cow.size.height/2, screenRect.size.width+cow.size.width/2);
    cow.zPosition = 1;
    int randomTime = [self getRandomNumberBetween:9 to:19];
    
    SKAction *move =[SKAction moveTo:CGPointMake(0-cow.size.height, 0-cow.size.width) duration:randomTime];
    SKAction *remove = [SKAction removeFromParent];
    [cow runAction:[SKAction sequence:@[move,remove]]];
    [self addChild:cow];
}
*/

/*
-(void)update:(NSTimeInterval)currentTime{
    if((int)_train.position.x >= 800){ //was 600
        [self nextLevel];
    }
}*/

@end

