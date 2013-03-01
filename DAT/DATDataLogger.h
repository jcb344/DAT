//
//  DATDataLogger.h
//  DAT
//
//  Created by Jacob  Balthazor on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CoreAnimation.h>

@interface DATDataLogger : NSObject{
    
    NSMutableArray *calibrationData;
    NSMutableDictionary *currentCalibration;
    NSMutableArray *currentCalibrationData;
    
    int currentTheta;
    CGPoint currentPoint;
    float startTime;
    BOOL isThetaData;
    BOOL timming;
    // Run
    
    NSMutableDictionary *gameData;
    NSMutableDictionary *currentGame;
    NSMutableArray *currentGameData;
    
    float currentTargetOnScreenTime;
    float currentAngleOfXVPlus;
    float currentlocationOfTargetInDegrees;
    int currentTimeBetweenCueAndTarget;
    float currentInformationOfTheCue;
    int currentReactionTime;
    int currentLevel;
    float distanceFromProbe;
    BOOL shouldPressProbe;
}

@property (assign) float currentTargetOnScreenTime;
@property (assign) float currentAngleOfXVPlus;
@property (assign) float currentlocationOfTargetInDegrees;
@property (assign) int   currentTimeBetweenCueAndTarget;
@property (assign) float currentInformationOfTheCue;
@property (assign) int   currentReleaseReactionTime;
@property (assign) int   currentReleaseReactionTimeGoal;
@property (assign) int   currentReactionTime;
@property (assign) float distanceFromProbe;
@property (assign) BOOL  shouldPressProbe;

-(NSMutableArray*)gameData;

-(void)startGameSessionwithName:(NSString*)name;
-(void)startLogGameSessionData;
-(void)logGameSessionDataCorrect:(BOOL)correct;
-(void)endGameSessionWithLevel:(int)l;

-(void)startCalibrationSessionwithName:(NSString*)name;
-(void)calibrationStartTimerWithTheta:(int)theta;
-(void)calibrationStartTimerWithPoint:(CGPoint)point;
-(void)calibrationStopTimer;
-(void)endCalibrationSession;

-(void)printGameData;
-(void)logCalibrationData;
-(void)logGameSessionReleaseTime;

-(int)loadPreviousData:(NSMutableArray*)data;

-(NSString*)dataFilePath;
-(void)saveState;
@end
