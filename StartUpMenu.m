//
//  StartUpMenu.m
//  ASD_Game
//
//  Created by Hasini Yatawatte on 2/4/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartupMenu.h"

#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEAcousticModel.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>


@implementation StartupMenu {
    int instructions;
    NSTimer *instructionTimer;
    NSArray *dictionary;
    NSError *error;
    NSString *lmPath;
    NSString *dictionaryPath;
}


SKScene * scene;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //initialize voice synthesizer
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];

        //initialize voice recognition
        OELanguageModelGenerator *languageModelGenerator = [[OELanguageModelGenerator alloc] init];
        dictionary = [NSArray arrayWithObjects:@"TRAIN", @"AIRPLANE", @"PLANE", nil];
        error = [languageModelGenerator generateLanguageModelFromArray:dictionary withFilesNamed:@"lmFiles" forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]];
        lmPath = nil;
        dictionaryPath = nil;
        if(error == nil) {
            lmPath = [languageModelGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:@"lmFiles"];
            dictionaryPath = [languageModelGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:@"lmFiles"];
        }
        else {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
        [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
        [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dictionaryPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
        
        self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
        [self.openEarsEventsObserver setDelegate:self];

        SKLabelNode *Game1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        Game1.text = @"Airplane Game"; //Set the button text
        Game1.name = @"Airplane";
        Game1.fontSize = 40;
        Game1.fontColor = [SKColor yellowColor];
        Game1.position = CGPointMake(self.size.width/2, self.size.height/2);
      
        
        SKLabelNode *Game2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];   //Second button goes to train game
        Game2.text = @"Train Game";
        Game2.name = @"Train";
        Game2.fontSize = 40;
        Game2.fontColor = [SKColor redColor];
        Game2.position = CGPointMake(self.size.width/2, self.size.height/4);    //Put train button underneath, airplane button
        
        [self addChild:Game1];
        [self addChild:Game2];
        
        instructions = 0;
    }
    [self timer];
    
    return self;
}


-(void)timer {
        instructionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(instructionSpeech) userInfo:nil repeats:YES];
}


-(void)instructionSpeech { //keep repeating different instructions
    instructions++;
    
    if (instructions == 1) { //initial instructions
        AVSpeechUtterance *instruction1 = [[AVSpeechUtterance alloc] initWithString:@"Click on the train or airplane to start playing!"];
        instruction1.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction1.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction1];
        [[OEPocketsphinxController sharedInstance] suspendRecognition];
    }
    else if (instructions == 10) { //wait 10 secs -- follow up 1
        AVSpeechUtterance *instruction2 = [[AVSpeechUtterance alloc] initWithString:@"Choose a game!"];
        instruction2.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction2.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction2];
        [[OEPocketsphinxController sharedInstance] suspendRecognition];
    }
    else if (instructions == 20) { //wait 10 secs -- follow up 2
        AVSpeechUtterance *instruction3 = [[AVSpeechUtterance alloc] initWithString:@"Pick a game to play!"];
        instruction3.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction3.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction3];
        [[OEPocketsphinxController sharedInstance] suspendRecognition];
    }
    else if (instructions > 29) { //wait another 10 secs -- restart instructions
        instructions = 0;
    }
    else {
        [[OEPocketsphinxController sharedInstance] resumeRecognition];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { //When selection is made
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //stop repeating instructions
    [instructionTimer invalidate];
    instructionTimer = nil;

    //stop listening
    [[OEPocketsphinxController sharedInstance] suspendRecognition];
    [[OEPocketsphinxController sharedInstance] stopListening];

    if ([node.name isEqualToString:@"Airplane"]) {
        AVSpeechUtterance *airplaneTransition = [[AVSpeechUtterance alloc] initWithString:@"Let's play the airplane game!"];
        airplaneTransition.rate = AVSpeechUtteranceMinimumSpeechRate;
        airplaneTransition.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:airplaneTransition];
        
        //Transition to airplane level 1
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration :1.0];
        AirplaneScene1 * scene = [AirplaneScene1 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    
    //if train button is pressed, Go to train game
    else if ([node.name isEqualToString:@"Train"]) {
        AVSpeechUtterance *trainTransition = [[AVSpeechUtterance alloc] initWithString:@"Let's play the train game!"];
        trainTransition.rate = AVSpeechUtteranceMinimumSpeechRate;
        trainTransition.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:trainTransition];
        
        //Transition to train level 1
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration :1.0];
        Level1 *scene= [Level1 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
}


//Voice Recognition internal dialogue
-(void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
}

-(void) pocketsphinxDidStartListening {
    NSLog(@"Pocketsphinx is now listening.");
}

-(void) pocketsphinxDidDetectSpeech {
    NSLog(@"Pocketsphinx has detected speech.");
}

-(void) pocketsphinxDidDetectFinishedSpeech {
    NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

-(void) pocketsphinxDidStopListening {
    NSLog(@"Pocketsphinx has stopped listening.");
}

-(void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Pocketsphinx has suspended recognition.");
}

-(void) pocketsphinxDidResumeRecognition {
    NSLog(@"Pocketsphinx has resumed recognition.");
}

-(void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
    NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

-(void) pocketSphinxContinuousSetupDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening setup wasn't successful and returned the failure reason: %@", reasonForFailure);
}

-(void) pocketSphinxContinuousTeardownDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening teardown wasn't successful and returned the failure reason: %@", reasonForFailure);
}

-(void) testRecognitionCompleted {
    NSLog(@"A test file that was submitted for recognition is now complete.");
}


@end
