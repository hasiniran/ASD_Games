//
//  Actions.h
//  ASD_Game
//
//  Created by Hasini Yatawatte on 2/4/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//

#ifndef ASD_Game_Actions_h
#define ASD_Game_Actions_h

#import <SpriteKit/SpriteKit.h>

@interface Actions : SKScene{}

//-(void)moveImgContinuously:(NSString*)skNodeName:(NSTimeInterval) duration;
+(SKAction*)moveAction: (CGFloat)width :(NSTimeInterval) timeInterval ;


@end

#endif
