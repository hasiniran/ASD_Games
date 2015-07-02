//
//  ThirdLevel.m
//  airplane
//
//  Created by Charles Shinaver on 3/31/15.
//  Copyright (c) 2015 Charles Shinaver. All rights reserved.
//

#import "ThirdLevel.h"

@implementation ThirdLevel {
    int questionDisplayed;
    SKLabelNode *correctButton;
    SKLabelNode *incorrectButton;
    SKLabelNode *question;
    CGSize screenSize;
    NSArray *boats;
    int correctAnswers;
}

-(id)initWithSize:(CGSize)size {
    
    
    if (self = [super initWithSize:size]) {
        
        // Set screenSize for ease
        screenSize = [[UIScreen mainScreen] bounds].size;
       
        // Create boat sprites
        SKSpriteNode *orangeBoat = [SKSpriteNode spriteNodeWithImageNamed:@"OrangeBoat.png"];
        SKSpriteNode *purpleBoat = [SKSpriteNode spriteNodeWithImageNamed:@"PurpleBoat.png"];
        SKSpriteNode *yellowBoat = [SKSpriteNode spriteNodeWithImageNamed:@"YellowBoat.png"];
        orangeBoat.name = @"OrangeBoat";
        purpleBoat.name = @"PurpleBoat";
        yellowBoat.name = @"YellowBoat";
        
        boats = [NSArray arrayWithObjects:orangeBoat, purpleBoat, yellowBoat, nil];
        
        [self initalizingScrollingBackground];
        
        //set boat initial position
        for (SKNode *boat in boats)
        {
            [self addChild:boat];
            boat.position = CGPointMake(screenSize.width *1.2, screenSize.height*.2);
        }

        [self addShip];
        [self boatsIn];
        
        correctAnswers = 0;
    }
    
    return self;
}

-(void)boatsIn
{
    /*
     * boats in from side
     */
    
    double currentWidth = screenSize.width*.55;
    double currentHeight = screenSize.height*.2;
    double dw = screenSize.width*.5/boats.count;
    for (int i = 0; i < boats.count; i++)
    {
        SKSpriteNode *boat = boats[i];
        [boat runAction:[SKAction moveTo:CGPointMake(currentWidth, currentHeight) duration:5] completion:^{  [self askQuestion];}];
        currentWidth += dw;
    }
  
}

-(void)boatsLeave
{
    double dw = screenSize.width*.5/boats.count;
    double width = -dw*boats.count;
    for (int i = 0; i < boats.count; i++){
        SKSpriteNode *boat = boats[i];
        [boat runAction:[SKAction moveTo:CGPointMake(width, screenSize.width*.2) duration:5] completion:^{[self moveToNextScene];}];
        width += dw;
    }
}

-(void)displayButtons
{
    // Create button
    correctButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    correctButton.text = @"6 boats";
    correctButton.name = @"correctButton";
    correctButton.fontSize = 40;
    correctButton.fontColor = [SKColor blueColor];
    correctButton.position = CGPointMake(screenSize.width * 1./4, screenSize.height * 1./25);

    incorrectButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    incorrectButton.text = @"Not 6 boats";
    incorrectButton.name = @"incorrectButton";
    incorrectButton.fontSize = 40;
    incorrectButton.fontColor = [SKColor blueColor];
    incorrectButton.position = CGPointMake(screenSize.width * 3./4, screenSize.height * 1./25);
    [self addChild:correctButton];
    [self addChild:incorrectButton];
}

-(void)askQuestion
{
    /*
     Choose question to be displayed
    */
    
    question.hidden = YES;
    question = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    question.name = @"colorofBoatQuestion";
    question.fontSize = 50;
    question.position = CGPointMake(screenSize.width*.6, screenSize.height *.5);
  
    switch(correctAnswers){
        case 0:
            question.text = @"What color is the first ship?";
            break;
        case 1:
            question.text = @"What color is the second ship?";
            break;
        case 2:
            question.text = @"What color is the third ship?";
            break;
    }
     question.hidden = NO;
    [self addChild:question];
   /* // Set text of question
    switch (questionDisplayed) {
        case 0:
            // Create text label
            question = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
            question.name = @"numberOfBirdsQuestion";
            question.fontSize = 50;
            question.position = CGPointMake(screenSize.width * .5, screenSize.height * 1./10);
            question.text = @"How many birds are in the air?";
            [self addChild:question];
            break;
        case 1:
            question = (SKLabelNode *)[self childNodeWithName:@"numberOfBirdsQuestion"];
            question.text = @"Are you sure? How many birds are in the air?";
            break;
        case 2:
            question = (SKLabelNode *)[self childNodeWithName:@"numberOfBirdsQuestion"];
            question.text = @"Can you say six?";
            break;
        case 3:
            [self moveToNextScene];
            break;
        default:
            question = (SKLabelNode *)[self childNodeWithName:@"numberOfBirdsQuestion"];
            question.text = @"How many birds are in the air?";
    }
    
    // Display question and increment
    questionDisplayed++;
    */
}

-(void)moveToNextScene
{
    exit(0);
    // Move to next scene
  //  SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
  //  FourthLevel * scene = [FourthLevel sceneWithSize:self.view.bounds.size];
  //  scene.scaleMode = SKSceneScaleModeAspectFill;
  //  [self.view presentScene:scene transition: reveal];
}

-(void)addShip
{
    self.ship = [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
    [self.ship setScale:0.5];
    self.ship.position = CGPointMake(200, [[UIScreen mainScreen] bounds].size.height*0.75);
    self.ship.physicsBody = [SKPhysicsBody bodyWithTexture:self.ship.texture size:self.ship.texture.size];
    self.ship.physicsBody.dynamic = YES;
    self.ship.physicsBody.allowsRotation = NO;
    //self.ship.physicsBody.affectedByGravity = YES;
    [self addChild:self.ship ];
    
    self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 );
}


-(void)initalizingScrollingBackground
{
    // Create ground
    
    seaTexture = [SKTexture textureWithImageNamed:@"Sea.png"];
    self.sea = [SKSpriteNode spriteNodeWithTexture:seaTexture];
    seaTexture.filteringMode = SKTextureFilteringNearest;
      // Create ground
    
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:seaTexture];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"sea";
        [self addChild:bg];
    }
    
    waveTexture = [SKTexture textureWithImageNamed:@"Waves.png"];
    self.wave = [SKSpriteNode spriteNodeWithTexture:waveTexture];
    waveTexture.filteringMode = SKTextureFilteringNearest;
    // Create ground
    
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:waveTexture];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"waves";
        [self addChild:bg];
    }
    
   // Create skyline
    SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"Sky-3.png"];
    skylineTexture.filteringMode = SKTextureFilteringNearest;

    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
        [bg setScale:2];
        bg.position = CGPointMake(i * bg.size.width, seaTexture.size.height );
        //  bg.zPosition = -200;
        bg.anchorPoint = CGPointZero;
        bg.name = @"sky";
        [self addChild:bg];
    }
   
    
    // Create ground physics container
    
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, 0);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, seaTexture.size.height/2 -20)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    [self moveBgContinuously];
    
    
    
}

-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval  {
    SKAction* action = [SKAction moveByX:-width*1 y:0 duration: timeInterval* width*2];
    return action;
}

/*
-(SKAction*)moveBgContinuously
{
    
    __block SKAction* moveRunwayForever;
    __block SKAction* moveSkyForever;
    __block SKSpriteNode *sky;
    __block SKSpriteNode *waves;
    SKAction* moveBackground;
    
    [self enumerateChildNodesWithName:@"waves" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         waves = (SKSpriteNode *)node;
         SKAction* moveRunway = [self moveAction:waves.size.width: 0.01];
         SKAction* resetRunway = [self moveAction:-waves.size.width: 0.0];
         moveRunwayForever = [SKAction repeatActionForever:[SKAction sequence:@[moveRunway,resetRunway]]];
         
         
         if( !waves.hasActions){
             [waves runAction: moveRunwayForever];
         }
     }];
    
    
    
    if(!waves.hasActions) {
        [self runAction:moveBackground];
        
    }
    
    return moveBackground;
    
    
}*/
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

    switch (correctAnswers) {
        case 0:
            if([node.name isEqualToString:@"OrangeBoat"])
                correctAnswers++;
            break;
        case 1:
            if([node.name isEqualToString:@"PurpleBoat"])
                correctAnswers++;
            break;
        case 2:
            if([node.name isEqualToString:@"YellowBoat"])
                [self boatsLeave];
            break;
        default:
            break;
    }
   
    [self askQuestion];
}

@end
