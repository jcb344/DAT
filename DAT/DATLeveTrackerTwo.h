//
//  DATLeveTrackerTwo.h
//  DAT
//
//  Created by Jacob  Balthazor on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DATLeveTrackerTwo : NSObject {
    
    int heatSize;
    float goalRT;
    float rtMargin;
    float levelDegreeSteps;
    float precentCorrToProg;
    int numberUpIfCorrect;
    int numberDownIfFalse;
    
    int level;
    
    int heatNumber;
    int heatResults[20];
    float heatResultsRT[20];    
    
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
    
    float  percentToLevelDown;
    float  percentToLevelUp;
    int    numberOfLevels;
    
    float  simpleCueTime;
    int    simpleWaitToCueTime;
    int    simpleCueToProbeTime;
    
    UINavigationController *navigationController;
}

@property (assign) float RTChange;
@property (assign) float goalRT;
@property (assign) float rtMargin;
@property (assign) float levelDegreeSteps;
@property (assign) float percentToLevelUp;
@property (assign) float percentToLevelDown;
@property (assign) int numberUpIfCorrect;
@property (assign) int numberDownIfFalse;
@property (assign) int heatSize;

//Training
-(void)trainingNextMatch;
-(void)trainingReSeed;

-(void)trainingReSeed;
-(float)trainingQueSize;
-(float)trainingStartAngle;
-(float)trainingEndAngle;
-(int)trainingCurrentTheta;

-(void)trainingLogRoundResult:(BOOL)r withRT:(float)rt;

-(void)setnavigationController:(UINavigationController*)nc;

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
