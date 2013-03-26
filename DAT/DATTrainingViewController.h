//
//  DATTrainingViewController.h
//  DAT
//
//  Created by Jacob  Balthazor on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DATQue.h"
#import "DATLeveTrackerTwo.h"
#import "AudioController.h"
#import "DATDataLogger.h"

@interface DATTrainingViewController : UIViewController <UIAlertViewDelegate>{
    
    DATDataLogger *dataLogger;
    DATLeveTrackerTwo *leveL;
    DATQue *que;
    AudioController *sound;
    
    NSTimer *delayTimer;
    int numberOfTrialsToGo;
    BOOL homeShouldBeHeld;
    
    BOOL inSession;
    BOOL soundState;
    BOOL goNoGoTest;
    BOOL startTimerWhenHomePressed;
    
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *leftHomeButton;
    IBOutlet UIButton *ButtonToPress;
    IBOutlet UIButton *innerButton;
    IBOutlet UIView *buttonHolder;
    
    IBOutlet UIButton *backgroundButton;
    IBOutlet UIButton *startStopButton;
    IBOutlet UIButton *backButton;
    
    IBOutlet UILabel *TrialsLabel;
    IBOutlet UILabel *levelLabel;
    IBOutlet UILabel *touchHomePromt;
    
    IBOutlet UILabel *RTGoalLabel;
    IBOutlet UILabel *lastRectionTime;
    IBOutlet UIView *goalIndicator;
    IBOutlet UIView *goalGauge;
    
    UIImage *goImage;
    UIImage *noGoImage;
    
    BOOL homeBeingPressed;
    
    float  simpleCueTime;
    int    simpleWaitToCueTime;
    int    simpleCueToProbeTime;
    
    int    radius;
    float  pi;
    int    centerX;
    int    centerY;
    int    buttonWidth;
    int    buttonHeight;
    int    activeButtonWidth;
    int    activeButtonHeight;
    
    int goalRT;
    
    BOOL homePressed;
    BOOL LeftHomePressed;
}

-(void)displayButtonAtRandomLocation;
-(void)updateTrialsLabel;
-(void)showFlash;
-(void)hideFlash;
-(void)buttonTimeOut;

-(IBAction)homeTouched:(id)sender;
-(IBAction)homeReleased:(id)sender;
-(IBAction)startTesting:(id)sender;
-(IBAction)buttonPressed:(id)sender withEvent:(UIEvent *)event;


-(IBAction)reSeed:(id)sender;
-(IBAction)back:(id)sender;

-(void)updateInicator;
-(void)saveData;

-(void)setBackToGood;
-(void)setBackToBad;
-(void)setBack;


@end
