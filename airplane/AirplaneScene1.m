//
//  MyScene.m
//  airplane
//
//  Created by Hasini Yatawatte on 10/22/14.
//  Copyright (c) 2014 Hasini Yatawatte. All rights reserved.
//

#import "AirplaneScene1.h"
@implementation AirplaneScene1
{
    int instructions;
    NSTimer *instructionTimer;
    SKLabelNode *instructionText, *skip;
    AVSpeechUtterance *instruction1;
    SKSpriteNode *airplane;
}

-(id)initWithSize:(CGSize)size {
    
    instructions = 0;
    //initialize synthesizer
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    
    if (self = [super initWithSize:size]) {
        screenHeight = self.size.height;
        screenWidth = self.size.width;
        NSLog(@"width:%f, height:%f", screenWidth, screenHeight);

       [self initalizingScrollingBackground];
       [self addShip];

        skip = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP"; //Set the button text
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [self addChild:skip]; //add node to screen

        
        // add the Go button
        //should be removed after embedding voice commands
        SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        go.text = @"Go"; //Set the button text
        go.name = @"Go";
        go.fontSize = 40;
        go.fontColor = [SKColor yellowColor];
        go.position = CGPointMake(screenWidth/2,100);
        go.zPosition = 50;
        [self addChild: go];
        
        //instructions
        instructionText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        instructionText.name = @"instructionText";
        instructionText.fontSize = 40;
        instructionText.fontColor = [SKColor redColor];
        instructionText.position = CGPointMake(500,500);
        instructionText.zPosition = 50;
        [self addChild:instructionText];
        [self timer];
        self.physicsWorld.gravity = CGVectorMake( 0.0, -0.5 );
     /*
        actionMoveUp = [SKAction moveByX:0 y:100 duration:.2];
        actionMoveDown = [SKAction moveByX:0 y:-30 duration:.2];
        actionMoveRight = [SKAction moveByX:30 y:0  duration:.2];
*/
    }
    return self;
}

-(void)timer {
    instructionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(giveInstructions) userInfo:nil repeats:YES];
}

-(void)giveInstructions { //keep repeating different instructions
    //instructions start at 1 to delay for game selection message
    if (instructions == 1) { //level declaration
        instructionText.text = @"Level 1";
        instruction1 = [[AVSpeechUtterance alloc] initWithString:instructionText.text];
        instruction1.rate = AVSpeechUtteranceMinimumSpeechRate;
        [self.synthesizer speakUtterance:instruction1];
    }
    else if (instructions == 3) { //initial instructions
        instructionText.text = @"Tell the plane to go!"; //place new text
        instruction1 = [[AVSpeechUtterance alloc] initWithString:instructionText.text];
        instruction1.rate = AVSpeechUtteranceMinimumSpeechRate;
        [self.synthesizer speakUtterance:instruction1];
    }
    else if (instructions == 11) { //wait 10 secs -- follow up 1
        instructionText.text = @"Help the plane move by saying go!";
        instruction1 = [[AVSpeechUtterance alloc] initWithString:instructionText.text];
        instruction1.rate = AVSpeechUtteranceMinimumSpeechRate;
        [self.synthesizer speakUtterance:instruction1];
    }
    else if (instructions == 21) { //wait 10 secs -- follow up 2
        instructionText.text = @"Say go";
        instruction1 = [[AVSpeechUtterance alloc] initWithString:instructionText.text];
        instruction1.rate = AVSpeechUtteranceMinimumSpeechRate;
        [self.synthesizer speakUtterance:instruction1];
    }
    else if (instructions > 30) { //wait another 10 secs -- restart instructions
        instructions = 1;
    }
    instructions++;
}

-(void)addShip
{
    airplane = [SKSpriteNode spriteNodeWithImageNamed:@"AirplaneCartoon.png"];
    [airplane setScale:0.5];
    airplane.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    airplane.position = CGPointMake(airplane.size.width/2, 100);
    airplane.physicsBody.dynamic = YES;
    airplane.physicsBody.allowsRotation = NO;
    airplane.physicsBody.affectedByGravity = YES;
    [self addChild: airplane];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
 //   UITouch *touch = ;
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    //stop repeating instructions
    [instructionTimer invalidate];
    instructionTimer = nil;
    
    if ([node.name isEqualToString:@"level2"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SecondLevel * scene = [SecondLevel sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }else if ([node.name isEqualToString:@"Go"]) {
            if(airplane.position.y < screenHeight*.75){
                [airplane.physicsBody applyImpulse:CGVectorMake(1, 5)];
            }else{
                [airplane setPosition:CGPointMake(airplane.position.x, screenHeight*0.75)];
                airplane.physicsBody.dynamic = NO;
            }
             [self moveBgContinuously];
        
    }
    if ([node.name isEqualToString:@"Skip"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SecondLevel *scene = [SecondLevel sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    
}



-(void)initalizingScrollingBackground
{
    //create the ground/runway
    groundTexture = [SKTexture textureWithImageNamed:@"Runway.png"];
    groundTexture.filteringMode = SKTextureFilteringNearest;
    self.runway = [SKSpriteNode spriteNodeWithTexture:groundTexture];
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"runway";
        [self addChild:bg];
    }
    
    //move ground
    /*
    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration: 0.02 * groundTexture.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
*/
    // Create skyline
    SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"Sky.png"];
    skylineTexture.filteringMode = SKTextureFilteringNearest;
    for (int i = 0; i < 3; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
        bg.position = CGPointMake(i * bg.size.width,groundTexture.size.height);
      //  bg.zPosition = -200;
        bg.anchorPoint = CGPointZero;
        bg.name = @"sky";
        [self addChild:bg];
    }
    
/*
//    for( int i = 0; i< 2 + self.frame.size.width / ( skylineTexture.size.width * 2 )  ; ++i ) {
//        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
//        [sprite setScale:1.5];
//        sprite.zPosition = -20;
//        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2 + groundTexture.size.height );
//     //   [sprite runAction:moveSkySpritesForever];
//        [self addChild:sprite];
//    }
//    SKTexture* skylineTexture = [SKTexture textureWithImageNamed:@"Sky.png"];
//    skylineTexture.filteringMode = SKTextureFilteringNearest;
//    
//    for( int i = 0; i < 2 ; ++i ) {
//        SKSpriteNode* groundSprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
//        SKSpriteNode* skySprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
//        //[sprite setScale:2.0];
//        //[sprite setXScale:3.0];
//        //[sprite setYScale:1.5];
//        groundSprite.position = CGPointMake(i * groundSprite.size.width, 100);
//        [self addChild:sprite];
//    }
//    for( int i = 0; i < 2 ; ++i ) {
//        //[sprite setScale:2.0];
//        sprite.zPosition = -20;
//        sprite.position = CGPointMake(i * sprite.size.width,  100 + groundTexture.size.height);
//        [self addChild:sprite];
//    }
// */
    // Create ground physics container
    
    SKNode* dummy = [SKNode node];

    
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(screenWidth, 100) center:CGPointMake(screenWidth/2, 100/2)];
    dummy.position = CGPointMake(0, 0);
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
   // [self moveBg];
}

-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval  {
    SKAction* action = [SKAction moveByX:-width*1 y:0 duration: timeInterval* width*2];
    return action;
}


-(SKAction*)moveBgContinuously
{
    __block SKAction* moveRunwayForever;
    __block SKAction* moveSkyForever;
    __block SKSpriteNode *sky;
    __block SKSpriteNode *runway;
    SKAction* moveBackground;
    
    //move the runway
    [self enumerateChildNodesWithName:@"runway" usingBlock: ^(SKNode *node, BOOL *stop)
    {
        runway = (SKSpriteNode *)node;
        SKAction* moveRunway = [self moveAction:runway.size.width: 0.005];
        SKAction* resetRunway = [self moveAction:-runway.size.width: 0.0];
        moveRunwayForever = [SKAction repeatActionForever:[SKAction sequence:@[moveRunway,resetRunway]]];
        if( !runway.hasActions){
            [runway runAction: moveRunwayForever];
        }
    }];

    //move the sky
    [self enumerateChildNodesWithName:@"sky" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         sky = (SKSpriteNode *) node;
         SKAction* moveSky = [self moveAction:sky.size.width*1.0: 0.005];
         SKAction* resetSky = [self moveAction:-sky.size.width: 0.0];
         moveSkyForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSky,resetSky]]];
         
         if( !sky.hasActions){
             [sky runAction: moveSkyForever];
         }
     }];
    return moveBackground;
}

CGFloat clamp(CGFloat min, CGFloat max, CGFloat value) {
    if( value > max ) {
        return max;
    } else if( value < min ) {
        return min;
    } else {
        return value;
    }
}

-(void)levelCompleted:(BOOL)won{
    
    if(won){
        //make a label that is invisible
        SKLabelNode *flashLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        flashLabel.position = CGPointMake(screenWidth/2, screenHeight/2);
        flashLabel.fontSize = 30;
        flashLabel.fontColor = [SKColor blueColor];
        flashLabel.text = @"Level 1 Completed !!";
        flashLabel.alpha =0;
        flashLabel.zPosition = 100;
        [self addChild:flashLabel];
        //make an animation sequence to flash in and out the label
        SKAction *flashAction = [SKAction sequence:@[
                                                     [SKAction fadeInWithDuration:3],
                                                     [SKAction waitForDuration:0.05],
                                                     [SKAction fadeOutWithDuration:3]
                                                     ]];
        // run the sequence then delete the label
        [flashLabel runAction:flashAction completion:^{[flashLabel removeFromParent];}];
        
        NSString * retrymessage;
        retrymessage = @"Go to Level 2";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blueColor];
        retryButton.color = [SKColor yellowColor];
        retryButton.position = CGPointMake(self.size.width/2, screenHeight/2-100);
        retryButton.name = @"level2";
        [self addChild:retryButton];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    self.ship.zRotation = clamp( -1, 0, self.ship.physicsBody.velocity.dy * ( self.ship.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 ) );
    
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    //if plane reaches a certain height, then keep at that height
    if(airplane.physicsBody.velocity.dy != 0 ) {
        if(airplane.position.y >= screenHeight*0.75 ){
            [airplane setPosition:CGPointMake(airplane.position.x, screenHeight*0.75)];
            airplane.physicsBody.dynamic = NO;
            [airplane runAction:[SKAction moveTo:CGPointMake(screenWidth+airplane.size.width/2, screenHeight*.75) duration:4] completion:^{
                [self moveToNextScene];}
             ];
        }
       [self moveBgContinuously];
    }
    //if not moving up then...unknown functionality
    else if(airplane.physicsBody.velocity.dy == 0 && airplane.position.y < screenHeight*0.75)
    {
        [self enumerateChildNodesWithName:@"runway" usingBlock: ^(SKNode *node, BOOL *stop)
         {
             SKSpriteNode * bg = (SKSpriteNode *) node;
             if( bg.hasActions){
               //  [bg removeAllActions];
             }
         }];
        [self enumerateChildNodesWithName:@"sky" usingBlock: ^(SKNode *node, BOOL *stop)
        {
            SKSpriteNode * bg = (SKSpriteNode *) node;
            if( bg.hasActions){
                // [bg removeAllActions];
            }
        }];
    }
}

-(void)moveToNextScene
{
    // Move to next scene
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SecondLevel *scene = [SecondLevel sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition: reveal];
}

@end
