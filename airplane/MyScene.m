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
    self.ship.position = CGPointMake(screenWidth/2-100, 100);

    
    self.ship.physicsBody = [SKPhysicsBody bodyWithTexture:self.ship.texture size:self.ship.texture.size];;
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
    
    groundTexture = [SKTexture textureWithImageNamed:@"Runway.png"];
    self.runway = [SKSpriteNode spriteNodeWithTexture:groundTexture];
    groundTexture.filteringMode = SKTextureFilteringNearest;
    
    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration: 0.02 * groundTexture.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    // Create ground

    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"runway";
        [self addChild:bg];
    }
    
    

    
    
    
//    for( int i = 0; i< 2 + self.frame.size.width / ( groundTexture.size.width * 2 ) ; ++i ) {
//       SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
//        [sprite setScale:2];
//      //  sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2);
//     //   [sprite runAction:moveGroundSpritesForever];
//        sprite.name = @"runway";
//        [self addChild:sprite];
//    }
    
    // Create skyline

    
    SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"Sky.png"];
    skylineTexture.filteringMode = SKTextureFilteringNearest;
    
    
    
    SKAction* moveSkySprite = [SKAction moveByX:-skylineTexture.size.width*2 y:0 duration:0.1 * skylineTexture.size.width*2];
    SKAction* resetSkySprite = [SKAction moveByX:skylineTexture.size.width*2 y:0 duration:0];
    SKAction* moveSkySpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSkySprite, resetSkySprite]]];
    
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
        bg.position = CGPointMake(i * bg.size.width, groundTexture.size.height );
        bg.zPosition = -200;
        bg.anchorPoint = CGPointZero;
        bg.name = @"sky";
        [self addChild:bg];
    }
    
    
////
//    for( int i = 0; i< 2 + self.frame.size.width / ( skylineTexture.size.width * 2 )  ; ++i ) {
//        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
//        [sprite setScale:1.5];
//        sprite.zPosition = -20;
//        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2 + groundTexture.size.height );
//     //   [sprite runAction:moveSkySpritesForever];
//        [self addChild:sprite];
//    }
//
//    
    
//    SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"Sky.png"];
//    skylineTexture.filteringMode = SKTextureFilteringNearest;
//    
//    for( int i = 0; i < 2 ; ++i ) {
//        SKSpriteNode* groundSprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
//        SKSpriteNode* skySprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
//        //[sprite setScale:2.0];
//        //[sprite setXScale:3.0];
//        //[sprite setYScale:1.5];
//        groundSprite.position = CGPointMake(i * groundSprite.size.width, 100);
//        
//        
//
//        [self addChild:sprite];
//        
//        
//        
//        
//        
//    }
//    
//    
//
//    
//    for( int i = 0; i < 2 ; ++i ) {
//       
//        //[sprite setScale:2.0];
//        sprite.zPosition = -20;
//        sprite.position = CGPointMake(i * sprite.size.width,  100 + groundTexture.size.height);
//        [self addChild:sprite];
//    }
//    
    
    
    
    
    

    
    
    
    // Create ground physics container
    
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, 0);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, groundTexture.size.height/2 -20)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    
    
}



- (void)moveBg
{
    [self enumerateChildNodesWithName:@"runway" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
       //  CGFloat bgVelocity = -1*fabs(self.ship.physicsBody.velocity.dy);
         CGFloat bgVelocity = -100;
         CGPoint amtToMove = CGPointMultiplyScalar(CGPointMake(RUNWAY_VELOCITY,0),_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
    
    [self enumerateChildNodesWithName:@"sky" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         //  CGFloat bgVelocity = -1*fabs(self.ship.physicsBody.velocity.dy);
         CGFloat bgVelocity = -10;
         CGPoint amtToMove = CGPointMultiplyScalar(CGPointMake(SKY_VELOCITY,0),_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
    
    
    
    
}

CGFloat clamp(CGFloat min, CGFloat max, CGFloat value) {
    if( value > max ) {
        return max;
    } else if( value < min ) {
        return min;
    } else {
        return value;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    self.ship.zRotation = clamp( -1, 0, self.ship.physicsBody.velocity.dy * ( self.ship.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 ) );
    
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    
    if(self.ship.physicsBody.velocity.dy != 0 ) {

        if( self.ship.position.y >= [[UIScreen mainScreen] bounds].size.height*0.75 ){
            
        [self.ship setPosition:CGPointMake(self.ship.position.x, [[UIScreen mainScreen] bounds].size.height*0.75)];
        self.ship.physicsBody.dynamic = NO;
        }
        
        [self moveBg];
    }
    
    if( self.ship.position.y >= [[UIScreen mainScreen] bounds].size.height*0.75 ){
        
        [self.ship setPosition:CGPointMake(self.ship.position.x, [[UIScreen mainScreen] bounds].size.height*0.75)];
        self.ship.physicsBody.dynamic = NO;
        [self moveBg];
    }
    
    
}

@end
