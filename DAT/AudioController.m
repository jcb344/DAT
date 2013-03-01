//
//  AudioController.m
//  iPadpop
//
//  Created by Jacob Balthazor on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioController.h"


@implementation AudioController

- (id)init {
    self = [super init];
    if (self) {
        //NSString *popPath = [[NSBundle mainBundle] pathForResource:@"popGain" ofType:@"wav"];
        //NSString *clickPath = [[NSBundle mainBundle] pathForResource:@"clickGained" ofType:@"wav"];
        NSString *buzzPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
        NSString *bellPath = [[NSBundle mainBundle] pathForResource:@"glassClink" ofType:@"wav"];
        
        //AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:popPath], &popSoundID);
        //AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:clickPath], &clickSoundID);
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:buzzPath], &buzzSoundID);
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:bellPath], &bellSoundID);
        NSURL *fileURL = nil;
        
        
        soundFXOn = NO;
        musicOn = NO;
        paused = NO;
    }
    return self;
}

-(void)playMusic {
    /*
    if (musicOn) {
        [avStreamPlayer setNumberOfLoops:2];
        [avStreamPlayer play];
        paused = NO;
    }
     */
}

-(void)initplayMusic {
    /*
    if (musicOn) {
        [avStreamPlayer setNumberOfLoops:2];
        [avStreamPlayer play];
        [avStreamPlayer pause ];
        paused = YES;
    }
     */
}

-(BOOL)pauseMusic {
    /*
    if (musicOn) {
        if (paused){
            /*
            [avStreamPlayer play];
            for (float i = 0 ; i<100; i++) {
                [avStreamPlayer setVolume:i/100];
                [NSThread sleepForTimeInterval:.002];
                if (i>50)
                    i = 100;
            }
            [avStreamPlayer setVolume:1];
             
            [self audioPlayerBeginInterruption:avStreamPlayer];
            paused = NO;
        }
            
        else {
            
            for (float i = 0 ; i<100; i++) {
                [avStreamPlayer setVolume:(100-i)/100];
                [NSThread sleepForTimeInterval:.002];
                if (i>50)
                    i = 100;
            }
            [avStreamPlayer pause];
             
            [self audioPlayerEndInterruption:avStreamPlayer];
            paused = YES;
        }
        
    }
    */
    return paused;
}

-(void)setLevel:(int)level
{
    Level = level;
}

-(void)playbellAudio {
    if (soundFXOn) {
        AudioServicesPlaySystemSound(bellSoundID);
    }
}
-(void)playbuzzerAudio {
    if (soundFXOn) {
        AudioServicesPlaySystemSound(buzzSoundID);
    }
}

-(void)playLeavingAudio
{
    if (soundFXOn) {
        AudioServicesPlaySystemSound(popSoundID);
    }
}

-(void)playArivingAudio
{
    if (soundFXOn) {
        AudioServicesPlaySystemSound(clickSoundID);
    }
}

-(void)setFX:(BOOL)isOn
{
    soundFXOn = isOn;
}

-(BOOL)getFX
{
    return soundFXOn;
}

-(void)setMusic:(BOOL)isOn
{
    /*
    musicOn = isOn;
    if (isOn == NO && !paused) {
        [avStreamPlayer pause];
    }
     */
}

-(BOOL)getMusic
{
    return musicOn;
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"finished playing");
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    /*
    for (float i = 0 ; i<100; i++) {
        [avStreamPlayer setVolume:(100-i)/100];
        [NSThread sleepForTimeInterval:.002];
        if (i>50)
            i = 100;
    }
    [avStreamPlayer pause];
     */
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    /*
    [avStreamPlayer play];
    for (float i = 0 ; i<100; i++) {
        [avStreamPlayer setVolume:i/100];
        [NSThread sleepForTimeInterval:.002];
        if (i>50)
            i = 100;
    }
    [avStreamPlayer setVolume:1]
     */
}
 

@end
