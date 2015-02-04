//
//  GameScene.m
//  Autism_train
//
//  Created by Matthew Perez on 1/28/15.
//  Copyright (c) 2015 Matthew Perez. All rights reserved.
//

#import "GameScene.h"
//LEVEL1
@implementation GameScene{
    SKNode *_train;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    NSTimeInterval *_dt;
    NSTimeInterval *_lastUpdateTime;
}

-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        //[self initalizingScrollingBackground];
        //[self train];
        self.backgroundColor = [SKColor colorWithRed:.15 green:.15 blue:.3 alpha:1];
        
        
    }
    return self;

}
/*
-(void)train{
    _train = [SKNode node];
    SKShapeNode *rect = [SKShapeNode node];
    rect.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-10, 10, 20, 20)].CGPath;
    rect.fillColor = [UIColor blueColor];
    rect.strokeColor = [UIColor blueColor];
    rect.glowWidth = 5;
    [_train addChild:rect];
    _train.position = CGPointMake(screenWidth/2, screenHeight/2);
    
    
    [self addChild:_train];
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    /*
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
     */
    
    
    
    
    
}
/*
-(void)initalizingScrollingBackground
{
    
    
    // Create ground
    
    groundTexture = [SKTexture textureWithImageNamed:@"runway2.png"];
    self.runway = [SKSpriteNode spriteNodeWithTexture:groundTexture];
    groundTexture.filteringMode = SKTextureFilteringNearest;
    
    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration: 0.02 * groundTexture.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
}


-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval  {
    SKAction* action = [SKAction moveByX:-width*1 y:0 duration: timeInterval* width*2];
    return action;
}


-(SKAction*)moveBgContinuously
{
    
    __block SKAction* moveRunwayForever;
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
    
    
    return moveBackground;
    
    
}*/

@end
