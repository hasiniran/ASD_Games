//
//  MyScene.m
//  airplane
//
//  Created by Hasini Yatawatte on 10/22/14.
//  Copyright (c) 2014 Hasini Yatawatte. All rights reserved.
//

#import "AirplaneScene1.h"

@implementation AirplaneScene1


-(id)initWithSize:(CGSize)size {
    
    
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    
    
    if (self = [super initWithSize:size]) {


       [self initalizingScrollingBackground];
       [self addShip];

        
        // add the Go button
        //should be removed after embedding voice commands
        SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        go.text = @"Go"; //Set the button text
        go.name = @"Go";
        go.fontSize = 40;
        go.fontColor = [SKColor yellowColor];
        go.position = CGPointMake(0,-go.frame.size.height/2);
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(go.frame.size.width, go.frame.size.height)];
        background.position = CGPointMake(self.size.width/2, 40);
        [background addChild:go];

        [self addChild:background];
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
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"level2"]) {
        
    
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SecondLevel * scene = [SecondLevel sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }else if ([node.name isEqualToString:@"Go"]) {
       
        
            if(self.ship.position.y < [[UIScreen mainScreen] bounds].size.height*0.75){
        
                [self.ship.physicsBody applyImpulse:CGVectorMake(0, 30)];
            }else{
        
                [self.ship setPosition:CGPointMake(self.ship.position.x, [[UIScreen mainScreen] bounds].size.height*0.75)];
                self.ship.physicsBody.dynamic = NO;
        
            }
        
             [self moveBgContinuously];
        
    }
    
}



-(void)initalizingScrollingBackground
{

    
    // Create ground texture
    
    groundTexture = [SKTexture textureWithImageNamed:@"Runway.png"];
    self.runway = [SKSpriteNode spriteNodeWithTexture:groundTexture];
    groundTexture.filteringMode = SKTextureFilteringNearest;
    
    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration: 0.02 * groundTexture.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    // Create ground
    // multiple images are merged to give the illusion of continuity

    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"runway";
        [self addChild:bg];
    }
    

    // Create skyline

    
    SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"Sky.png"];
    skylineTexture.filteringMode = SKTextureFilteringNearest;
 
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
        bg.position = CGPointMake(i * bg.size.width, groundTexture.size.height );
      //  bg.zPosition = -200;
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
   // [self moveBg];
    
    
    
}

-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval  {
    SKAction* action = [SKAction moveByX:-width*1 y:0 duration: timeInterval* width*2];
    return action;
}


-(SKAction*)moveBgContinuously
{

    __block SKAction* moveRunwayForever;
    __block SKAction* moveSkyForever;
    __block SKSpriteNode *sky;
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
    

    
    [self enumerateChildNodesWithName:@"sky" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         sky = (SKSpriteNode *) node;
         SKAction* moveSky = [self moveAction:sky.size.width*1.0: 0.009];
         SKAction* resetSky = [self moveAction:-sky.size.width: 0.0];
         moveSkyForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSky,resetSky]]];
         
         if( !sky.hasActions){
             [sky runAction: moveSkyForever];
         }
     }];
    

    
    

//     moveBackground = [SKAction group:@[[SKAction runBlock:^{
//                                                            [runway runAction:moveRunwayForever];
//                                                           }
//                                        ],
//                                       [SKAction runBlock:^{
//                                                            [sky runAction:moveSkyForever];
//                                                            }
//                                        ]]];
//    
//    
//    moveBackground = [SKAction group:@[ [SKAction runActi],
//                                         [SKAction runAction:moveSkyForever onChildWithName:@"sky"] ]];
    
//                    
//    
//    if(!sky.hasActions && !runway.hasActions) {
//       [self runAction:moveBackground];
//        
//    }
    
    return moveBackground;
    
    
}



- (void)moveBg
{
    [self enumerateChildNodesWithName:@"runway" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
       //  CGFloat bgVelocity = -1*fabs(self.ship.physicsBody.velocity.dy);
        // CGFloat bgVelocity = -100;
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
        // CGFloat bgVelocity = -10;
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


-(void)levelCompleted:(BOOL)won{
    
    if(won){
        //make a label that is invisible
        SKLabelNode *flashLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        flashLabel.position = CGPointMake(screenWidth/2, screenHeight/2);
        flashLabel.fontSize = 30;
        flashLabel.fontColor = [SKColor blueColor];
        flashLabel.text = @"Level 1 Completed !!";
        flashLabel.alpha =0;
        flashLabel.zPosition = 100;
        [self addChild:flashLabel];
        //make an animation sequence to flash in and out the label
        SKAction *flashAction = [SKAction sequence:@[
                                                     [SKAction fadeInWithDuration:3],
                                                     [SKAction waitForDuration:0.05],
                                                     [SKAction fadeOutWithDuration:3]
                                                     ]];
        // run the sequence then delete the label
        [flashLabel runAction:flashAction completion:^{[flashLabel removeFromParent];}];
        
        NSString * retrymessage;
        retrymessage = @"Go to Level 2";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blueColor];
        retryButton.color = [SKColor yellowColor];
        retryButton.position = CGPointMake(self.size.width/2, screenHeight/2-100);
        retryButton.name = @"level2";
        [self addChild:retryButton];

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
        
       [self moveBgContinuously];
        
    }
    else if(self.ship.physicsBody.velocity.dy==0 && self.ship.position.y < [[UIScreen mainScreen] bounds].size.height*0.75)
    {
        [self enumerateChildNodesWithName:@"runway" usingBlock: ^(SKNode *node, BOOL *stop)
         {
             SKSpriteNode * bg = (SKSpriteNode *) node;
        
             
             if( bg.hasActions){
               //  [bg removeAllActions];
    
             }
         }];
        
        
        [self enumerateChildNodesWithName:@"sky" usingBlock: ^(SKNode *node, BOOL *stop)
         {
             SKSpriteNode * bg = (SKSpriteNode *) node;
             
             
             if( bg.hasActions){
                // [bg removeAllActions];
                 
             }
         }];
     
    }
    
    if( self.ship.position.y >= [[UIScreen mainScreen] bounds].size.height*0.75 ){
        [self.ship setPosition:CGPointMake(self.ship.position.x, [[UIScreen mainScreen] bounds].size.height*0.75)];
        self.ship.physicsBody.dynamic = NO;
        [self levelCompleted:TRUE];
    }
    
    
    
    
}

@end
