//
//  DATNavigationController.h
//  DAT
//
//  Created by Jacob  Balthazor on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DATNavigationController : UINavigationController{
    NSString *name;
    BOOL soundState;
    int RTChange;
    
    NSMutableArray *logData;
    
    IBOutlet UISlider *percentCorrectToProgSlider;
    IBOutlet UISlider *errorMarginSlider;
    IBOutlet UISlider *stepSizeSlider;
    IBOutlet UISlider *goalReleaseTime;
    IBOutlet UILabel *percentCorrectToProgLabel;
    IBOutlet UILabel *errorMarginLabel;
    IBOutlet UILabel *stepSizeLabel;
    IBOutlet UILabel *goalReleaseTimeLabel;
    
    BOOL loadedFromFile;
}
@property (assign) BOOL loadedFromFile;

@property (assign) int levelUp;
@property (assign) int levelDown;
@property (assign) int heatlength;

@property (assign) int percentCorrectToProg;
@property (assign) int errorMargin;
@property (assign) int stepSize;
@property (assign) int goalRelease;
@property (assign) int probeSize;

@property (assign) BOOL testComplete;
@property (assign) BOOL soundState;
@property (assign) BOOL discriminationState;
@property (assign) BOOL rightState;
@property (nonatomic,retain) NSMutableArray *logData;
@property (nonatomic,retain) NSString *name;

-(NSString*)dataFilePath;
-(void)resumeState;
-(void)saveState;

-(void)setrTChange:(int)r;
-(int)RTChange;

@end
