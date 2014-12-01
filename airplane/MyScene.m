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
       // UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CityBackground.png"]];
        //[backgroundView setFrame:CGRectMake(0, 0, screenHeight, screenWidth)];
      //  [ self.view insertSubView:backgroundView atIndex:0];
       // [self.view insertSubview:(backgroundView) atIndex:(0)];
        //[backgroundView release];

       // self.backgroundColor = [SKColor whiteColor];

       [self initalizingScrollingBackground];
        [self addShip];
        //Making self delegate of physics World
       
    }
    
    

       
    
    return self;
}



-(void)addShip
{
    //initalizing spaceship node
//    self.ship = [SKSpriteNode new];
//    self.ship = [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
//    [self.ship  setScale:0.5];
//    self.ship .position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame));
//    
//    //Adding SpriteKit physicsBody for collision detection
//    self.ship .physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.ship.size];
////    self.ship .physicsBody.categoryBitMask = shipCategory;
//    self.ship .physicsBody.dynamic = YES;
////    self.ship .physicsBody.contactTestBitMask = obstacleCategory;
////    self.ship .physicsBody.collisionBitMask = 0;
//    self.ship .name = @"ship";
//
    

    self.ship= [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
    [self.ship setScale:0.5];
    self.ship.position = CGPointMake(100, 200);

    
    self.ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.ship.size.height / 2];
    self.ship.physicsBody.dynamic = YES;
    self.ship.physicsBody.allowsRotation = NO;
   // self.ship.physicsBody.affectedByGravity = YES
     [self addChild:self.ship ];
    

    
    self.physicsWorld.gravity = CGVectorMake( 0.0, -0.5 );
    self.actionMoveUp = [SKAction moveByX:30 y:15 duration:.2];
    actionMoveDown = [SKAction moveByX:0 y:-30 duration:.2];
    actionMoveRight = [SKAction moveByX:30 y:0  duration:.2];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
    
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInNode:self.scene]; //1
//    if(touchLocation.y >self.ship.position.y){ //2
//        if(self.ship.position.y < screenHeight){ //3
//            [self.ship runAction:self.actionMoveUp]; //4
//        }
//    }else{
//        if(self.ship .position.y > 50){
//            [self.ship  runAction:actionMoveDown]; //5
//        }
//    }
    
    
    
}



-(void)initalizingScrollingBackground
{
//    for (int i = 0; i < 2; i++) {
//        self.bg = [SKSpriteNode spriteNodeWithImageNamed:@"CityBackground"];
//        [self.bg setXScale:3.0];
//        [self.bg setYScale:1.5];
//        self.bg.position = CGPointMake(i * self.bg.size.width, 0);
//        self.bg.anchorPoint = CGPointZero;
//        self.bg.name = @"sky";
//        [self addChild:self.bg];
//    }
    
    
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
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, screenHeight/5)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
