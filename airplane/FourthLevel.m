//
//  FourthLevel.m
//  ASD_Game
//
//  Created by Joseph Yoon on 7/2/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//
//airplane drops crate over boat with person on it
#import "FourthLevel.h"

@implementation FourthLevel {
    SKLabelNode *correctButton, *incorrectButton;
    SKLabelNode *question;
    CGSize screenSize;
    NSArray *boats;
    int correctAnswers, questionDisplayed, captainsBoat;
    NSMutableArray *shipPlace, *shipColor;
    SKSpriteNode *orangeBoat, *purpleBoat, *yellowBoat;
    SKSpriteNode *captainBoy, *package, *sun, *airplane;
}

-(id)initWithSize:(CGSize)size {
    
    shipPlace = [NSMutableArray arrayWithObjects:@"first", @"second", @"third", nil];
    shipColor = [NSMutableArray arrayWithObjects:@"Orange", @"Purple", @"Yellow", nil];
    
    if (self = [super initWithSize:size]) {
        
        // Set screenSize for ease
        screenSize = [[UIScreen mainScreen] bounds].size;
        
        [self initalizingScrollingBackground];
        
        // Create boat sprites
        orangeBoat = [SKSpriteNode spriteNodeWithImageNamed:@"OrangeBoat.png"];
        purpleBoat = [SKSpriteNode spriteNodeWithImageNamed:@"PurpleBoat.png"];
        yellowBoat = [SKSpriteNode spriteNodeWithImageNamed:@"YellowBoat.png"];
        orangeBoat.name = @"Orange";
        purpleBoat.name = @"Purple";
        yellowBoat.name = @"Yellow";
        
        boats = [NSArray arrayWithObjects:orangeBoat, purpleBoat, yellowBoat, nil];
        
        sun = [SKSpriteNode spriteNodeWithImageNamed:@"Sun.png"];
        sun.position = CGPointMake(screenSize.width*.85, screenSize.height*.8);
        
        //question specifications
        question.hidden = YES;
        question = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        question.name = @"colorofBoatQuestion";
        question.fontSize = 50;
        question.position = CGPointMake(screenSize.width*.5, screenSize.height *.5);
        
        // Create button
        correctButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        correctButton.text = @"Orange";
        correctButton.name = @"correctButton";
        correctButton.fontSize = 40;
        correctButton.fontColor = [SKColor blueColor];
        correctButton.position = CGPointMake(screenSize.width * 1./4, screenSize.height * 1./25);
        
        incorrectButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        incorrectButton.text = @"Not Orange";
        incorrectButton.name = @"incorrectButton";
        incorrectButton.fontSize = 40;
        incorrectButton.fontColor = [SKColor blueColor];
        incorrectButton.position = CGPointMake(screenSize.width * 3./4, screenSize.height * 1./25);
        
        captainBoy = [SKSpriteNode spriteNodeWithImageNamed:@"CaptainBoy.png"];
        captainBoy.position = CGPointMake(screenSize.width*1.2, screenSize.height*.2);
        
        package = [SKSpriteNode spriteNodeWithImageNamed:@"Package.png"];
        package.position = CGPointMake(screenSize.width*1.2, screenSize.height*1.2);

        [self addChild:correctButton];
        [self addChild:incorrectButton];
        
        //set boat initial position
        for (SKNode *boat in boats)
        {
            [self addChild:boat];
            boat.position = CGPointMake(screenSize.width *1.2, screenSize.height*.2);
        }
        [self addChild:sun];
        [self addChild: captainBoy];
        [self addChild:question];
        correctAnswers = 0;
        questionDisplayed = 0;
        [self addShip];
        [self boatsIn];
        [self hideButtons];
        
    }
    
    return self;
}

-(void) moveShipDropPackage
{
    [airplane runAction:[SKAction moveTo:CGPointMake(captainBoy.position.x+40, screenSize.height*.75) duration:2]];
    [package runAction:[SKAction moveTo:CGPointMake(captainBoy.position.x+60, airplane.position.y-60) duration:2] completion:^{
        [package runAction:[SKAction moveTo:CGPointMake(captainBoy.position.x+60, screenSize.height*.2-40) duration:2] completion:^{
            [self boatsLeave];
        }];
    }];
    
    
    
}
-(void)boatsIn
{
    /*
     * boats in from side
     */
    captainsBoat = arc4random_uniform(boats.count);
    double currentWidth = screenSize.width*.3;
    double currentHeight = screenSize.height*.2;
    double dw = screenSize.width*.8/boats.count;
    for (int i = 0; i < boats.count; i++)
    {
        SKSpriteNode *boat = boats[i];
        if(i == captainsBoat)
            [captainBoy runAction:[SKAction moveTo:CGPointMake(currentWidth-40, currentHeight) duration:5]];
        [boat runAction:[SKAction moveTo:CGPointMake(currentWidth, currentHeight) duration:5] completion:^{
            [self askQuestion];
            [self updateButtons];
            [self displayButtons];}];
        currentWidth += dw;
    }
}


-(void)boatsLeave
{
    double dw = screenSize.width*.5/boats.count;
    double width = -dw*boats.count;
    for (int i = 0; i < boats.count; i++){
        SKSpriteNode *boat = boats[i];
        if(i == captainsBoat){
            [captainBoy runAction:[SKAction moveTo:CGPointMake(width-40, screenSize.height*.2) duration:5]];
            [package runAction:[SKAction moveTo:CGPointMake(width+20, screenSize.height*.2-40) duration:5]];
        }
        [boat runAction:[SKAction moveTo:CGPointMake(width, screenSize.height*.2) duration:5] completion:^{[self moveToNextScene];}];
        width += dw;
    }
}

-(void)displayButtons
{
    correctButton.hidden = NO;
    incorrectButton.hidden = NO;
}

-(void)hideButtons
{
    correctButton.hidden = YES;
    incorrectButton.hidden = YES;
}

-(void)updateButtons
{
    
    correctButton.text = [NSString stringWithFormat:@"%@", shipColor[captainsBoat]];
    incorrectButton.text = [NSString stringWithFormat:@"Not %@", shipColor[captainsBoat]];
}
-(void)askQuestion
{
    /*
     Choose question to be displayed
     */
    //  question.hidden = YES;
    switch (questionDisplayed) {
        case 0:
            question.text = @"What color ship is the captain on?";
            break;
        case 1:
            question.text = @"Are you sure? What color is the ship?";
            break;
        case 2:
            question.text = [NSString stringWithFormat:@"Can you say %@?", shipColor[captainsBoat]];
            break;
        default:
            question.text = [NSString stringWithFormat:@"%i", questionDisplayed];
            break;
    }
    question.hidden = NO;
}

-(void)moveToNextScene
{
    // Move to next scene
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    FifthLevel *scene = [FifthLevel sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition: reveal];
}

-(void)addShip
{
    airplane = [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
    [airplane setScale:0.5];
    airplane.position = CGPointMake(200, [[UIScreen mainScreen] bounds].size.height*0.75);
    airplane.physicsBody = [SKPhysicsBody bodyWithTexture:airplane.texture size:airplane.texture.size];
    airplane.physicsBody.dynamic = YES;
    airplane.physicsBody.allowsRotation = NO;
    //airplane.physicsBody.affectedByGravity = YES;
    self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 );
    package.position = CGPointMake(airplane.position.x+20, airplane.position.y-60);
    [self addChild: airplane ];
    [self addChild: package];
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
    
    if([node.name isEqualToString:@"correctButton"]){
        [self moveShipDropPackage];
    }
    else if ([node.name isEqualToString:@"incorrectButton"]){
        questionDisplayed++;
        if (questionDisplayed == 3) {
            questionDisplayed = 0;
        }
        [self askQuestion];
    }
}

@end
