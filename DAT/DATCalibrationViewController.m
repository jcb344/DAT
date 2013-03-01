//
//  DATCalibrationViewController.m
//  DAT
//
//  Created by Jacob  Balthazor on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATCalibrationViewController.h"

@interface DATCalibrationViewController ()

@end

@implementation DATCalibrationViewController

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)startCalibration:(id)sender{
    numberOfTrialsToGo = 10;
    [self updateTrialsLabel];
    [dataLogger startCalibrationSessionwithName:@"First Calibration"];
    [homeButton setHidden:NO];
    [touchHomePromt setHidden:NO];
}

-(IBAction)homeTouched:(id)sender{
    [touchHomePromt setHidden:YES];
    homeShouldBeHeld = YES;
    [level startNewRound];
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:[level currentWaitTime] target:self selector:@selector(showFlash) userInfo:nil repeats:NO];
}

-(IBAction)homeReleased:(id)sender{
    if (homeShouldBeHeld) {
        [delayTimer invalidate];
        [touchHomePromt setHidden:NO];
        [level startNewRound];
        if (![que isCross]) {
            [que displayCross];
        }
    }
}

-(void)showFlash {
    [que setAngle:[level currentTheta]];
    [que setUnsertainty:[level currentQueAcuracy]];
    [que displayQue];
    [que setNeedsDisplay];
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:[level currentFlashTime] target:self selector:@selector(hideFlash) userInfo:nil repeats:NO];
}

-(void)hideFlash {
    [que displayCross];
    [que setNeedsDisplay];
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:[level currentWaitTime] target:self selector:@selector(displayButtonAtRandomLocation) userInfo:nil repeats:NO];
}

-(void)displayButtonAtRandomLocation{
    
    int theta = [level currentTheta];
    
    CGRect buttonLocation = CGRectMake(radius*cos(pi*theta/180.0)+centerX-buttonWidth/2, radius*sin(pi*theta/180.0)+centerY-buttonHeight/2, buttonWidth, buttonHeight);
    //NSLog(@"x:%f,y:%f",buttonLocation.origin.x,buttonLocation.origin.y);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:buttonLocation];
    [button addTarget:self action:@selector(buttonPressed:withEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:button];
    [homeButton setHidden:YES];
    homeShouldBeHeld = NO;
    [touchHomePromt setHidden:YES];
    [dataLogger calibrationStartTimerWithTheta:theta];
}

-(IBAction)buttonPressed:(id)sender withEvent:(UIEvent *)event{
    [dataLogger calibrationStopTimer];
    [sound playbellAudio];
    [sender removeFromSuperview];
    //[sender release];
    
    numberOfTrialsToGo--;
    [self updateTrialsLabel];
    if (numberOfTrialsToGo !=0) {
        // go to home message
        [homeButton setHidden:NO];
        [touchHomePromt setHidden:NO];
    }
    else {
        [dataLogger logCalibrationData];
    }
    
}


-(void)updateTrialsLabel {
    [TrialsLabel setText:[NSString stringWithFormat:@"Trail: %d",numberOfTrialsToGo]];
}

-(IBAction)reSeed:(id)sender {
    [que setAngle:0];
    [que setUnsertainty:.5];
    [que setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataLogger = [[DATDataLogger alloc] init];
    level = [[DATLevelTracker alloc] init];
    sound = [[AudioController alloc] init];
    
    que = [[DATQue alloc] initWithFrame:CGRectMake(334, 452, 100, 100)];
    
    [que setAngle:0];
    [que setUnsertainty:.25];
    [self.view addSubview:que];
    [que displayCross];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL ret = NO;
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        ret = YES;
    }
    return ret;
}


@end
