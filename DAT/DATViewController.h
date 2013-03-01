//
//  DATViewController.h
//  DAT
//
//  Created by Jacob  Balthazor on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DATDataLogger.h"
#import "DATQue.h"
#import "DATLevelTracker.h"
#import "AudioController.h"

#import "Constants.h"

@interface DATViewController : UIViewController{
    
    DATDataLogger *dataLogger;
    DATLevelTracker *level;
    DATQue *que;
    AudioController *sound;
    
    NSTimer *delayTimer;
    int numberOfTrialsToGo;
    BOOL homeShouldBeHeld;
    
    BOOL inSession;
    BOOL soundState;
    
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *ButtonToPress;
    IBOutlet UIButton *backgroundButton;
    IBOutlet UIButton *startStopButton;
    
    IBOutlet UILabel *TrialsLabel;
    IBOutlet UILabel *levelLabel;
    IBOutlet UILabel *touchHomePromt;
}

-(void)displayButtonAtRandomLocation;
-(void)updateTrialsLabel;
-(void)showFlash;
-(void)hideFlash;

-(IBAction)homeTouched:(id)sender;
-(IBAction)homeReleased:(id)sender;
-(IBAction)startTesting:(id)sender;
-(IBAction)buttonPressed:(id)sender withEvent:(UIEvent *)event;


-(IBAction)reSeed:(id)sender;
-(IBAction)back:(id)sender;

-(void)saveData;

@end
