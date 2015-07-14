//
//  FifthLevel.h
//  ASD_Game
//
//  Created by Joseph Yoon on 7/8/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Actions.h"
#import "FifthLevel.h"
#import <AVFoundation/AVFoundation.h>

@interface FifthLevel : SKScene{
    SKAction *actionMoveDown;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    SKAction *actionMoveRight;
    SKTexture* groundTexture;
    SKTexture* waveTexture;
    SKAction* moveGroundSpritesForever;
}

@property (nonatomic,strong)   SKAction *actionMoveUp;
@property (nonatomic, strong)    SKSpriteNode *bg ;
@property (nonatomic, strong)    SKSpriteNode *sea ;
@property (nonatomic, strong)    SKSpriteNode *wave ;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;


-(SKAction*)moveBgContinuously;
@end
