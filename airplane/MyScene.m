//
//  MyScene.m
//  airplane
//
//  Created by Hasini Yatawatte on 10/22/14.
//  Copyright (c) 2014 Hasini Yatawatte. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    
    
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    
    
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
    self.ship.position = CGPointMake(screenWidth/2-100, 200);

    
    self.ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.ship.size.height / 2];
    self.ship.physicsBody.dynamic = YES;
    self.ship.physicsBody.allowsRotation = NO;
   // self.ship.physicsBody.affectedByGravity = YES
     [self addChild:self.ship ];
    

    
    self.physicsWorld.gravity = CGVectorMake( 0.0, -0.5 );
    self.actionMoveUp = [SKAction moveByX:0 y:30 duration:.2];
    actionMoveDown = [SKAction moveByX:0 y:-30 duration:.2];
    actionMoveRight = [SKAction moveByX:30 y:0  duration:.2];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    

    
}



-(void)initalizingScrollingBackground
{

    
    // Create ground
    
    SKTexture* groundTexture = [SKTexture textureWithImageNamed:@"CityBackground"];
    groundTexture.filteringMode = SKTextureFilteringNearest;
    
    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:0.02 * groundTexture.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    
    for( int i = 0; i < 2 ; ++i ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        //[sprite setScale:2.0];
        [sprite setXScale:3.0];
        [sprite setYScale:1.5];
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height/2);
        [sprite runAction:moveGroundSpritesForever];
        [self addChild:sprite];
    }
    
    
    
    // Create ground physics container
    
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, 0);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width*2, screenHeight/5)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
