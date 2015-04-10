//
//  SecondLevel.m
//  airplane
//
//  Created by Hasini Yatawatte on 1/26/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import "SecondLevel.h"

@implementation SecondLevel


-(id)initWithSize:(CGSize)size {
    
    
    if (self = [super initWithSize:size]) {
        
        
        [self initalizingScrollingBackground];
        [self addShip];
        
        
    }
    
    return self;
}



-(void)addShip
{
    
    
    self.ship= [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
    [self.ship setScale:0.5];
    self.ship.position = CGPointMake(200, [[UIScreen mainScreen] bounds].size.height*0.75);
    
    
    self.ship.physicsBody = [SKPhysicsBody bodyWithTexture:self.ship.texture size:self.ship.texture.size];;
    self.ship.physicsBody.dynamic = YES;
    self.ship.physicsBody.allowsRotation = NO;
    // self.ship.physicsBody.affectedByGravity = YES
    [self addChild:self.ship ];
    
    self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 );

    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    
}



-(void)initalizingScrollingBackground
{
    
    


    
    
    // Create ground
    
    seaTexture = [SKTexture textureWithImageNamed:@"Sea.png"];
    self.sea = [SKSpriteNode spriteNodeWithTexture:seaTexture];
    seaTexture.filteringMode = SKTextureFilteringNearest;
      // Create ground
    
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:seaTexture];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"sea";
        [self addChild:bg];
    }
    
    

    
    
    waveTexture = [SKTexture textureWithImageNamed:@"Waves.png"];
    self.wave = [SKSpriteNode spriteNodeWithTexture:waveTexture];
    waveTexture.filteringMode = SKTextureFilteringNearest;
    // Create ground
    
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:waveTexture];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"waves";
        [self addChild:bg];
    }
    

    
    // Create skyline
    
    
    SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"Sky-3.png"];
    skylineTexture.filteringMode = SKTextureFilteringNearest;
    
    
    
    
    
    
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
        [bg setScale:2];
        bg.position = CGPointMake(i * bg.size.width, seaTexture.size.height );
        //  bg.zPosition = -200;
        bg.anchorPoint = CGPointZero;
        bg.name = @"sky";
        [self addChild:bg];
    }
    
    // Create ground physics container
    
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, 0);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, seaTexture.size.height/2 -20)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    [self moveBgContinuously];
    
    
    
}

-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval  {
    SKAction* action = [SKAction moveByX:-width*1 y:0 duration: timeInterval* width*2];
    return action;
}


-(SKAction*)moveBgContinuously
{
    
    __block SKAction* moveRunwayForever;
    //__block SKAction* moveSkyForever;
    //__block SKSpriteNode *sky;
    __block SKSpriteNode *waves;
    SKAction* moveBackground;
    
    [self enumerateChildNodesWithName:@"waves" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         waves = (SKSpriteNode *)node;
         SKAction* moveRunway = [self moveAction:waves.size.width: 0.01];
         SKAction* resetRunway = [self moveAction:-waves.size.width: 0.0];
         moveRunwayForever = [SKAction repeatActionForever:[SKAction sequence:@[moveRunway,resetRunway]]];
         
         
         if( !waves.hasActions){
             [waves runAction: moveRunwayForever];
         }
     }];
    
    
    
    if(!waves.hasActions) {
        [self runAction:moveBackground];
        
    }
    
    return moveBackground;
    
    
}





@end
