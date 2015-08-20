//
//  SecondLevel.m
//  airplane
//
//  Created by Hasini Yatawatte on 1/26/15.
//  Maintained by Charles Shinaver since 3/30/15
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.


#import "SecondLevel.h"

#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEAcousticModel.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>
#import <RejectoDemo/OELanguageModelGenerator+Rejecto.h>
#import <RapidEarsDemo/OEPocketsphinxController+RapidEars.h>


@implementation SecondLevel {
    int objectsDisplayed;
    int numberSaid;
    int questionDisplayed;
    int correctAnswers;
    int level; //0 = birds, 1 = balloons, 2 = clouds
    NSArray *birds, *balloons, *UFOs;
    SKLabelNode *skip;
    SKLabelNode *question;
    NSMutableArray *objectNames;
    int instructions;
    NSTimer *instructionTimer;
    SKLabelNode *instructionText;
    AVSpeechUtterance *instruction;
    NSString *lmPath, *dicPath;
    NSArray *words;
}


/**/

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        //get bounds for horizontal view when using iPad, screenRect don't work in simulator
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = self.size.height;//screenRect.size.width;
        screenWidth = self.size.width;//screenRect.size.height;
        
        self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
        [self.openEarsEventsObserver setDelegate:self];

        OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
        
        words = [NSArray arrayWithObjects:@"ONE",@"TWO",@"THREE",@"FOUR",@"FIVE",@"SIX",/*@"HOW MANY ARE IN THE AIR", @"BIRDS", @"BALLOONS", @"U.F.OS", @"ARE YOU SURE",*/ nil];
        NSString *name = @"NameIWantForMyLanguageModelFiles";
      /*  NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish language model instead of an English one.
      */
        
        NSError *err = [lmGenerator generateRejectingLanguageModelFromArray:words
                                                             withFilesNamed:name
                                                     withOptionalExclusions:nil
                                                            usingVowelsOnly:FALSE
                                                                 withWeight:nil
                                                     forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish Rejecto model.
        

        lmPath = nil;
        dicPath = nil;
        
        if(err == nil) {
            
            lmPath = [lmGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:@"NameIWantForMyLanguageModelFiles"];
            dicPath = [lmGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:@"NameIWantForMyLanguageModelFiles"];
            
        } else {
            NSLog(@"Error: %@",[err localizedDescription]);
        }
        instructions = 0;
        
        //initialize synthesizer
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    
        objectNames = [NSMutableArray arrayWithObjects:@"birds", @"balloons", @"U.F.Os", nil];
        
        // Create bird sprites
        SKSpriteNode *blueBird = [SKSpriteNode spriteNodeWithImageNamed:@"BlueBird.png"];
        SKSpriteNode *lightPinkBird = [SKSpriteNode spriteNodeWithImageNamed:@"LightPinkBird.png"];
        SKSpriteNode *orangeBird = [SKSpriteNode spriteNodeWithImageNamed:@"OrangeBird.png"];
        SKSpriteNode *pinkBird = [SKSpriteNode spriteNodeWithImageNamed:@"PinkBird.png"];
        SKSpriteNode *purpleBird = [SKSpriteNode spriteNodeWithImageNamed:@"PurpleBird.png"];
        SKSpriteNode *yellowBird = [SKSpriteNode spriteNodeWithImageNamed:@"YellowBird.png"];
        birds = [NSArray arrayWithObjects:blueBird, lightPinkBird, orangeBird, pinkBird, purpleBird, yellowBird, nil];
        for (SKSpriteNode *bird in birds)
        {
            bird.name = @"bird";
        }
        
        //Create balloon sprites
        SKSpriteNode *blueBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"BlueBalloon.png"];
        SKSpriteNode *lightPinkBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"LightPinkBalloon.png"];
        SKSpriteNode *orangeBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"OrangeBalloon.png"];
        SKSpriteNode *pinkBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"PinkBalloon.png"];
        SKSpriteNode *purpleBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"PurpleBalloon.png"];
        SKSpriteNode *yellowBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"YellowBalloon.png"];
        balloons = [NSArray arrayWithObjects:blueBalloon, lightPinkBalloon, orangeBalloon, pinkBalloon, purpleBalloon, yellowBalloon, nil];
        for (SKSpriteNode *balloon in balloons)
        {
            balloon.name = @"balloon";
        }
        
        //create UFO sprites
        SKSpriteNode *UFO1 = [SKSpriteNode spriteNodeWithImageNamed:@"UFO.png"];
        SKSpriteNode *UFO2 = [SKSpriteNode spriteNodeWithImageNamed:@"UFO.png"];
        SKSpriteNode *UFO3 = [SKSpriteNode spriteNodeWithImageNamed:@"UFO.png"];
        SKSpriteNode *UFO4 = [SKSpriteNode spriteNodeWithImageNamed:@"UFO.png"];
        SKSpriteNode *UFO5 = [SKSpriteNode spriteNodeWithImageNamed:@"UFO.png"];
        SKSpriteNode *UFO6 = [SKSpriteNode spriteNodeWithImageNamed:@"UFO.png"];
        UFOs = [NSArray arrayWithObjects:UFO1, UFO2, UFO3, UFO4, UFO5, UFO6, nil];
        for (SKSpriteNode *UFO in UFOs)
        {
            UFO.name = @"UFO";
        }

        // Create button
        skip = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP"; //Set the button text
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [self addChild:skip]; //add node to screen
        
        // Create question
        question = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        question.fontSize = 50;
        question.position = CGPointMake(screenWidth * .5, screenHeight * 1./10);
        question.name = @"numberOfBirdsQuestion";
        question.hidden = YES;

        [self initalizingScrollingBackground];
        [self addChild:question];
        
        for (SKNode *bird in birds)
        {
            [self addChild:bird];
            // Set bird initial position
            bird.position = CGPointMake(screenWidth *1.2, screenHeight*1.2);
        }
        
        for (SKNode *balloon in balloons)
        {
            [self addChild:balloon];
            // Set balloon initial position
            balloon.position = CGPointMake(screenWidth *1.2, screenHeight*1.2);
        }
        
        for (SKNode *UFO in UFOs)
        {
            [self addChild:UFO];
            // Set balloon initial position
            UFO.position = CGPointMake(screenWidth *1.2, screenHeight*1.2);
        }
        
        [self addShip];
        [self birdsFlyIn];
       // [self timer];
        // Set objectsDisplayed
        objectsDisplayed = 0;
        // Set question displayed
        questionDisplayed = 0;
        correctAnswers = 0;
        numberSaid = 0;
    }
    return self;
}

/*-(void)timer {
    instructionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(giveInstructions) userInfo:nil repeats:YES];
}*/

-(void)recognizeSpeech
{
    [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
    [[OEPocketsphinxController sharedInstance] startRealtimeListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]]; // Starts the rapid recognition loop. Change "AcousticModelEnglish" to "AcousticModelSpanish" in order to perform Spanish language recognition.
    /*
    [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to perform Spanish recognition instead of English.
    */
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    if([recognitionScore intValue] > -100000)
        [self correctHypothesis:hypothesis];
    /*else{
        [[OEPocketsphinxController sharedInstance] stopListening];
        instruction = [[AVSpeechUtterance alloc] initWithString:@"Please repeat."];
        instruction.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction.pitchMultiplier = 1.2;
        [self.synthesizer speakUtterance:instruction];
    }*/
}

-(void)birdSpin:(NSInteger)num
{
    [birds[num] runAction: [SKAction rotateByAngle:2*M_PI duration:0.5]];
}

-(void)correctHypothesis:(NSString *)hypothesis
{
    NSLog(@"%d", objectsDisplayed);
    if([hypothesis isEqualToString:words[numberSaid]])
    {
        [self birdSpin:numberSaid];
        numberSaid++;
    }
    if(1/*numberSaid == objectsDisplayed*/)
    {
        correctAnswers++;
        instruction = [[AVSpeechUtterance alloc] initWithString:@"Good job"];
        instruction.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction.pitchMultiplier = 1;
        [self.synthesizer speakUtterance:instruction];
        [self birdsFlyOut];
    }
    /*if([hypothesis isEqualToString:words[objectsDisplayed-1]])
    {
        questionDisplayed = 0;
        correctAnswers++;
     
        if (correctAnswers == 3)
        {
            [self moveToNextScene];
            question.hidden = YES;
        }
        else
        {
            question.hidden = YES;
            switch (correctAnswers){
                case 1:
                    [self birdsFlyOut];
                    [self balloonsFlyIn];
                    break;
                case 2:
                    [self balloonsFlyOut];
                    [self ufosFlyIn];
                    break;
            }
            
        }
    }
    else
    {
        if(questionDisplayed < 3){
            [self askQuestion];
        }
        else{
            questionDisplayed = 0;
            question.hidden = YES;
            switch (correctAnswers){
                case 0:
                    [self birdsFlyOutAndFlyBackIn];
                    break;
                case 1:
                    [self balloonsFlyOutAndFlyBackIn];
                    break;
                case 2:
                    [self ufosFlyOutAndFlyBackIn];
                    break;
            }
        }
    }*/
}

- (void) pocketsphinxDidStartListening {
    NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
    NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
    NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
    NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
    NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
    NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening setup wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) pocketSphinxContinuousTeardownDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening teardown wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) testRecognitionCompleted {
    NSLog(@"A test file that was submitted for recognition is now complete.");
}

- (void) rapidEarsDidReceiveLiveSpeechHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore {
    NSLog(@"rapidEarsDidReceiveLiveSpeechHypothesis: %@, %@",hypothesis, recognitionScore);
    if([recognitionScore intValue] > -7000)
        [self correctHypothesis:hypothesis];
}

- (void) rapidEarsDidReceiveFinishedSpeechHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore {
    NSLog(@"rapidEarsDidReceiveFinishedSpeechHypothesis: %@",hypothesis);
}

-(void)ufosFlyIn
{
    /*
     * UFOs fly in from side
     * The number of UFOs will be random.
     * As
     */
    
    // Set ufo positions
    int numUFOs = arc4random_uniform(UFOs.count)+1;
    if (!numUFOs)
        numUFOs = 1;
    double maxHeight = screenHeight*0.85;
    double dh = maxHeight * 1/8;
    double currentHeight = maxHeight;
    double minWidth = screenWidth * .5;
    double dw = minWidth / numUFOs;
    double currentWidth = minWidth;
    
    for (int i = 0; i < numUFOs; i++)
    {
        SKSpriteNode *UFO = UFOs[i];
        [UFO runAction:[SKAction moveTo:CGPointMake(currentWidth, currentHeight) duration:5] completion:^{
            objectsDisplayed++;
            if (objectsDisplayed == numUFOs)
            {
                [self askQuestion];
            }
        }];
        currentHeight -= dh;
        currentWidth += dw;
    }
}

-(void)ufosFlyOutAndFlyBackIn
{
    /*
     * UFOs fly out
     */
    
    int numUFOs = objectsDisplayed;
    
    // Set UFO positions
    for (int i = 0; i < numUFOs; i++)
    {
        SKSpriteNode *UFO = UFOs[i];
        [UFO runAction:[SKAction moveTo:CGPointMake(screenWidth*1.2, screenHeight*1.2) duration:2] completion:^{
            objectsDisplayed--;
            if (objectsDisplayed == 0)
            {
                [self ufosFlyIn];
            }
        }];
    };
}

-(void)balloonsFlyIn
{
    /*
     * Balloons fly in from side
     * The number of balloons will be random.
     * As
     */
    
    // Set bird positions
    int numBalloons = arc4random_uniform(balloons.count)+1;
    if (!numBalloons)
        numBalloons = 1;
    double maxHeight = screenHeight*0.85;
    double dh = maxHeight * 1/8;
    double currentHeight = maxHeight;
    double minWidth = screenWidth * .5;
    double dw = minWidth / numBalloons;
    double currentWidth = minWidth;
    
    for (int i = 0; i < numBalloons; i++)
    {
        SKSpriteNode *balloon = balloons[i];
        [balloon runAction:[SKAction moveTo:CGPointMake(currentWidth, currentHeight) duration:5] completion:^{
            objectsDisplayed++;
            if (objectsDisplayed == numBalloons)
            {
                [self askQuestion];
            }
        }];
        currentHeight -= dh;
        currentWidth += dw;
    }
}

-(void)balloonsFlyOut
{
    /*
     * Balloons fly out
     */
    
    int numBalloons = objectsDisplayed;
    
    // Set bird positions
    for (int i = 0; i < numBalloons; i++)
    {
        SKSpriteNode *balloon = balloons[i];
        [balloon runAction:[SKAction moveTo:CGPointMake(screenWidth*1.2, screenHeight*1.2) duration:2] completion:^{
            objectsDisplayed--;
            if (objectsDisplayed == 0)
            {
            }
        }];
    };
    
}

-(void)balloonsFlyOutAndFlyBackIn
{
    /*
     * Balloonss fly out
     */
    
    int numBalloons = objectsDisplayed;
    
    // Set balloon positions
    for (int i = 0; i < numBalloons; i++)
    {
        SKSpriteNode *balloon = balloons[i];
        [balloon runAction:[SKAction moveTo:CGPointMake(screenWidth*1.2, screenHeight*1.2) duration:2] completion:^{
            objectsDisplayed--;
            if (objectsDisplayed == 0)
            {
                [self balloonsFlyIn];
            }
        }];
    };
}

-(void)birdsFlyIn
{
    /*
     * Birds fly in from side
     * The number of birds will be random. 
     * As
    */

    // Set bird positions
    int numBirds = arc4random_uniform(birds.count)+1;
    if (!numBirds)
        numBirds = 1;
    double maxHeight = screenHeight*0.85;
    double dh = maxHeight * 1/8;
    double currentHeight = maxHeight;
    double minWidth = screenWidth * .5;
    double dw = minWidth / numBirds;
    double currentWidth = minWidth;
    
    for (int i = 0; i < numBirds; i++)
    {
        SKSpriteNode *bird = birds[i];
        [bird runAction:[SKAction moveTo:CGPointMake(currentWidth, currentHeight) duration:5] completion:^{
            objectsDisplayed++;
            if (objectsDisplayed == numBirds)
            {
                [self askQuestion];
            }
        }];
        currentHeight -= dh;
        currentWidth += dw;
    }
}

-(void)birdsFlyOut
{
    /*
     * Birds fly out
    */
    
    int numBirds = objectsDisplayed;

    // Set bird positions
    for (int i = 0; i < numBirds; i++)
    {
        SKSpriteNode *bird = birds[i];
        [bird runAction:[SKAction moveTo:CGPointMake(screenWidth*1.2, screenHeight*1.2) duration:2] completion:^{
            objectsDisplayed--;
            if (objectsDisplayed == 0)
            {
            }
        }];
    };

}

-(void)birdsFlyOutAndFlyBackIn
{
    /*
     * Birds fly out
    */
    
    int numBirds = objectsDisplayed;

    // Set bird positions
    for (int i = 0; i < numBirds; i++)
    {
        SKSpriteNode *bird = birds[i];
        [bird runAction:[SKAction moveTo:CGPointMake(screenWidth*1.2, screenHeight*1.2) duration:2] completion:^{
            objectsDisplayed--;
            if (objectsDisplayed == 0)
            {
                [self birdsFlyIn];
            }
        }];
    };
}

-(void)askQuestion
{
    /*
     Choose question to be displayed
    */
    [[OEPocketsphinxController sharedInstance] stopListening];
    // Set text of question
    switch (questionDisplayed) {
        case 0:
            // Create text label
            question.text =  [NSString stringWithFormat:@"Count the %@ in the air.", objectNames[correctAnswers]];
            question.hidden = NO;
            break;
        case 1:
            question.text = [NSString stringWithFormat:@"Count the %@ in the air.", objectNames[correctAnswers]];
            question.hidden = NO;
            break;
        case 2:
            question.text = [NSString stringWithFormat:@"Say %i %@?", objectsDisplayed, objectNames[correctAnswers]];
            question.hidden = NO;
            break;
        default:
            question.text = @"How many birds are in the air?";
    }
    
    // Display question and increment
    questionDisplayed++;
    instruction = [[AVSpeechUtterance alloc] initWithString:question.text];
    instruction.rate = AVSpeechUtteranceMinimumSpeechRate;
    instruction.pitchMultiplier = 1.5;
    [self.synthesizer speakUtterance:instruction];
    // Set text of answers
    while(self.synthesizer.speaking)
    {}
    [self recognizeSpeech];
}

-(void)moveToNextScene
{
    // Move to next scene
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    ThirdLevel *scene = [ThirdLevel sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition: reveal];
}

-(void)addShip
{
    self.ship= [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
    [self.ship setScale:0.5];
    self.ship.position = CGPointMake(200, self.size.height*0.75);
    self.ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    self.ship.physicsBody.dynamic = YES;
    self.ship.physicsBody.allowsRotation = NO;
    // self.ship.physicsBody.affectedByGravity = YES
    [self addChild:self.ship ];
    self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 );
}

-(void)initalizingScrollingBackground
{
    // Create the sea
    seaTexture = [SKTexture textureWithImageNamed:@"Sea.png"];
    seaTexture.filteringMode = SKTextureFilteringNearest;
    
    // Create sea texture
    for (int i = 0; i < 3; i++) {
        _bg = [SKSpriteNode spriteNodeWithTexture:seaTexture];
        _bg.position = CGPointMake(i * _bg.size.width, 0);
        _bg.anchorPoint = CGPointZero;
        _bg.name = @"sea";
        [self addChild:_bg];
    }

    waveTexture = [SKTexture textureWithImageNamed:@"Waves.png"];
    waveTexture.filteringMode = SKTextureFilteringNearest;
    // Create ground
    for (int i = 0; i < 3; i++) {
        _bg = [SKSpriteNode spriteNodeWithTexture:waveTexture];
        _bg.position = CGPointMake(i * _bg.size.width, 0);
        _bg.anchorPoint = CGPointZero;
        _bg.name = @"waves";
        [self addChild:_bg];
    }

    // Create skyline
    skylineTexture = [SKTexture textureWithImageNamed:@"Sky-3.png"];
    skylineTexture.filteringMode = SKTextureFilteringNearest;
    for (int i = 0; i < 3; i++) {
        self.bg = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
        [_bg setScale:2];
        _bg.position = CGPointMake(i * _bg.size.width, seaTexture.size.height );
        _bg.zPosition = -200;
        _bg.anchorPoint = CGPointZero;
        _bg.name = @"sky";
        [self addChild:_bg];
    }

    // Create ground physics container
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, 0);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, seaTexture.size.height/2 -20)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    [self moveBgContinuously];
}

-(SKAction*)moveBgContinuously
{
    __block SKAction* moveForever;
    __block SKSpriteNode *waves;
    SKAction* moveBackground;
    
    [self enumerateChildNodesWithName:@"waves" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         waves = (SKSpriteNode *)node;
         SKAction* move = [Actions moveAction:waves.size.width: 0.01];
         SKAction* reset = [Actions moveAction:-waves.size.width: 0.0];
         moveForever = [SKAction repeatActionForever:[SKAction sequence:@[move,reset]]];
         if( !waves.hasActions){
             [waves runAction: moveForever];
         }
     }];
    
    if(!waves.hasActions) {
       [self runAction:moveBackground];
    }
    return moveBackground;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"Skip"]) {
        [self moveToNextScene];
    }
}

@end
