//
//  DATSimpleViewControllerViewController.m
//  DAT
//
//  Created by Jacob  Balthazor on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATSimpleViewControllerViewController.h"

@interface DATSimpleViewControllerViewController ()

@end

@implementation DATSimpleViewControllerViewController


float distancE(x1,x2,y1,y2){
    return sqrtf((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    }
    else {
        [dataLogger startGameSessionwithName:[[self navigationController] name] ];
        //[homeButton setHidden:NO];
        [touchHomePromt setHidden:NO];
        inSession = YES;
        [startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [backButton setHidden:YES];
        [homeButton setHidden:NO];
    }
    
}



-(IBAction)homeTouched:(id)sender{
    if (startTimerWhenHomePressed) {
        homeBeingPressed = YES;
        [levelLabel setText:[NSString stringWithFormat:@"%d",[level simpleLevelNumber]]];
        [touchHomePromt setHidden:YES];
        homeShouldBeHeld = YES;
        [level startNewRound];
        [dataLogger setCurrentTimeBetweenCueAndTarget:simpleCueToProbeTime ];
        [dataLogger setCurrentTargetOnScreenTime:simpleCueTime ];
        delayTimer = [NSTimer scheduledTimerWithTimeInterval:simpleWaitToCueTime/1000 target:self selector:@selector(showFlash) userInfo:nil repeats:NO];
        startTimerWhenHomePressed = NO;
    }
}

-(IBAction)homeReleased:(id)sender{
    homeBeingPressed = NO;
    if (homeShouldBeHeld) {
        if (delayTimer != nil) {
            [delayTimer invalidate];
        }
        [touchHomePromt setHidden:NO];
        [level simpleReSeed];
        startTimerWhenHomePressed = YES;
        if (![que isCross]) {
            [que displayCross];
        }
    }
    else {
        if (inSession) {
            // Log release Time
            [dataLogger logGameSessionReleaseTime];
        }
    }
}

-(void)showFlash {
    
    [level simpleReSeed];
    [que setStartAngle:[level simpleStartAngle]];
    [que setEndAngle:[level simpleEndAngle]];
    [dataLogger setCurrentInformationOfTheCue:[level simpleQueSize]];
    
    [que displayQue];
    [que setNeedsDisplay];
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:[level currentFlashTime] target:self selector:@selector(hideFlash) userInfo:nil repeats:NO];
}

-(void)hideFlash {
    [que displayCross];
    [que setNeedsDisplay];
    int i = [self.navigationController cueProbeTime];
    int j = [self.navigationController cueProbeRandom];
    
    float randomTime =  (((float)(arc4random()%100))/100 * 2*(((float) j/1000)) ) - (((float) j/1000));
    float cueProbeTime = (((float)i/1000))+randomTime;
    [dataLogger setCurrentCueProbeTime:cueProbeTime];
    
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:cueProbeTime target:self selector:@selector(displayButtonAtRandomLocation) userInfo:nil repeats:NO];
}

-(void)displayButtonAtRandomLocation{
    
    int theta = [level simpleCurrentTheta];
    
    CGRect buttonLocation = CGRectMake(radius*cos(pi*theta/180.0)+centerX-buttonWidth/2, radius*sin(pi*theta/180.0)+centerY-buttonHeight/2, activeButtonWidth,activeButtonHeight);
    //NSLog(@"x:%f,y:%f",buttonLocation.origin.x,buttonLocation.origin.y);
    //ButtonToPress = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    [backgroundButton setHidden:YES];
    [buttonHolder setHidden:YES];
    
    //[homeButton setHidden:NO];
    [touchHomePromt setHidden:NO];
    [level simpleNextLevel];
    if ([level simpleLevelNumber] == 150 || [level simpleLevelNumber] == 100 || [level simpleLevelNumber] == 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Break Time" message:@"Take a quick break." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil ];
        [alert show];
        startTimerWhenHomePressed = YES;
    }
    else if ([level simpleLevelNumber] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished" message:@"Your test is now complete. Stop the test and remember to send the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];
        [homeButton setHidden:YES];
        [self.navigationController setTestComplete:YES];
        startTimerWhenHomePressed = YES;
    }
    else {
        startTimerWhenHomePressed = YES;
        if (homeBeingPressed) {
            [self homeTouched:Nil];
        }
    }
}

-(IBAction)buttonPressed:(id)sender withEvent:(UIEvent *)event{
    if (delayTimer != nil) {
        [delayTimer invalidate];
    }
    // Calculate Distance
    float xCenterButton = buttonHolder.frame.origin.x + buttonHolder.frame.size.width/2.f;
    float yCenterButton = buttonHolder.frame.origin.y + buttonHolder.frame.size.height/2.f;
    
    NSSet * touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view ];
    
    float radius = distancE(xCenterButton, touchPoint.x, yCenterButton, touchPoint.y);
    NSLog(@"distance: %f",radius);
    
    
    
    
    if ([innerButton backgroundImageForState:UIControlStateNormal]  == goImage) {
        [dataLogger setShouldPressProbe:YES];
        [dataLogger setDistanceFromProbe:radius];
    }
    else {
        [dataLogger setShouldPressProbe:NO];
        [dataLogger setDistanceFromProbe:0];
    }
    
    if (sender == ButtonToPress) {
        [dataLogger logGameSessionDataCorrect:YES];
        [level logRoundResult:TRUE];
        if (soundState) {
            [sound playbellAudio];
            [self setBackToGood];
        }
    }
    else {
        [dataLogger logGameSessionDataCorrect:NO];
        [level logRoundResult:FALSE];
        if (soundState) {
            [sound playbuzzerAudio];
            [self setBackToBad];
        }
    }
   
    [backgroundButton setHidden:YES];
    [buttonHolder setHidden:YES];
    
    
    // Prompt for breaks
    //[homeButton setHidden:NO];
    [touchHomePromt setHidden:NO];
    [level simpleNextLevel];
    if ([level simpleLevelNumber] == 150 || [level simpleLevelNumber] == 100 || [level simpleLevelNumber] == 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Break Time" message:@"Take a quick break." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil ];
        [alert show];
    }
    else if ([level simpleLevelNumber] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished" message:@"Your test is now complete. Stop the test and remember to send the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];
        [homeButton setHidden:YES];
        [self.navigationController setTestComplete:YES];
    }
    startTimerWhenHomePressed = YES;
}


-(void)updateTrialsLabel {
    [TrialsLabel setText:[NSString stringWithFormat:@"Trail: %d",[level simpleLevelNumber]]];
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
    
    radius = 350;
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
    
    goImage = [UIImage imageNamed:@"GoImage.png"];
    noGoImage = [UIImage imageNamed:@"NoGoImage.png"];
    
    [buttonHolder setHidden:YES];
    
    dataLogger = [[DATDataLogger alloc] init];
    level = [[DATLevelTracker alloc] init];
    sound = [[AudioController alloc] init];
    
    [dataLogger loadPreviousData:[self.navigationController logData]];
    [level simpleSetLevel:200];
    
    [levelLabel setText:[NSString stringWithFormat:@"%d",[level simpleLevelNumber]]];
    
    que = [[DATQue alloc] initWithFrame:CGRectMake(334, 452, 100, 100)];
    [que setIsFixedMode:YES];
    [que setInsideColor:[UIColor whiteColor]];
    [que setOutSideColor:[UIColor blueColor]];
    
    [self.view addSubview:que];
    [que displayCross];
    
    goNoGoTest = [self.navigationController discriminationState];
    soundState = [self.navigationController soundState];
    inSession = NO;
    homeBeingPressed = NO;
    startTimerWhenHomePressed = YES;
	// Do any additional setup after loading the view, typically from a nib.
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
