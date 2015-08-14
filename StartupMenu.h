//
//  StartupMenu.h
//  ASD_Game
//
//  Created by Hasini Yatawatte on 2/4/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#ifndef ASD_Game_StartupMenu_h
#define ASD_Game_StartupMenu_h


#import <SpriteKit/SpriteKit.h>
//transitions to level 1 of airplane or train game
#import "AirplaneScene1.h"
#import "Level1.h"

//Voice Synthesis imports
#import <AVFoundation/AVFoundation.h>


@interface StartupMenu : SKScene{
}


@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;


@end


#endif
