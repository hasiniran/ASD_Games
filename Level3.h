//
//  Level3.h
//  ASD_Game
//
//  Created by Matthew Perez on 2/23/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#ifndef ASD_Game_Level3_h
#define ASD_Game_Level3_h

#import <SpriteKit/SpriteKit.h>
#import "Level4.h" //transitions to level 4

//Voice Synthesis imports
#import <AVFoundation/AVFoundation.h>

@interface Level3 : SKScene {}

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end


#endif