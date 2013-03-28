//
//  DATMainMenuViewController.m
//  DAT
//
//  Created by Jacob  Balthazor on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATMainMenuViewController.h"

@interface DATMainMenuViewController ()

@end

@implementation DATMainMenuViewController

-(IBAction)unlockPressed:(id)sender{
    [lockScreen setHidden:YES];
    [closeLockButton setHidden:YES];
}

-(IBAction)stepperChanged:(id)sender{
    if (sender == levelUpStepper) {
        [levelUpLabel setText:[NSString stringWithFormat:@"%2.f",[levelUpStepper value]]];
    }
    else if (sender == levelDownStepper) {
        [levelDownLabel setText:[NSString stringWithFormat:@"%2.f",[levelDownStepper value]]];
    }
    else if (sender == heatlengthStepper) {
        [heatLengthLabel setText:[NSString stringWithFormat:@"%2.f",[heatlengthStepper value]]];
    }
    else if (sender == percentCorrectToProgSlider) {
        [percentCorrectToProgLabel setText:[NSString stringWithFormat:@"%.2f",[percentCorrectToProgSlider value]]];
    }
    else if (sender == errorMarginSlider) {
        [errorMarginLabel setText:[NSString stringWithFormat:@"%.2f",[errorMarginSlider value]]];
    }
    else if (sender == stepSizeSlider) {
        [stepSizeLabel setText:[NSString stringWithFormat:@"%.3f",[stepSizeSlider value]]];
    }
    else if (sender == goalReleaseTime) {
        [goalReleaseTimeLabel setText:[NSString stringWithFormat:@"%2.f",[goalReleaseTime value]]];
    }
    else if (sender == probeSizeSlider) {
        if ([activeProbeSizeSlider value] < [probeSizeSlider value]) {
            [activeProbeSizeSlider setValue:[probeSizeSlider value]];
            [activeSizeLabel setText:[NSString stringWithFormat:@"%2.f",[activeProbeSizeSlider value]]];
        }
        [probeSizeLabel setText:[NSString stringWithFormat:@"%2.f",[probeSizeSlider value]]];
    }
    else if (sender == activeProbeSizeSlider) {
        if ([activeProbeSizeSlider value] < [probeSizeSlider value]) {
            [activeProbeSizeSlider setValue:[probeSizeSlider value]];
        }
        [activeSizeLabel setText:[NSString stringWithFormat:@"%2.f",[activeProbeSizeSlider value]]];
    }
    else if (sender == RTChangeSlider) {
        [RTChangeLabel setText:[NSString stringWithFormat:@"%2.f",[RTChangeSlider value]]];
    }
    else if (sender == cueProbeTimeSlider) {
        [cueProbeTimeLabel setText:[NSString stringWithFormat:@"%.1f",[cueProbeTimeSlider value]]];
    }
    else if (sender == cueProbeRandomSlider) {
        if ([cueProbeRandomSlider value] > [cueProbeTimeSlider value]) {
            [cueProbeRandomSlider setValue:[cueProbeTimeSlider value]];
        }
        [cueProbeRandomLabel setText:[NSString stringWithFormat:@"%.1f",[cueProbeRandomSlider value]]];
    }
}

-(IBAction)doneSendPressed:(id)sender{
    [sendView setHidden:YES];
}

-(IBAction)clearDataPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Once deleted previous data will not be accessible." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1)
    {
        //[[self.navigationController logData] release];
        //[self.navigationController setLogData:nil];
        [self.navigationController clearLog];
        [dataView setText:@"No Data Logged"];
        [clearButton setEnabled:NO];
        //[checkThree setHidden:YES];
        //[checkTwo setHidden:YES];
        //[checkOne setHidden:YES];
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultSent) {
        //[checkThree setHidden:NO];
    }

}

-(IBAction)analyticsPressed:(id)sender{
    [setupView setHidden:YES];
    [sendView setHidden:YES];
    if ([analyticView isHidden]) {
        [analyticView setHidden:NO];
        // Change Bellow
        if ([self.navigationController logData] != Nil) {
            
            [graph graphData:[self generateDataArray:[self.navigationController logData]]];
            [graphRT graphData:[self generateDataArrayRT:[self.navigationController logData]]];
            [graph setforceMax:TRUE];
            [graph setMax:[graphRT max]];
            [graph setMin:[graphRT min]];
            
            [graphMaxLabel setText:[NSString stringWithFormat:@"%dms",[graphRT max]]];
            [graphMinLabel setText:[NSString stringWithFormat:@"%dms",[graphRT min]]];
            
            [graphRT setColor:[UIColor greenColor]];
            [graph setColor:[UIColor whiteColor]];
            [graphRT setNeedsDisplay];
            [graph setNeedsDisplay];
        }
        else {
            //[dataView setText:@"No Data Logged"];
            [medianLabel setText:@"No Data Logged"];
        }
        
    }
    else {
        [analyticView setHidden:YES];
    }
}
-(IBAction)analyticsDonePressed:(id)sender{
    [analyticView setHidden:YES];
}

-(IBAction)sendPressed:(id)sender{
    [setupView setHidden:YES];
    [analyticView setHidden:YES];
    if ([sendView isHidden]) {
        [sendView setHidden:NO];
        id test = [self.navigationController logData] ;
        if ([self.navigationController logData] != nil) {
            [clearButton setEnabled:YES];
            [dataView setText:[self generateDataText:[self.navigationController logData]]];
        }
        else {
            [dataView setText:@"No Data Logged"];
            [clearButton setEnabled:NO];
        }
        
    }
    else {
        [sendView setHidden:YES];
    }
}

-(IBAction)sendData:(id)sender{
    if (cloud == Nil) {
        cloud = [[GAZZCloud alloc] init];
    }
    [cloud setStudyID:[studyField text]];
    [cloud setSubjectID:[nameField text]];
    [cloud postJSONOf:[self.navigationController logData] toAdress:@"http://cerebrum.ucsf.edu/datapost"];
    
    /* old mail way
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObjects:@"datstudydata@gmail.com",nil]];
        [mailViewController setSubject:[NSString stringWithFormat:@"Lab Data %@",[nameField text]]];
        [mailViewController setMessageBody:[dataView text] isHTML:NO];
          
        [self presentModalViewController:mailViewController animated:YES];
        [mailViewController release];
        
          
    }
    else {
        NSLog(@"Device is unable to send email in its current state.");
    }
     */
}


-(IBAction)setupSaved:(id)sender{
    
    [self.navigationController setGoalRelease:(int)(1000*[goalReleaseTime value])];
    [self.navigationController setErrorMargin:(int)(1000*[errorMarginSlider value])];
    [self.navigationController setRTChange:(int)(1000*[RTChangeSlider value])];
    [self.navigationController setPercentCorrectToProg:(int)(1000*[percentCorrectToProgSlider value])];
    [self.navigationController setStepSize:(int)(1000*[stepSizeSlider value])];
    [self.navigationController setCueProbeTime:(int)(1000*[cueProbeTimeSlider value])];
    [self.navigationController setCueProbeRandom:(int)(1000*[cueProbeRandomSlider value])];
    
    [self.navigationController setLevelUp:(int)[levelUpStepper value]];
    [self.navigationController setLevelDown:(int)[levelDownStepper value]];
    [self.navigationController setHeatlength:(int)[heatlengthStepper value]];
    [self.navigationController setProbeSize:(int)[probeSizeSlider value]];
    [self.navigationController setActiveSize:(int)[activeProbeSizeSlider value]];
    
    [self.navigationController setName:[nameField text]];
    [self.navigationController setStudyID:[studyField text]];
    [self.navigationController setSoundState:[soundSwitch isOn]];
    [self.navigationController setRightState:[rightSwitch isOn]];
    [self.navigationController setDiscriminationState:[discriminationSwitch isOn]];
    
    [self.navigationController saveState];
    
    //[checkOne setHidden:NO];
    [setupView setHidden:YES];
    [nameField resignFirstResponder];
    [studyField resignFirstResponder];
}

-(IBAction)setupPressed:(id)sender{
    [sendView setHidden:YES];
    [analyticView setHidden:YES];
    [closeLockButton setHidden:NO];
    [lockScreen setHidden:NO];
    if ([setupView isHidden]) {
        [setupView setHidden:NO];
    }
    else {
        [setupView setHidden:YES];
    }
}

-(NSString*)generateDataText:(NSMutableArray*)data{
    NSString *outData = @"";/*[NSString stringWithFormat:@"%@\t%@",
        [headerData objectForKey:@"name"],
        [[NSDate dateWithTimeIntervalSince1970:[[headerData objectForKey:@"date"] intValue]] description] 
    ];
    */
    
    outData = [outData stringByAppendingString:@"\ntimeStamp\ttargetOnScreenTime\tangleOfXVPlus\tlocationOfTargetInDegrees\tinformationOfTheCue\treleaseTime\treactionTime\tSucsess\tshouldPressProbe\tdistanceFromProbe\tGoalRT"];
    
    for (int i = 0; i<[data count]; i++) {
        
        outData = [outData stringByAppendingFormat:@"\n%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@",
                   [[[data objectAtIndex:i] objectForKey:@"timeStamp"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"targetOnScreenTime"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"angleOfXVPlus"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"locationOfTargetInDegrees"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"informationOfTheCue"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"releaseReactionTime"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"reactionTime"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"sucsess"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"shouldPressProbe"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"distanceFromProbe"] stringValue],
                   [[[data objectAtIndex:i] objectForKey:@"currentReleaseReactionTimeGoal"] stringValue]
                   ];                   
    }
    
    return outData;
}

-(NSMutableArray*)generateDataArray:(NSMutableArray*)data{
    NSNumber *startDateNumber ;
    NSNumber *endDateNumber ;
    NSMutableArray *outArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *arraySorted = [[NSMutableArray alloc] init];
    
    BOOL startDateAquired = NO;
    for (int i = 0; i<[data count]; i++) {
        
        if ([[[data objectAtIndex:i] objectForKey:@"shouldPressProbe"] intValue] == 1 && [[[data objectAtIndex:i] objectForKey:@"sucsess"] intValue] == 1) {
            if ([[[data objectAtIndex:i] objectForKey:@"currentReleaseReactionTimeGoal"] intValue] == 0 && [[[data objectAtIndex:i] objectForKey:@"informationOfTheCue"] floatValue] == .5) {
                [arraySorted addObject:[[data objectAtIndex:i] objectForKey:@"releaseReactionTime"]];
            }
            if ([[[data objectAtIndex:i] objectForKey:@"currentReleaseReactionTimeGoal"] intValue] != 0) {
                if (startDateAquired == NO) {
                    startDateNumber = [[data objectAtIndex:i] objectForKey:@"timeStamp"];
                    startDateAquired = YES;
                }
                [outArray addObject:[[data objectAtIndex:i] objectForKey:@"currentReleaseReactionTimeGoal"]];
                endDateNumber = [[data objectAtIndex:i] objectForKey:@"timeStamp"];
            }
            
        }
    }
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [arraySorted sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    float median;
    if ([arraySorted count] > 0) {
        if ([arraySorted count]%2 == 1) {
            //odd
            median = [[arraySorted objectAtIndex:([arraySorted count]/2)] floatValue];
        }
        else{
            //even
            float first = [[arraySorted objectAtIndex:([arraySorted count]/2)-1] floatValue];
            float second = [[arraySorted objectAtIndex:([arraySorted count]/2)] floatValue];
            median = (first+second)/2.f;
        }
        [medianLabel setText:[NSString stringWithFormat:@"Median RT: %3.f",median]];
    }
    
    
    if ([outArray count] > 0) {
        NSDate *eDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[endDateNumber doubleValue]];
        NSDate *sDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[startDateNumber doubleValue]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        
        [startDateLabel setText:[dateFormatter stringFromDate:sDate]];
        [endDateLabel setText:[dateFormatter stringFromDate:eDate]];
    }
    
    return outArray;
}

-(NSMutableArray*)generateDataArrayRT:(NSMutableArray*)data{
    NSMutableArray *outArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<[data count]; i++) {
        if ([[[data objectAtIndex:i] objectForKey:@"shouldPressProbe"] intValue] == 1 && [[[data objectAtIndex:i] objectForKey:@"sucsess"] intValue] == 1 && [[[data objectAtIndex:i] objectForKey:@"currentReleaseReactionTimeGoal"] intValue] != 0) {
            [outArray addObject:[[data objectAtIndex:i] objectForKey:@"releaseReactionTime"]];
        }
    }
    return  outArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [sendView setHidden:YES];
    [setupView setHidden:YES];
    //[checkTwo setHidden:![self.navigationController testComplete]];
    
    //Update Controls
    if ([self.navigationController loadedFromFile] == YES) {
        int i;
        
        i = [self.navigationController levelUp];
        [levelUpStepper setValue:(float)i];
        i = [self.navigationController levelDown];
        [levelDownStepper setValue:(float)i];
        i = [self.navigationController heatlength];
        [heatlengthStepper setValue:(float)i];
        i = [self.navigationController probeSize];
        [probeSizeSlider setValue:(float)i];
        i = [self.navigationController activeSize];
        [activeProbeSizeSlider setValue:(float)i];
        
        i = [self.navigationController percentCorrectToProg];
        [percentCorrectToProgSlider setValue:(float)i/1000.f];
        i = [self.navigationController rTChange];
        [RTChangeSlider setValue:(float)i/1000.f];
        i = [self.navigationController errorMargin];
        [errorMarginSlider setValue:(float)i/1000.f];
        i = [self.navigationController stepSize];
        [stepSizeSlider setValue:(float)i/1000.f];
        i = [self.navigationController goalRelease];
        [goalReleaseTime setValue:(float)i/1000.f];
        i = [self.navigationController cueProbeRandom];
        [cueProbeRandomSlider setValue:(float)i/1000.f];
        i = [self.navigationController cueProbeTime];
        [cueProbeTimeSlider setValue:(float)i/1000.f];
        
        
        BOOL j = [self.navigationController soundState];
        [soundSwitch setOn:j];
        j = [self.navigationController discriminationState];
        [discriminationSwitch setOn:j];
        j = [self.navigationController rightState];
        [rightSwitch setOn:j];
    }
    
    //Update Labels
    [levelUpLabel setText:[NSString stringWithFormat:@"%2.f",[levelUpStepper value]]];
    [levelDownLabel setText:[NSString stringWithFormat:@"%2.f",[levelDownStepper value]]];
    [heatLengthLabel setText:[NSString stringWithFormat:@"%2.f",[heatlengthStepper value]]];
    [percentCorrectToProgLabel setText:[NSString stringWithFormat:@"%.2f",[percentCorrectToProgSlider value]]];
    [errorMarginLabel setText:[NSString stringWithFormat:@"%.2f",[errorMarginSlider value]]];
    [stepSizeLabel setText:[NSString stringWithFormat:@"%.3f",[stepSizeSlider value]]];
    [goalReleaseTimeLabel setText:[NSString stringWithFormat:@"%2.f",[goalReleaseTime value]]];
    [cueProbeTimeLabel setText:[NSString stringWithFormat:@"%.1f",[cueProbeTimeSlider value]]];
    [cueProbeRandomLabel setText:[NSString stringWithFormat:@"%.1f",[cueProbeRandomSlider value]]];
    [probeSizeLabel setText:[NSString stringWithFormat:@"%2.f",[probeSizeSlider value]]];
    [activeSizeLabel setText:[NSString stringWithFormat:@"%2.f",[activeProbeSizeSlider value]]];
    [RTChangeLabel setText:[NSString stringWithFormat:@"%2.f",[RTChangeSlider value]]];
    if ([self.navigationController name] != nil) {
        [nameField setText:[self.navigationController name]];
    }
    if ([self.navigationController studyID] != nil) {
        [studyField setText:[self.navigationController studyID]];
    }
    [self setupSaved:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
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
