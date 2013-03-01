//
//  DATSimpleViewControllerViewController.h
//  DAT
//
//  Created by Jacob  Balthazor on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DATDataLogger.h"
#import "DATQue.h"
#import "DATLevelTracker.h"
#import "AudioController.h"

//#import "Constants.h"
@interface DATSimpleViewControllerViewController : UIViewController{
    
    DATDataLogger *dataLogger;
    DATLevelTracker *level;
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
    IBOutlet UIButton *ButtonToPress;
    IBOutlet UIButton *backgroundButton;
    IBOutlet UIButton *startStopButton;
    IBOutlet UIButton *backButton;
    
    IBOutlet UILabel *TrialsLabel;
    IBOutlet UILabel *levelLabel;
    IBOutlet UILabel *touchHomePromt;
    
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

-(void)setBackToGood;
-(void)setBackToBad;
-(void)setBack;

-(IBAction)reSeed:(id)sender;
-(IBAction)back:(id)sender;

-(void)saveData;

@end
