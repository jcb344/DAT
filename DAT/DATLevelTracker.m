//
//  DATLevelTracker.m
//  DAT
//
//  Created by Jacob  Balthazor on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATLevelTracker.h"

@implementation DATLevelTracker



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

    }
    return self;
}

-(void)simpleSetLevel:(int)l{
    level = l;
}

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
