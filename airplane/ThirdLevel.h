//
//  ThirdLevel.h //  airplane
//
//  Created by Charles Shinaver on 3/31/15.
//  Copyright (c) 2015 Charles Shinaver. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ThirdLevel : SKScene{
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
@end
