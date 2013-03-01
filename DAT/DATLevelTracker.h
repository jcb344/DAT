//
//  DATLevelTracker.h
//  DAT
//
//  Created by Jacob  Balthazor on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Constants.h"



@interface DATLevelTracker : NSObject {
    
    int level;
    int heatNumber;
    
    int heatResults[20];
    
    int currentTheta;
    float currentQueAcuracy;
    float currentFlashTime;
    float currentWaitTime;
    
    float startAngle;
    float endAngle;
    float informationOfTheCue;
    
    int    radius;
    float  pi;
    int    centerX;
    int    centerY;
    int    buttonWidth;
    int    buttonHeight;
    
    int    heatSize;
    float  percentToLevelDown;
    float  percentToLevelUp;
    int    numberOfLevels;
    
    float  simpleCueTime;
    int    simpleWaitToCueTime;
    int    simpleCueToProbeTime;
}

//Simple
-(int)simpleLevelNumber;
-(int)simpleNextLevel;
-(void)simpleSetLevel:(int)l;

-(void)simpleReSeed;
-(float)simpleQueSize;
-(float)simpleStartAngle;
-(float)simpleEndAngle;
-(int)simpleCurrentTheta;

-(void)logRoundResult:(BOOL)r;
-(void)startNewRound;

-(void)resetHeat;

-(int)currentTheta;
-(float)currentQueAcuracy;
-(float)currentFlashTime;
-(float)currentWaitTime;

-(int)level;
-(void)setLevel:(int)l;

@end
