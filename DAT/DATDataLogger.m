//
//  DATDataLogger.m
//  DAT
//
//  Created by Jacob  Balthazor on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATDataLogger.h"

@implementation DATDataLogger

@synthesize currentAngleOfXVPlus;
@synthesize currentInformationOfTheCue;
@synthesize currentlocationOfTargetInDegrees;
@synthesize currentTargetOnScreenTime;
@synthesize currentTimeBetweenCueAndTarget;
@synthesize currentReactionTime;
@synthesize currentReleaseReactionTime;
@synthesize currentReleaseReactionTimeGoal;
@synthesize distanceFromProbe;
@synthesize shouldPressProbe;
@synthesize currentCueProbeTime;

-(id)init {
    if (self = [super init]) {
        currentGameData = Nil;
        /*
        NSString *filePath = [self dataFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSLog(@"Loading saved data file");
            currentGameData = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        }
        else{
            NSLog(@"NO Game Data");
        }
         */
    }
    return self;
}

-(int)loadPreviousData:(NSMutableArray*)data{
    int lev = 1;
    currentGameData = data;
    if (currentGameData != Nil) {
        lev = [[[currentGameData lastObject] objectForKey:@"level"] intValue];
    }
    return lev;
}

-(NSMutableArray*)gameData{
    return currentGameData;
}

-(void)startGameSessionwithName:(NSString*)name {
    if (currentGameData == Nil) {
        NSLog(@"NO previous Data file found. Creating New data set");
        //int date = [[NSDate date]timeIntervalSince1970];
        currentGameData = [[NSMutableArray alloc] init];
        //gameData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name,@"name",[NSNumber numberWithInt:date],@"date", nil];
        timming = NO;
    }
    else {
        NSLog(@"Data file found. Appending new data to file.");
        //gameData = [currentGameData lastObject];
        //[gameData retain];
        [currentGameData removeLastObject];
    }
}

-(void)startLogGameSessionData{
    startTime = CACurrentMediaTime();
    timming = YES;
}

-(void)logGameSessionReleaseTime{
    currentReleaseReactionTime = (int)((CACurrentMediaTime() - startTime)*1000.f);
}

-(void)logGameSessionDataCorrect:(BOOL)correct {
    float stopTime = CACurrentMediaTime();
    timming = NO;
    currentReactionTime = (int)((stopTime - startTime)*1000.f);
    
    //NSLog(@"Reaction Time: %.1f ms",reactionTime);
    
    currentGame = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                   [NSNumber numberWithInt:[[NSDate date]timeIntervalSince1970]],@"timeStamp",
                   [NSNumber numberWithFloat:currentAngleOfXVPlus],@"angleOfXVPlus",
                   [NSNumber numberWithFloat:(1-currentInformationOfTheCue)],@"informationOfTheCue",
                   [NSNumber numberWithFloat:currentlocationOfTargetInDegrees],@"locationOfTargetInDegrees",
                   [NSNumber numberWithFloat:currentTargetOnScreenTime],@"targetOnScreenTime",
                   [NSNumber numberWithInt:currentReactionTime],@"reactionTime",
                   [NSNumber numberWithInt:currentReleaseReactionTime],@"releaseReactionTime",
                   [NSNumber numberWithInt:currentReleaseReactionTimeGoal],@"currentReleaseReactionTimeGoal",
                   [NSNumber numberWithBool:correct],@"sucsess",
                   [NSNumber numberWithFloat:distanceFromProbe],@"distanceFromProbe",
                   [NSNumber numberWithFloat:currentCueProbeTime],@"cueProbeTime",
                   [NSNumber numberWithBool:shouldPressProbe],@"shouldPressProbe",
                   nil];
    
    [currentGameData addObject:currentGame];
    //[self saveState];
    // release currentGameData
}
-(void)endGameSessionWithLevel:(int)l{
    NSLog(@"Game Session Ended");
    //[gameData setObject:[NSNumber numberWithInt:l] forKey:@"level"];
    //[currentGameData addObject:gameData];
}

-(void)startCalibrationSessionwithName:(NSString*)name {
    
    int date = [[NSDate date]timeIntervalSince1970];
    currentCalibrationData = [[NSMutableArray alloc] init];
    currentCalibration = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name,@"name",[NSNumber numberWithInt:date],@"date", nil];
}

-(void)calibrationStartTimerWithTheta:(int)theta {
    currentTheta = theta;
    startTime = CACurrentMediaTime();
    isThetaData = YES;
}

-(void)calibrationStartTimerWithPoint:(CGPoint)point {
    currentPoint = point;
    startTime = CACurrentMediaTime();
    isThetaData = NO;
}

-(void)calibrationStopTimer{
    
    float stopTime = CACurrentMediaTime();
    float reactionTime = (stopTime-startTime)*1000;
    //NSLog(@"Reaction Time: %.1f ms",reactionTime);
    NSArray *data;
    
    if (isThetaData) {
        // index 0: Theta
        // index 1: Time in miliseconds
        data = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:currentTheta],[NSNumber numberWithFloat:reactionTime], nil];
    }
    else {
        // index 0: x
        // index 1: y
        // index 2: Time in miliseconds
        data = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:currentPoint.x],[NSNumber numberWithFloat:currentPoint.y],[NSNumber numberWithFloat:reactionTime], nil];
    }
    [currentCalibrationData addObject:data];
}

-(void)endCalibrationSession{
    
    
}

-(void)printGameData {
    NSLog(@"%@",[currentGame objectForKey:@"name"]);
    NSLog(@"%@",[[NSDate dateWithTimeIntervalSince1970:[[currentGame objectForKey:@"date"] intValue]] description]);
    
    for (int i = 0; i<[currentGameData count]; i++) {
        
        NSLog(@"Certainty:%f Location:%d Reaction Time:%d",
              [[[currentGameData objectAtIndex:i] objectForKey:@"informationOfTheCue"] floatValue],
              [[[currentGameData objectAtIndex:i] objectForKey:@"locationOfTargetInDegrees"] intValue],
              [[[currentGameData objectAtIndex:i] objectForKey:@"reactionTime"] intValue]              
              );
        
    }
    
}

-(void)logCalibrationData {
    NSLog(@"%@",[currentCalibration objectForKey:@"name"]);
    NSLog(@"%@",[[NSDate dateWithTimeIntervalSince1970:[[currentCalibration objectForKey:@"date"] intValue]] description]);
    
    for (int i = 0; i<[currentCalibrationData count]; i++) {
        if ([[currentCalibrationData objectAtIndex:i] count] == 2) {
            NSLog(@"Theta:%d deg Reaction Time: %.1f ms",[[[currentCalibrationData objectAtIndex:i] objectAtIndex:0] intValue],[[[currentCalibrationData objectAtIndex:i] objectAtIndex:1] floatValue]);
        }
        else if ([[currentCalibrationData objectAtIndex:i] count] == 3) {
            NSLog(@"X:%3.f Y:%3.f Reaction Time: %.1f ms",[[[currentCalibrationData objectAtIndex:i] objectAtIndex:0] floatValue],[[[currentCalibrationData objectAtIndex:i] objectAtIndex:1] floatValue],[[[currentCalibrationData objectAtIndex:i] objectAtIndex:2] floatValue]);
        }
        
    }
}

-(void)saveState
{
    if ([calibrationData count] > 1) {
        NSLog(@"Saving data");   
        [currentGameData writeToFile:[self dataFilePath] atomically:NO];
    }
}

-(NSString*)dataFilePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *pathFin = [documentDirectory stringByAppendingPathComponent:@"data.plist"];
    return pathFin;
}

@end





