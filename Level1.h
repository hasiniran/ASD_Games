//
//  GameScene.h
//  Autism_train
//

//  Copyright (c) 2015 Matthew Perez. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//LEVEL1
@interface GameScene : SKScene{
    SKTexture *groundTexture;
    SKAction *moveGroundSpritesForever;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
}

@property (nonatomic, strong) SKSpriteNode *runway;

//-(SKAction*)moveBgContinuously;
//-(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval ;

@end
