//
//  SecondLevel.h
//  airplane
//
//  Created by Hasini Yatawatte on 1/26/15.
//  Maintained by Charles Shinaver since 3/30/15
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Actions.h"
#import "ThirdLevel.h"
#import <AVFoundation/AVFoundation.h>
#import <OpenEars/OEEventsObserver.h>

@interface SecondLevel : SKScene <OEEventsObserverDelegate>{
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
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;

-(SKAction*)moveBgContinuously;

@end
