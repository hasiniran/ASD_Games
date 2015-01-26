//
//  SecondLevel.h
//  airplane
//
//  Created by Hasini Yatawatte on 1/26/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SecondLevel : SKScene{
    SKAction *actionMoveDown;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    SKAction *actionMoveRight;
    SKTexture* seaTexture;
    SKTexture* waveTexture;
    SKAction* moveGroundSpritesForever;
}

@property (nonatomic, strong)  SKSpriteNode *ship;
@property (nonatomic,strong)   SKAction *actionMoveUp;
@property (nonatomic, strong)    SKSpriteNode *bg ;
@property (nonatomic, strong)    SKSpriteNode *sky ;
@property (nonatomic, strong)    SKSpriteNode *sea ;
@property (nonatomic, strong)    SKSpriteNode *wave ;

-(SKAction*)moveBgContinuously;
-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval ;
@end
