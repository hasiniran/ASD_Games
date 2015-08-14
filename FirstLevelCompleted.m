//
//  FirstLevelCompleted.m
//  airplane
//
//  Created by Hasini Yatawatte on 1/26/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.

#import "FirstLevelCompleted.h"

@implementation FirstLevelCompleted


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // 1
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        // 2
        NSString * message;
        message = @"Level 1 - Completed";
        // 3
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        //4
        NSString * retrymessage;
        retrymessage = @"Go to Level 2";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blackColor];
        retryButton.position = CGPointMake(self.size.width/2, 50);
        retryButton.name = @"retry";
        [self addChild:retryButton];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location]; //1
    
    if ([node.name isEqualToString:@"retry"]) { //2
        
        //3
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SecondLevel * scene = [SecondLevel sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }
}



@end
