//
//  DATLeveTrackerTwo.m
//  DAT
//
//  Created by Jacob  Balthazor on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATLeveTrackerTwo.h"

@implementation DATLeveTrackerTwo

@synthesize goalRT,rtMargin,levelDegreeSteps,percentToLevelUp,percentToLevelDown,numberUpIfCorrect,numberDownIfFalse,heatSize,RTChange;

-(id)init{
    if (self = [super init]) {
        level = 1;
        [self resetHeat];
        
        radius = 350;
        pi = 3.14159;
        centerX = 384;
        centerY = 502;
        buttonWidth = 80;
        buttonHeight = 80;
        
        heatSize = 3;
        percentToLevelDown = .5f;
        percentToLevelUp = .75f;
        numberOfLevels = 30;
        
        simpleCueTime = .2f;
        simpleWaitToCueTime = 2000;
        simpleCueToProbeTime = 1500;
        
        levelDegreeSteps = .05;
        rtMargin = .1;
        goalRT = 700;
        numberDownIfFalse = 1;
        numberUpIfCorrect = 1;
        
    }
    return self;
}

#pragma mark Training

-(void)trainingNextMatch{
    //[self simpleNextLevel];
}

-(void)trainingLogRoundResult:(BOOL)r withRT:(float)rt{
    
    //NSLog(@"%d %d %d %f %f %f %f",numberUpIfCorrect,numberDownIfFalse,heatSize,goalRT,percentToLevelUp,rtMargin,levelDegreeSteps);
    
    int sum=0;
    heatResults[heatNumber] = r;
    heatResultsRT[heatNumber] = rt;
    heatNumber++;
    if (heatNumber > heatSize-1) {
        float avgRT = 0;
        for (int i = 0; i<heatSize; i++) {
            sum += heatResults[i];
            avgRT += heatResultsRT[i];
        }
        avgRT = avgRT/((float)heatNumber);
        float percentCorrect = ((float)sum)/((float)heatSize);
        if (percentCorrect < percentToLevelDown || (goalRT*(1.f+rtMargin)) < avgRT ) {
            if (level > 1) {
                level -= numberDownIfFalse; // Level Down
            }
            else {
                NSLog(@"Bottemed Out");
                level = 1; // Level Up to new RT
                /*
                goalRT += RTChange;
                [navigationController setGoalRelease:(int)(1000*goalRT)];
                [navigationController saveState];
                int i = [navigationController goalRelease];
                NSLog(@"goal Relase set to:%f",(float)i/1000.f);
                 */
            }
        }
        if (percentCorrect > percentToLevelUp && goalRT/**(1.f-rtMargin))*/ > avgRT) {
            if ((level+1)*levelDegreeSteps > 1.f ) {
                level = 1; // Level Up to new RT
                goalRT -= RTChange;
                [navigationController setGoalRelease:(int)(1000*goalRT)];
                [navigationController saveState];
                int i = [navigationController goalRelease];
                NSLog(@"goal Relase set to:%f",(float)i/1000.f);
            }
            else{
                level += numberUpIfCorrect; // Level Up
            }
        }
        NSLog(@"level:%d avg:%f correct:%f fastRt:%f",level,avgRT,percentCorrect,(goalRT*(1.f-rtMargin)));
        heatNumber = 0;
        [self resetHeat];
    }
}

-(void)trainingReSeed{
    informationOfTheCue = level*levelDegreeSteps;
    
    BOOL isOnLeft = arc4random()%2;
    
    if (isOnLeft) {
        startAngle = pi-(pi*(informationOfTheCue/1.f));
        endAngle = pi+(pi*(informationOfTheCue/1.f));
        currentTheta =  (int)(((((float)(arc4random()%500))/500.f)*informationOfTheCue-informationOfTheCue/2.f)*360)+180;
    }
    else {
        startAngle = -(pi*(informationOfTheCue/1.f));
        endAngle = (pi*(informationOfTheCue/1.f));
        currentTheta =  (int)(((((float)(arc4random()%500))/500.f)*informationOfTheCue-informationOfTheCue/2.f)*360)  ;
    }
    
    if (currentTheta < 0) {
        currentTheta = 360+currentTheta;
    }

}

-(float)trainingQueSize{
    return informationOfTheCue;
}
-(float)trainingStartAngle{
    return startAngle;
}
-(float)trainingEndAngle{
    return endAngle;
}
-(int)trainingCurrentTheta{
    return currentTheta;
}

-(void)simpleSetLevel:(int)l{
    level = l;
}

-(void)setnavigationController:(UINavigationController*)nc{
    navigationController = nc;
}

#pragma mark Simple

-(int)simpleNextLevel{
    level--;
}

-(int)simpleLevelNumber{
    return level;
}

-(int)simpleCurrentTheta{
    return currentTheta;
}

-(void)simpleReSeed{
    int QueSize = arc4random()%4;
    BOOL isOnLeft = arc4random()%2;
    
    switch (QueSize) {
        case 0:
            if (isOnLeft) {
                startAngle = pi-pi/4;
                endAngle = pi+pi/4;
                currentTheta =  (arc4random()%90)-45+180;
            }
            else {
                startAngle = -3.14/4;
                endAngle = 3.14/4;
                currentTheta =  (arc4random()%90)-45;
            }
            informationOfTheCue = .25;
            break;
        case 1:
            
            if (isOnLeft) {
                startAngle = pi-pi/2;
                endAngle = pi+pi/2;
                currentTheta =  (arc4random()%181)-90+180;
            }
            else {
                startAngle = -3.14/2;
                endAngle = 3.14/2;
                currentTheta =  (arc4random()%181)-90;
            }
            informationOfTheCue = .5;
            break;
        case 2:
            startAngle = 0;
            endAngle =  2*pi;
            currentTheta = arc4random()%361;
            informationOfTheCue = 1.f;
            break;
        case 3:
            
            if (isOnLeft) {
                startAngle = pi-pi/32;
                endAngle =  pi+pi/32;
                currentTheta =  180;
            }
            else {
                startAngle = -3.14/32;
                endAngle = 3.14/32;
                currentTheta =  0;
            }
            informationOfTheCue = .125;
            break;
            
        default:
            break;
    }
    if (currentTheta < 0) {
        currentTheta = 360+currentTheta;
    }
}
-(float)simpleQueSize{
    return informationOfTheCue;
}
-(float)simpleStartAngle{
    return startAngle;
}
-(float)simpleEndAngle{
    return endAngle;
}

-(void)resetHeat{
    for (int i = 0; i<heatSize; i++) {
        heatResults[i] = 0;
        heatResultsRT[i] = 0.0;
    }
    
    heatNumber = 0;
}

-(void)logRoundResult:(BOOL)r{
    int sum=0;
    heatResults[heatNumber] = r;
    heatNumber++;
    if (heatNumber > heatSize-1) {
        for (int i = 0; i<heatSize; i++) {
            sum += heatResults[i];
        }
        float percentCorrent = ((float)sum)/((float)heatSize);
        if (percentCorrent < percentToLevelDown) {
            level--;
        }
        if (percentCorrent > percentToLevelUp) {
            level++;
        }
        heatNumber = 0;
        [self resetHeat];
    }
}

-(void)startNewRound{
    currentTheta = arc4random()%361;
    currentFlashTime = .25;
    currentWaitTime = 1.0;
}

-(int)currentTheta{
    return currentTheta;
    //NSLog(@"level%d",level);
}

-(float)currentQueAcuracy{
    if (level <= numberOfLevels) {
        return ((float)level)/((float)numberOfLevels);
    }
    else {
        return 1.f;
    }
}

-(float)currentFlashTime {
    return currentFlashTime;
}

-(float)currentWaitTime{
    return currentWaitTime;
}

-(int)level{
    return level;
}
-(void)setLevel:(int)l{
    level = l;
}

@end
