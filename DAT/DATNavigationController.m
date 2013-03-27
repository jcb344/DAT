//
//  DATNavigationController.m
//  DAT
//
//  Created by Jacob  Balthazor on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATNavigationController.h"

@interface DATNavigationController ()

@end

@implementation DATNavigationController

@synthesize goalRelease,errorMargin,percentCorrectToProg,stepSize,levelUp,levelDown,heatlength,loadedFromFile;
@synthesize soundState;
@synthesize logData;
@synthesize name;
@synthesize discriminationState;
@synthesize testComplete;
@synthesize probeSize;
@synthesize activeSize;
@synthesize rightState;
@synthesize cueProbeTime;
@synthesize cueProbeRandom;
@synthesize studyID;

-(void)setRTChange:(int)r{
    RTChange = r;
}
-(int)rTChange{
    
    return RTChange;
}

-(void)clearLog{
    [logData release];
    logData = Nil;
}

-(NSString*)dataFilePath
{ 
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *pathFin = [documentDirectory stringByAppendingPathComponent:@"board"];
    return pathFin;
}

-(void)resumeState
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"Loading saved file");
        NSMutableDictionary *file = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        levelUp = [[file objectForKey:@"levelUp"] intValue];
        levelDown = [[file objectForKey:@"levelDown"] intValue];
        heatlength = [[file objectForKey:@"heatlength"] intValue];
        
        RTChange = [[file objectForKey:@"RTChange"] intValue];
        percentCorrectToProg = [[file objectForKey:@"percentCorrectToProg"] intValue];
        errorMargin = [[file objectForKey:@"errorMargin"] intValue];
        stepSize = [[file objectForKey:@"stepSize"] intValue];
        goalRelease = [[file objectForKey:@"goalRelease"] intValue];
        cueProbeTime = [[file objectForKey:@"cueProbeTime"] intValue];
        cueProbeRandom = [[file objectForKey:@"cueProbeRandom"] intValue];
        probeSize = [[file objectForKey:@"probeSize"] intValue];
        activeSize = [[file objectForKey:@"activeSize"] intValue];
        
        testComplete = [[file objectForKey:@"testComplete"] boolValue];
        soundState = [[file objectForKey:@"soundState"] boolValue];
        discriminationState = [[file objectForKey:@"discriminationState"] boolValue];
        rightState = [[file objectForKey:@"rightState"] boolValue];
        
        //
        logData = [file objectForKey:@"logData"];
        [logData retain];
        //
        
        name = [file objectForKey:@"name"];
        [name retain];
        studyID = [file objectForKey:@"studyID"];
        [studyID retain];
        
        
        [file release];
        loadedFromFile = YES;
    }
    else
    {
        NSLog(@"No Saved file");
        testComplete = NO;
        soundState = YES;
        discriminationState = YES;
        loadedFromFile = NO;
    }
}

-(void)saveState
{
    NSLog(@"Saving");
    NSMutableDictionary *file = [[NSMutableDictionary alloc] init];
    
    [file setObject:[NSNumber numberWithInt:levelUp] forKey:@"levelUp"];
    [file setObject:[NSNumber numberWithInt:levelDown] forKey:@"levelDown"];
    [file setObject:[NSNumber numberWithInt:heatlength] forKey:@"heatlength"];
    
    [file setObject:[NSNumber numberWithInt:RTChange] forKey:@"RTChange"];
    [file setObject:[NSNumber numberWithInt:percentCorrectToProg] forKey:@"percentCorrectToProg"];
    [file setObject:[NSNumber numberWithInt:errorMargin] forKey:@"errorMargin"];
    [file setObject:[NSNumber numberWithInt:stepSize] forKey:@"stepSize"];
    [file setObject:[NSNumber numberWithInt:goalRelease] forKey:@"goalRelease"];
    [file setObject:[NSNumber numberWithInt:cueProbeTime] forKey:@"cueProbeTime"];
    [file setObject:[NSNumber numberWithInt:cueProbeRandom] forKey:@"cueProbeRandom"];
    
    [file setObject:[NSNumber numberWithInt:probeSize] forKey:@"probeSize"];
    [file setObject:[NSNumber numberWithInt:activeSize] forKey:@"activeSize"];
    
    [file setObject:[NSNumber numberWithBool:testComplete] forKey:@"testComplete"];
    [file setObject:[NSNumber numberWithBool:soundState] forKey:@"soundState"];
    [file setObject:[NSNumber numberWithBool:discriminationState] forKey:@"discriminationState"];
    [file setObject:[NSNumber numberWithBool:rightState] forKey:@"rightState"];
    
    [file setObject:name forKey:@"name"];
    [file setObject:studyID forKey:@"studyID"];
    
    if (logData != nil) {
        [file setObject:logData forKey:@"logData"];
    }
    
    [file writeToFile:[self dataFilePath] atomically:NO];
    [file release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    loadedFromFile = NO;
    [self resumeState];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
