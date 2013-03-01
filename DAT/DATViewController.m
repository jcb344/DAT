//
//  DATViewController.m
//  DAT
//
//  Created by Jacob  Balthazor on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATViewController.h"

@interface DATViewController ()

@end

@implementation DATViewController

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)startTesting:(id)sender{

    if (inSession) {
        NSLog(@"Finished Trial");
        [dataLogger endGameSessionWithLevel:[level level]];
        [dataLogger printGameData];
        inSession = NO;
        [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self saveData];
    }
    else {
        [dataLogger startGameSessionwithName:[[self navigationController] name] ];
        [homeButton setHidden:NO];
        [touchHomePromt setHidden:NO];
        inSession = YES
        ;
        [startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    
}

-(IBAction)homeTouched:(id)sender{
    [levelLabel setText:[NSString stringWithFormat:@"%d",[level level]]];
    [touchHomePromt setHidden:YES];
    homeShouldBeHeld = YES;
    [level startNewRound];
    [dataLogger setCurrentTimeBetweenCueAndTarget:[level currentWaitTime] ];
    [dataLogger setCurrentTargetOnScreenTime:[level currentFlashTime] ];
    [dataLogger setCurrentAngleOfXVPlus:7.95f];
    [dataLogger setCurrentInformationOfTheCue:[level currentQueAcuracy]];
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
    ButtonToPress = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ButtonToPress setFrame:buttonLocation];
    [ButtonToPress addTarget:self action:@selector(buttonPressed:withEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:ButtonToPress];
    [homeButton setHidden:YES];
    [backgroundButton setHidden:NO];
    homeShouldBeHeld = NO;
    [touchHomePromt setHidden:YES];
    [ButtonToPress setHidden:NO];
    [dataLogger setCurrentlocationOfTargetInDegrees:(float)theta];
    [dataLogger startLogGameSessionData];
}

-(IBAction)buttonPressed:(id)sender withEvent:(UIEvent *)event{
    if (sender == ButtonToPress) {
        [dataLogger logGameSessionDataCorrect:YES];
        [level logRoundResult:TRUE];
        if (soundState) {
            [sound playbellAudio];
        }
    }
    else {
        [dataLogger logGameSessionDataCorrect:NO];
        [level logRoundResult:FALSE];
        if (soundState) {
            [sound playbuzzerAudio];
        }
    }
    [backgroundButton setHidden:YES];
    
    [ButtonToPress removeFromSuperview];
    
    
    [homeButton setHidden:NO];
    [touchHomePromt setHidden:NO];
    

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
    
    [level setLevel:[dataLogger loadPreviousData:[self.navigationController logData]]];
    [levelLabel setText:[NSString stringWithFormat:@"%d",[level level]]];
    
    que = [[DATQue alloc] initWithFrame:CGRectMake(334, 452, 100, 100)];
    
    [que setAngle:0];
    [que setUnsertainty:.25];
    [self.view addSubview:que];
    [que displayCross];
    
    soundState = [self.navigationController soundState];
    inSession = NO;
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

-(void)saveData{
    [self.navigationController setLogData:[dataLogger gameData]];
}

@end
