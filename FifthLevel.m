//
//  FifthLevel.m
//  ASD_Game
//
//  Created by Joseph Yoon on 7/8/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import "FifthLevel.h"

@implementation FifthLevel {
    SKLabelNode *downButton;
    CGSize screenSize;
    SKSpriteNode *moon, *airplane, *background;
    SKTexture *nightBuildings;
    SKAction* moveRunwayForever, *moveBuildingsForever;
    SKAction* moveSkyForever;
    SKSpriteNode *sky, *buildings;
    SKSpriteNode *runway;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // Set screenSize for ease
        screenSize = [[UIScreen mainScreen] bounds].size;
        
        [self initalizingScrollingBackground];

        moon = [SKSpriteNode spriteNodeWithImageNamed:@"Moon.png"];
        moon.position = CGPointMake(screenSize.width*.85, screenSize.height*.8);
        
        // Create down button
        downButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        downButton.text = @"Down";
        downButton.name = @"downButton";
        downButton.fontSize = 40;
        downButton.fontColor = [SKColor yellowColor];
        downButton.position = CGPointMake(0,-downButton.frame.size.height/2);
        background = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(downButton.frame.size.width, downButton.frame.size.height)];
        background.position = CGPointMake(self.size.width/2, 40);
        [background addChild:downButton];
        
        [self addChild:background];
        [self addChild:moon];
        [self addShip];        
    }
    
    return self;
}

-(void)changeButton
{
    downButton.text = @"End Game";
    downButton.name = @"endGame";
    downButton.fontColor = [SKColor whiteColor];
    downButton.hidden = YES;
    downButton.hidden = NO;
}
-(void)moveToNextScene
{
    exit(0);
}

-(void)addShip
{
    airplane = [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
    [airplane setScale:0.5];
    airplane.position = CGPointMake(200, screenSize.height*0.75);
    airplane.physicsBody = [SKPhysicsBody bodyWithTexture:airplane.texture size:airplane.texture.size];
    airplane.physicsBody.dynamic = YES;
    self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 );
    [self addChild: airplane ];
}


-(void)initalizingScrollingBackground
{
    // Create ground texture
    groundTexture = [SKTexture textureWithImageNamed:@"Runway.png"];
    groundTexture.filteringMode = SKTextureFilteringNearest;
  
    nightBuildings = [SKTexture textureWithImageNamed:@"BuildingsNight.png"];
    nightBuildings.filteringMode = SKTextureFilteringNearest;
    
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
    SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"NightSky.png"];
    skylineTexture.filteringMode = SKTextureFilteringNearest;
    
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
        [bg setScale:2];
        bg.position = CGPointMake(i * bg.size.width, groundTexture.size.height );
        bg.anchorPoint = CGPointZero;
        bg.name = @"sky";
        [self addChild:bg];
    }
   
    for(int i = 1; i < 3; i++){
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:nightBuildings];
        [bg setScale:0.8];
        bg.position = CGPointMake(i*(screenSize.width), groundTexture.size.height-30);
        bg.anchorPoint = CGPointZero;
        bg.name = @"buildings";
        [self addChild:bg];
    }
    
    
    // Create ground physics container
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, 0);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, groundTexture.size.height/2-20)];
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
    SKAction* moveBackground;
    [self enumerateChildNodesWithName:@"runway" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         runway = (SKSpriteNode *)node;
         SKAction* moveRunway = [self moveAction:runway.size.width: .005];
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
    
    [self enumerateChildNodesWithName:@"buildings" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         buildings = (SKSpriteNode *) node;
         SKAction* moveBuildings = [self moveAction:screenSize.width+buildings.size.width: 0.005];
         SKAction* resetBuildings = [self moveAction: -screenSize.width: 0.0];
         moveBuildingsForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBuildings,resetBuildings]]];
         
         if(!buildings.hasActions){
             [buildings runAction: moveBuildingsForever];
         }
     }];
    return moveBackground;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if([node.name isEqualToString:@"downButton"]){
        if(airplane.position.y > (groundTexture.size.height))
        {
            [airplane.physicsBody applyImpulse:CGVectorMake(5, -30)] ;
        }
        [self moveBgContinuously];
    }
    if([node.name isEqualToString:@"endGame"]){
        [self moveToNextScene];
    }
}

-(void)update:(NSTimeInterval)currentTime{
    if(airplane.position.y < (groundTexture.size.height))
    {
        airplane.physicsBody.dynamic = NO;
        [airplane runAction:[SKAction moveTo:CGPointMake(airplane.position.x, groundTexture.size.height/1.5) duration:1] completion:^{
            [self changeButton];
        }];
        
    }
}

@end