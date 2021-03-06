//
//  DATTrainingViewController.m
//  DAT
//
//  Created by Jacob  Balthazor on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATTrainingViewController.h"

@interface DATTrainingViewController ()

@end

@implementation DATTrainingViewController



float distance(x1,x2,y1,y2){
    return sqrtf((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
}

-(IBAction)back:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished?" message:@"Remember to send the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
    [alert setDelegate:self];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView.message isEqualToString:@"Remember to send the data."]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)startTesting:(id)sender{
    
    if (inSession) {
        NSLog(@"Finished Trial");
        [dataLogger endGameSessionWithLevel:0];
        //[dataLogger printGameData];
        inSession = NO;
        [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self saveData];
        [backButton setHidden:NO];
        [timer invalidate];
    }
    else {
        [dataLogger startGameSessionwithName:[[self navigationController] name] ];
        //[homeButton setHidden:NO];
        [touchHomePromt setHidden:NO];
        inSession = YES;
        [startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [backButton setHidden:YES];
        [homeButton setHidden:NO];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        
    }
    
}

-(void)updateTimer{
    time--;
    int min = time/60;
    int sec = time%60;
    if (sec > 10) {
        [timeLable setText:[NSString stringWithFormat:@"Remaining Time %d:%d",min,sec]];
    }
    else
        [timeLable setText:[NSString stringWithFormat:@"Remaining Time %d:0%d",min,sec]];
    
    if (time <= 0) {
        [timer invalidate];
        timer = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished" message:@"Your training is now complete. Stop the training and remember to send the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];
    }
}

-(IBAction)homeTouched:(id)sender{
    if (sender == homeButton) {
        homePressed = YES;
    }
    else if (sender == leftHomeButton){
        LeftHomePressed = YES;
    }
    
    if (startTimerWhenHomePressed && homePressed == YES && LeftHomePressed == YES) {
        homeBeingPressed = YES;
        [levelLabel setText:[NSString stringWithFormat:@"%d",[leveL simpleLevelNumber]]];
        [touchHomePromt setHidden:YES];
        homeShouldBeHeld = YES;
        [leveL startNewRound];
        [dataLogger setCurrentTimeBetweenCueAndTarget:simpleCueToProbeTime ];
        [dataLogger setCurrentTargetOnScreenTime:simpleCueTime ];
        delayTimer = [NSTimer scheduledTimerWithTimeInterval:simpleWaitToCueTime/1000 target:self selector:@selector(showFlash) userInfo:nil repeats:NO];
        startTimerWhenHomePressed = NO;
        [self updateTrialsLabel];
    }
}

-(IBAction)homeReleased:(id)sender{
    if (sender == homeButton) {
        homePressed = NO;
    }
    else if (sender == leftHomeButton){
        LeftHomePressed = NO;
    }

    if (sender == homeButton) {
        homeBeingPressed = NO;
        if (homeShouldBeHeld) {
            if (delayTimer != Nil) {
                [delayTimer invalidate];
                delayTimer = Nil;
            }
            [touchHomePromt setHidden:NO];
            [leveL trainingReSeed];
            startTimerWhenHomePressed = YES;
            if (![que isCross]) {
                [que displayCross];
            }
        }
        else {
            if (inSession) {
                if (ButtonToPress != nil) {
                    // Log release Time
                    if ([ButtonToPress backgroundImageForState:UIControlStateNormal] == noGoImage) {
                        if (soundState) {
                            [sound playbuzzerAudio];
                            [self setBackToBad];
                        }
                        if (delayTimer != Nil) {
                            [delayTimer invalidate];
                            delayTimer = Nil;
                        }
                        [touchHomePromt setHidden:NO];
                        [leveL trainingReSeed];
                        startTimerWhenHomePressed = YES;
                        if (![que isCross]) {
                            [que displayCross];
                        }
                        [ButtonToPress removeFromSuperview];
                        ButtonToPress = nil;
                    }
                    [dataLogger logGameSessionReleaseTime];
                }
            }
        }
    }
}

-(void)showFlash {
    
    [leveL trainingReSeed];
    [que setStartAngle:[leveL trainingStartAngle]];
    [que setEndAngle:[leveL trainingEndAngle]];
    [dataLogger setCurrentInformationOfTheCue:[leveL trainingQueSize]];
    
    [que displayQue];
    [que setNeedsDisplay];
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:[leveL currentFlashTime] target:self selector:@selector(hideFlash) userInfo:nil repeats:NO];
}

-(void)hideFlash {
    [que displayCross];
    [que setNeedsDisplay];
    
    int i = [self.navigationController cueProbeTime];
    int j = [self.navigationController cueProbeRandom];
    
    float randomTime =  (((float)(arc4random()%100))/100 * 2*(((float) j/1000)) ) - (((float) j/1000));
    float cueProbeTime = (((float)i/1000))+randomTime;
    [dataLogger setCurrentCueProbeTime:cueProbeTime];
    
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:(((float)i/1000))+randomTime target:self selector:@selector(displayButtonAtRandomLocation) userInfo:nil repeats:NO];
}

-(void)displayButtonAtRandomLocation{
    
    int theta = [leveL trainingCurrentTheta];
    
    CGRect buttonLocation = CGRectMake(radius*cos(pi*theta/180.0)+centerX-buttonWidth/2, radius*sin(pi*theta/180.0)+centerY-buttonHeight/2, activeButtonWidth, activeButtonHeight);
    //NSLog(@"x:%f,y:%f",buttonLocation.origin.x,buttonLocation.origin.y);
    //ButtonToPress = [UIButton buttonWithType:UIButtonTypeCustom];
    //[ButtonToPress setFrame:buttonLocation];
    [buttonHolder setFrame:buttonLocation];
    [buttonHolder setHidden:NO];
    
    if (goNoGoTest) {
        if (arc4random()%5 == 0) {
            [innerButton setBackgroundImage:noGoImage forState:UIControlStateNormal];
        }
        else {
            [innerButton setBackgroundImage:goImage forState:UIControlStateNormal];
        }
    }
    else {
        [innerButton setBackgroundImage:goImage forState:UIControlStateNormal];
    }
    //[ButtonToPress addTarget:self action:@selector(buttonPressed:withEvent:) forControlEvents:UIControlEventTouchDown];
    
    //[self.view addSubview:ButtonToPress];
    //[homeButton setHidden:YES];
    [backgroundButton setHidden:NO];
    homeShouldBeHeld = NO;
    [touchHomePromt setHidden:YES];
    [ButtonToPress setHidden:NO];
    [dataLogger setCurrentlocationOfTargetInDegrees:(float)theta];
    int i =[self.navigationController goalRelease];
    i = (((float)i)/1000.0);
    goalRT = i;
    //[self updateInicator];
    [dataLogger setCurrentReleaseReactionTimeGoal:i];
    [dataLogger startLogGameSessionData];
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(buttonTimeOut) userInfo:nil repeats:NO];
}

-(void)buttonTimeOut{
    [dataLogger setDistanceFromProbe:0];
    
    if ([innerButton backgroundImageForState:UIControlStateNormal] == noGoImage) {
        [dataLogger setShouldPressProbe:NO];
        [dataLogger logGameSessionDataCorrect:YES];
        if (soundState) {
            [sound playbellAudio];
            [self setBackToGood];
        }
    }
    else if ([innerButton backgroundImageForState:UIControlStateNormal]  == goImage) {
        [dataLogger setShouldPressProbe:YES];
        [dataLogger logGameSessionDataCorrect:NO];
        if (soundState) {
            [sound playbuzzerAudio];
            [self setBackToBad];
        }
    }
    [delayTimer invalidate];
    delayTimer = Nil;
    
    [buttonHolder setHidden:YES];
    //[ButtonToPress removeFromSuperview];
    //ButtonToPress = nil;
    
    
    
    //[homeButton setHidden:NO];
    [touchHomePromt setHidden:NO];
    [leveL trainingNextMatch];
    if ([leveL simpleLevelNumber] == 150 || [leveL simpleLevelNumber] == 100 || [leveL simpleLevelNumber] == 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Break Time" message:@"Take a quick break." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil ];
        [alert show];
        startTimerWhenHomePressed = YES;
    }
    /*
    else if ([leveL simpleLevelNumber] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished" message:@"Your test is now complete. Stop the test and remember to send the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];
        [homeButton setHidden:YES];
        [self.navigationController setTestComplete:YES];
        startTimerWhenHomePressed = YES;
    }
     */
    else {
        startTimerWhenHomePressed = YES;
        if (homeBeingPressed) {
            [self homeTouched:Nil];
        }
    }
}

-(IBAction)buttonPressed:(id)sender withEvent:(UIEvent *)event{
    if (delayTimer != Nil) {
        
        [delayTimer invalidate];
        delayTimer = Nil;
    }
    
    // Calculate Distance
    float xCenterButton = buttonHolder.frame.origin.x + buttonHolder.frame.size.width/2.f;
    float yCenterButton = buttonHolder.frame.origin.y + buttonHolder.frame.size.height/2.f;
    
    NSSet * touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view ];
    
    float radius = distance(xCenterButton, touchPoint.x, yCenterButton, touchPoint.y);
    NSLog(@"distance: %f",radius);
    
    
    if ([innerButton backgroundImageForState:UIControlStateNormal]  == goImage) {
        [dataLogger setShouldPressProbe:YES];
        [dataLogger setDistanceFromProbe:radius];
    }
    else {
        [dataLogger setShouldPressProbe:NO];
        [dataLogger setDistanceFromProbe:0];
    }
    
    
    if (sender == ButtonToPress && LeftHomePressed == YES && homePressed == NO) {
        if ([innerButton backgroundImageForState:UIControlStateNormal] == goImage) {
            [dataLogger logGameSessionDataCorrect:YES];
            //[leveL logRoundResult:TRUE];
            [leveL trainingLogRoundResult:TRUE withRT:(float)[dataLogger currentReleaseReactionTime]];
            if ([dataLogger currentReleaseReactionTime] <= goalRT) {
                if (soundState) {
                    [sound playbellAudio];
                    [self setBackToGood];
                }
                [self updateInicator];
            }
            else{
                if (soundState) {
                    [sound playbuzzerAudio];
                    [self setBackToBad];
                }
            }
        
        }
        else if ([innerButton backgroundImageForState:UIControlStateNormal] == noGoImage){
            [dataLogger logGameSessionDataCorrect:NO];
            [leveL trainingLogRoundResult:FALSE withRT:(float)[dataLogger currentReleaseReactionTime]];
            if (soundState) {
                [sound playbuzzerAudio];
                [self setBackToBad];
            }
        }
    }
    else {//if (sender == backgroundButton)
        [dataLogger logGameSessionDataCorrect:NO];
        [leveL trainingLogRoundResult:FALSE withRT:(float)[dataLogger currentReleaseReactionTime]];
        if (soundState) {
            [sound playbuzzerAudio];
            [self setBackToBad];
        }
    }
    /*
    if (sender == ButtonToPress) {
        [dataLogger logGameSessionDataCorrect:YES];
        //[leveL logRoundResult:TRUE];
        [leveL trainingLogRoundResult:TRUE withRT:(float)[dataLogger currentReleaseReactionTime]];
        if (soundState) {
            [sound playbellAudio];
        }
    }
    else {
        [dataLogger logGameSessionDataCorrect:NO];
        [leveL trainingLogRoundResult:FALSE withRT:(float)[dataLogger currentReleaseReactionTime]];
        if (soundState) {
            [sound playbuzzerAudio];
        }
    }
    */
     
    [backgroundButton setHidden:YES];
    //[ButtonToPress removeFromSuperview];
    //ButtonToPress = nil;
    [buttonHolder setHidden:YES];
    
    // Prompt for breaks
    //[homeButton setHidden:NO];
    [touchHomePromt setHidden:NO];
    [leveL trainingNextMatch];
    if ([leveL simpleLevelNumber] == 150 || [leveL simpleLevelNumber] == 100 || [leveL simpleLevelNumber] == 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Break Time" message:@"Take a quick break." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil ];
        [alert show];
    }
    /*
    else if ([leveL simpleLevelNumber] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished" message:@"Your test is now complete. Stop the test and remember to send the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];
        [homeButton setHidden:YES];
        [self.navigationController setTestComplete:YES];
    }
     */
    startTimerWhenHomePressed = YES;
}


-(void)updateTrialsLabel {
    [TrialsLabel setText:[NSString stringWithFormat:@"Level: %d",[leveL level]]];
}

-(IBAction)reSeed:(id)sender {
    [que setAngle:0];
    [que setUnsertainty:.5];
    [que setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    simpleCueTime = .2f;
    simpleWaitToCueTime = 2000;
    simpleCueToProbeTime = 1500;
    
    radius = 340;
    pi = 3.14159;
    centerX = 384;
    centerY = 502;
    
    buttonWidth = [self.navigationController probeSize];
    buttonHeight = [self.navigationController probeSize];
    activeButtonWidth = [self.navigationController activeSize];
    activeButtonHeight = [self.navigationController activeSize];
    
    CGRect centeredFrame = CGRectMake( ((activeButtonWidth-buttonWidth)/2), ((activeButtonWidth-buttonWidth)/2), buttonWidth, buttonHeight);
    [buttonHolder setFrame:CGRectMake(0, 0, activeButtonWidth, activeButtonHeight)];
    [ButtonToPress setFrame:CGRectMake(0, 0, activeButtonWidth, activeButtonHeight)];
    [innerButton setFrame:centeredFrame];
    
    
    BOOL s = [self.navigationController rightState];
    if ( s) {
        [leftHomeButton setFrame:CGRectMake(20, 915, 106, 70)];
    }
    else{
        [leftHomeButton setFrame:CGRectMake(642, 915, 106, 70)];
    }
    
    goImage = [UIImage imageNamed:@"GoImage.png"];
    noGoImage = [UIImage imageNamed:@"NoGoImage.png"];
    
    dataLogger = [[DATDataLogger alloc] init];
    leveL = [[DATLeveTrackerTwo alloc] init];
    sound = [[AudioController alloc] init];
    
    [dataLogger loadPreviousData:[self.navigationController logData]];
    [leveL setnavigationController:self.navigationController];
    [leveL simpleSetLevel:1];
    
    [levelLabel setText:[NSString stringWithFormat:@"%d",[leveL simpleLevelNumber]]];
    
    que = [[DATQue alloc] initWithFrame:CGRectMake(334, 452, 100, 100)];
    [que setIsFixedMode:YES];
    [que setInsideColor:[UIColor whiteColor]];
    [que setOutSideColor:[UIColor blueColor]];
    
    [self.view addSubview:que];
    [que displayCross];
    
    goNoGoTest = [self.navigationController discriminationState];
    soundState = [self.navigationController soundState];
    
    int f = [[self navigationController] goalRelease];
    
    
    UINavigationController *n =self.navigationController;
    
    int i =[self.navigationController goalRelease];
    [leveL setGoalRT:(((float)i)/1000.0)];
    i = [self.navigationController rTChange];
    [leveL setRTChange:(((float)i)/1000.0)];
    i = [self.navigationController errorMargin];
    [leveL setRtMargin:(((float)i)/1000.0)];
    i = [self.navigationController stepSize];
    [leveL setLevelDegreeSteps:(((float)i)/1000.0)];
    i = [self.navigationController percentCorrectToProg];
    [leveL setPercentToLevelUp:(((float)i)/1000.0)];
    i = [self.navigationController percentCorrectToProg];
    [leveL setPercentToLevelDown:(((float)i)/1000.0)];
    i = [self.navigationController levelDown];
    [leveL setNumberDownIfFalse:[self.navigationController levelDown]];
    [leveL setNumberUpIfCorrect:[self.navigationController levelUp]];
    [leveL setHeatSize:[self.navigationController heatlength]];
    
    time = (int)[self.navigationController trainingTime];
    int min = time/60;
    int sec = time%60;
    if (sec > 10)
        [timeLable setText:[NSString stringWithFormat:@"Remaining Time %d:%d",min,sec]];
    else
        [timeLable setText:[NSString stringWithFormat:@"Remaining Time %d:0%d",min,sec]];
    
    inSession = NO;
    homeBeingPressed = NO;
    startTimerWhenHomePressed = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)updateInicator{
    int i =[self.navigationController goalRelease];
    i = (((float)i)/1000.0);
    goalRT = i;
    [RTGoalLabel setText:[NSString stringWithFormat:@"Goal %d",goalRT]];
    [lastRectionTime setText:[NSString stringWithFormat:@"%d",[dataLogger currentReleaseReactionTime]]];
    /*
    float percentage = ((float)([dataLogger currentReleaseReactionTime]-goalRT))/((float)goalRT);
    if (percentage > .5) {
        percentage = .5;
    }
    else if (percentage < -.5){
        percentage = -.5;
    }
    percentage = percentage +.5;
     */
    
    float percentage = ((float)([dataLogger currentReleaseReactionTime]-goalRT))/((float)goalRT);
    if (percentage < 0) {
        percentage = 0;
    }
    else if (percentage < -1.f){
        percentage = -1.f;
    }
    percentage = 2*(percentage+.5);
    percentage = 1-(percentage-1);
    if(percentage < 0.f){
        percentage = 0.f;
    }
    NSLog(@"percentage:%f",percentage);
    CGRect frame = [goalIndicator frame];
    CGRect labelframe = [lastRectionTime frame];
    CGRect gaugeFrame = [goalGauge frame];
    frame.origin.y = gaugeFrame.size.height*(1-percentage);
    labelframe.origin.y = gaugeFrame.origin.y+gaugeFrame.size.height*(1-percentage) - labelframe.size.height/2;
    [goalIndicator setFrame:frame];
    [lastRectionTime setFrame:labelframe];
}

-(void)setBackToGood{
    [UIView beginAnimations:nil context:nil ];
    [UIView setAnimationDuration:.2];
    [self.view setBackgroundColor:[UIColor greenColor]];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(setBack)];
    [UIView commitAnimations];
}
-(void)setBackToBad{
    [UIView beginAnimations:nil context:nil ];
    [UIView setAnimationDuration:.2];
    [self.view setBackgroundColor:[UIColor redColor]];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(setBack)];
    [UIView commitAnimations];
}
-(void)setBack{
    [UIView beginAnimations:nil context:nil ];
    [UIView setAnimationDuration:.4];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [UIView commitAnimations];
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
