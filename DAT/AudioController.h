//
//  AudioController.h
//  iPadpop
//
//  Created by Jacob Balthazor on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AudioController : NSObject  <AVAudioPlayerDelegate> {
    int Level;
    
    AVAudioPlayer *avStreamPlayer;
    
    SystemSoundID popSoundID;
    SystemSoundID clickSoundID;
    SystemSoundID buzzSoundID;
    SystemSoundID bellSoundID;
    SystemSoundID song1ID;
    BOOL soundFXOn;
    BOOL musicOn;
    BOOL paused;
}

-(void)setLevel:(int)level;

-(void)playLeavingAudio;
-(void)playbuzzerAudio;
-(void)playbellAudio;
-(void)playArivingAudio;
-(void)setFX:(BOOL)isOn;
-(BOOL)getFX;

-(void)playMusic;
-(void)initplayMusic;
-(BOOL)pauseMusic;
-(void)setMusic:(BOOL)isOn;
-(BOOL)getMusic;

@end
