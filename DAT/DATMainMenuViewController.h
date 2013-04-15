//
//  DATMainMenuViewController.h
//  DAT
//
//  Created by Jacob  Balthazor on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "barGrapher.h"
#import "GAZZCloud.h"

@interface DATMainMenuViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    
    //Setup
    IBOutlet UIView *setupView;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *studyField;
    IBOutlet UISwitch *soundSwitch;
    IBOutlet UISwitch *discriminationSwitch;
    IBOutlet UISwitch *rightSwitch;
    IBOutlet UIView *lockScreen;
    IBOutlet UIButton *closeLockButton;
    
    //Send Data
    IBOutlet UIView *sendView;
    IBOutlet UITextView *dataView;
    IBOutlet UIButton *clearButton;
    
    //Check Marks
    IBOutlet UIImageView *checkOne;
    IBOutlet UIImageView *checkTwo;
    IBOutlet UIImageView *checkThree;
    
    //Training Perameters
    IBOutlet UIStepper *levelUpStepper;
    IBOutlet UIStepper *levelDownStepper;
    IBOutlet UIStepper *heatlengthStepper;
    IBOutlet UILabel *levelUpLabel;
    IBOutlet UILabel *levelDownLabel;
    IBOutlet UILabel *heatLengthLabel;
    IBOutlet UILabel *RTChangeLabel;
    
    IBOutlet UISlider *RTChangeSlider;
    IBOutlet UISlider *percentCorrectToProgSlider;
    IBOutlet UISlider *errorMarginSlider;
    IBOutlet UISlider *stepSizeSlider;
    IBOutlet UISlider *cueProbeTimeSlider;
    IBOutlet UISlider *cueProbeRandomSlider;
    IBOutlet UISlider *goalReleaseTime;
    IBOutlet UILabel *percentCorrectToProgLabel;
    IBOutlet UILabel *errorMarginLabel;
    IBOutlet UILabel *stepSizeLabel;
    IBOutlet UILabel *goalReleaseTimeLabel;
    IBOutlet UILabel *cueProbeTimeLabel;
    IBOutlet UILabel *cueProbeRandomLabel;
    
    IBOutlet UISlider *probeSizeSlider;
    IBOutlet UISlider *activeProbeSizeSlider;
    IBOutlet UILabel *probeSizeLabel;
    IBOutlet UILabel *activeSizeLabel;
    IBOutlet UILabel *trainingTimeLabel;
    IBOutlet UISlider *trainingTimeSlider;
    
    // Analytics
    IBOutlet UIView *analyticView;
    IBOutlet barGrapher *graph;
    IBOutlet barGrapher *graphRT;
    IBOutlet UILabel *medianLabel;
    IBOutlet UILabel *startDateLabel;
    IBOutlet UILabel *endDateLabel;
    IBOutlet UILabel *graphMaxLabel;
    IBOutlet UILabel *graphMinLabel;
    
    GAZZCloud *cloud;
}

-(IBAction)analyticsPressed:(id)sender;
-(IBAction)analyticsDonePressed:(id)sender;

-(IBAction)setupPressed:(id)sender;
-(IBAction)setupSaved:(id)sender;
-(IBAction)unlockPressed:(id)sender;

-(IBAction)sendPressed:(id)sender;
-(IBAction)sendData:(id)sender;

-(NSString*)generateDataText:(NSMutableArray*)data;
-(NSMutableArray*)generateDataArray:(NSMutableArray*)data;
-(NSMutableArray*)generateDataArrayRT:(NSMutableArray*)data;

-(IBAction)clearDataPressed:(id)sender;
-(IBAction)doneSendPressed:(id)sender;

-(IBAction)printJSON:(id)sender;

// Training perameter actions

-(IBAction)stepperChanged:(id)sender;

@end
