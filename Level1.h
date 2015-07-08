//
//  GameScene.h
//  Autism_train
//
//  Copyright (c) 2015 Matthew Perez. All rights reserved.
//


#ifndef ASD_Game_Level1_h
#define ASD_Game_Level1_h


#import <SpriteKit/SpriteKit.h>
#import "Level2.h"  //transitions to level 2 of train game

//Voice Synthesis imports
#import <AVFoundation/AVFoundation.h>


@interface Level1 : SKScene {}


@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;


@end


#endif