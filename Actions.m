//
//  Actions.m
//  ASD_Game
//
//  Created by Hasini Yatawatte on 2/4/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actions.h"

@implementation Actions

+(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval  {
    SKAction* action = [SKAction moveByX:-width*1 y:0 duration: timeInterval* width*2];
    return action;
}

//- (void)moveImgContinuously:(NSString*) skNodeName:(NSTimeInterval)duration
//{
//    
//    __block SKAction* moveForever;
//    __block SKSpriteNode* image;
//    
//    
//    [self enumerateChildNodesWithName:(skNodeName) usingBlock: ^(SKNode *node, BOOL *stop)
//     {
//         
//         image = (SKSpriteNode *)node;
//         SKAction* moveImg = [self moveAction:image.size.width: duration];
//         SKAction* resetImg = [self moveAction:-image.size.width: 0.0];
//         moveForever = [SKAction repeatActionForever:[SKAction sequence:@[moveImg,resetImg]]];
//         
//         
//       //  if( !image.hasActions){
//             [image runAction: moveForever];
//         //}
//     }];
//    
//}


-(void)levelComplete{
    
//    //make a label that is invisible
//    SKLabelNode *flashLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    flashLabel.position = CGPointMake(screenWidth/2, screenHeight/2);
//    flashLabel.fontSize = 30;
//    flashLabel.fontColor = [SKColor blueColor];
//    flashLabel.text = @"Level ! Completed !!";
//    flashLabel.alpha =0;
//    flashLabel.zPosition = 100;
//    [self addChild:flashLabel];
//    //make an animation sequence to flash in and out the label
//    SKAction *flashAction = [SKAction sequence:@[
//                                                 [SKAction fadeInWithDuration:3],
//                                                 [SKAction waitForDuration:0.05],
//                                                 [SKAction fadeOutWithDuration:3]
//                                                 ]];
//    // run the sequence then delete the label
//    [flashLabel runAction:flashAction completion:^{[flashLabel removeFromParent];}];
//    
//    NSString * retrymessage;
//    retrymessage = @"Go to Level 2";
//    SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    retryButton.text = retrymessage;
//    retryButton.fontColor = [SKColor blueColor];
//    retryButton.color = [SKColor yellowColor];
//    retryButton.position = CGPointMake(self.size.width/2, screenHeight/2-100);
//    retryButton.name = @"level2";
//    [self addChild:retryButton];
//    

    
}

@end