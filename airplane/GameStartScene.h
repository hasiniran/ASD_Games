//
//  GameStartScene.h
//  airplane
//
//  Created by Hasini Yatawatte on 1/25/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameStartScene : SKScene{
    SKAction *actionMoveDown;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    SKAction *actionMoveRight;
    SKTexture* groundTexture;
    SKAction* moveGroundSpritesForever;
    
}

@end

