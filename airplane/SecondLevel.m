//
//  SecondLevel.m
//  airplane
//
//  Created by Hasini Yatawatte on 1/26/15.
//  Maintained by Charles Shinaver since 3/30/15
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import "SecondLevel.h"
#import "ThirdLevel.h"

@implementation SecondLevel {
    int birdsDisplayed;
    int questionDisplayed;
    int correctAnswers;
    NSArray *birds;
    SKLabelNode *correctButton;
    SKLabelNode *incorrectButton;
    SKLabelNode *question;
    CGSize screenSize;
}
/*
 * TODO 3 repetitions of birds coming in, random number each time
 * TODO Must get 3 in a row correct to move to next scene. Max of 5 tries
 * TODO Birds fly away after 3 questions asked
*/

-(id)initWithSize:(CGSize)size {
    
    
    if (self = [super initWithSize:size]) {
        
        // Set screenSize for ease
        screenSize = [[UIScreen mainScreen] bounds].size;

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

        // Create button
        correctButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        correctButton.name = @"correctButton";
        correctButton.fontSize = 40;
        correctButton.fontColor = [SKColor blueColor];
        correctButton.position = CGPointMake(screenSize.width * 1./4, screenSize.height * 1./25);
        correctButton.hidden = YES;

        incorrectButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        incorrectButton.name = @"incorrectButton";
        incorrectButton.fontSize = 40;
        incorrectButton.fontColor = [SKColor blueColor];
        incorrectButton.position = CGPointMake(screenSize.width * 3./4, screenSize.height * 1./25);
        incorrectButton.hidden = YES;
        
        // Create question
        question = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        question.fontSize = 50;
        question.position = CGPointMake(screenSize.width * .5, screenSize.height * 1./10);
        question.name = @"numberOfBirdsQuestion";
        question.hidden = YES;

        [self initalizingScrollingBackground];
        [self addChild:question];
        [self addChild:correctButton];
        [self addChild:incorrectButton];
        for (SKNode *bird in birds)
        {
            [self addChild:bird];
            // Set bird initial position
            bird.position = CGPointMake(screenSize.width*1.2, screenSize.height*1.2);
        }
        [self addShip];
        [self birdsFlyIn];
        
        // Set birds displayed
        birdsDisplayed = 0;
        // Set question displayed
        questionDisplayed = 0;
        correctAnswers = 0;
    }
    
    return self;
}

-(void)updateButtonsToMatchNumberOfBirds
{
    correctButton.text = [NSString stringWithFormat:@"%i birds", birdsDisplayed];
    incorrectButton.text = [NSString stringWithFormat:@"Not %i birds", birdsDisplayed];
}

-(void)displayButtons
{
    /*
     * Displays buttons
    */
    correctButton.hidden = NO;
    incorrectButton.hidden = NO;
}

-(void)hideButtons
{
    /*
     * Hides buttons
    */
    correctButton.hidden = YES;
    incorrectButton.hidden = YES;
}

-(void)birdsFlyIn
{
    /*
     * Birds fly in from side
     * The number of birds will be random. 
     * As
    */

    // Set bird positions
    int numBirds = arc4random_uniform(birds.count + 1);
    if (!numBirds)
        numBirds = 1;
    double maxHeight = screenSize.height*0.85;
    double dh = maxHeight * 1/8;
    double currentHeight = maxHeight;
    double minWidth = screenSize.width * .5;
    double dw = minWidth / numBirds;
    double currentWidth = minWidth;
    
    for (int i = 0; i < numBirds; i++)
    {
        SKSpriteNode *bird = birds[i];
        [bird runAction:[SKAction moveTo:CGPointMake(currentWidth, currentHeight) duration:5] completion:^{
            birdsDisplayed++;
            if (birdsDisplayed == numBirds)
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
    
    int numBirds = birdsDisplayed;

    // Set bird positions
    for (int i = 0; i < numBirds; i++)
    {
        SKSpriteNode *bird = birds[i];
        [bird runAction:[SKAction moveTo:CGPointMake(screenSize.width*1.2, screenSize.height*1.2) duration:2] completion:^{
            birdsDisplayed--;
            if (birdsDisplayed == 0)
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
    

    int numBirds = birdsDisplayed;

    // Set bird positions
    for (int i = 0; i < numBirds; i++)
    {
        SKSpriteNode *bird = birds[i];
        [bird runAction:[SKAction moveTo:CGPointMake(screenSize.width*1.2, screenSize.height*1.2) duration:2] completion:^{
            birdsDisplayed--;
            if (birdsDisplayed == 0)
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
    
    // Set text of question
    switch (questionDisplayed) {
        case 0:
            // Create text label
            question.text = @"How many birds are in the air?";
            question.hidden = NO;
            break;
        case 1:
            question.text = @"Are you sure? How many birds are in the air?";
            question.hidden = NO;
            break;
        case 2:
            question.text = [NSString stringWithFormat:@"Can you say %i", birdsDisplayed];
            question.hidden = NO;
            break;
        case 3:
            [self moveToNextScene];
            break;
        default:
            question.text = @"How many birds are in the air?";
    }
    
    // Set text of answers
    [self updateButtonsToMatchNumberOfBirds];
    [self displayButtons];
    
    // Display question and increment
    questionDisplayed++;
}

-(void)hideQuestion
{
}

-(void)moveToNextScene
{
    // Move to next scene
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SecondLevel * scene = [ThirdLevel sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition: reveal];
}


-(void)addShip
{

    self.ship= [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
    [self.ship setScale:0.5];
    self.ship.position = CGPointMake(200, [[UIScreen mainScreen] bounds].size.height*0.75);
    
    
    self.ship.physicsBody = [SKPhysicsBody bodyWithTexture:self.ship.texture size:self.ship.texture.size];;
    self.ship.physicsBody.dynamic = YES;
    self.ship.physicsBody.allowsRotation = NO;
    // self.ship.physicsBody.affectedByGravity = YES
    [self addChild:self.ship ];
    
    self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 );
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}



-(void)initalizingScrollingBackground
{
    
    
    // Create ground
    
    seaTexture = [SKTexture textureWithImageNamed:@"Sea.png"];
    self.sea = [SKSpriteNode spriteNodeWithTexture:seaTexture];
    seaTexture.filteringMode = SKTextureFilteringNearest;
    
    // Create sea texture
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
    
    if ([node.name isEqualToString:@"correctButton"])
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
            [self hideButtons];
            [self birdsFlyOutAndFlyBackIn];
        }
    }
    else if ([node.name isEqualToString:@"incorrectButton"])
    {
        [self askQuestion];
    }
}








@end
