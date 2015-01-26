//
//  MyScene.h
//  airplane
//

//  Copyright (c) 2014 Hasini Yatawatte. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SecondLevel.h"


static const uint32_t shipCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;
static CGFloat RUNWAY_VELOCITY = -5.0;
static CGFloat SKY_VELOCITY = -5.0;

static  uint32_t _dt = 0;
static  uint32_t _lastUpdateTime = 0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}


@interface MyScene : SKScene{
   

    SKAction *actionMoveDown;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    SKAction *actionMoveRight;
    SKTexture* groundTexture;
    SKAction* moveGroundSpritesForever;
    
}

@property (nonatomic, strong)  SKSpriteNode *ship;
@property (nonatomic,strong)   SKAction *actionMoveUp;
@property (nonatomic, strong)    SKSpriteNode *bg ;
@property (nonatomic, strong)    SKSpriteNode *sky ;
@property (nonatomic, strong)    SKSpriteNode *runway ;


-(SKAction*)moveBgContinuously;
-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval ;

-(void)levelCompleted:(BOOL)won;

@end
