//
//  ViewController.m
//  SpotifyTestApp
//
//  Created by Igor on 18/09/15.
//  Copyright (c) 2015 rutmb. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Spotify/Spotify.h>

#import "SPTAuthNotification.h"

@interface ViewController ()

@property (strong,nonatomic) SPTAudioStreamingController *streamPlayer;
@property (strong,nonatomic) AVPlayer* player;
@property (assign,nonatomic) BOOL isMusicPlaying;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSPTAuthNotificationSuccess:) name:SPTAuthNotificationSuccess object:nil];
    
    NSString* urlString = @"http://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:urlString]];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SPTAuthNotification

-(void) onSPTAuthNotificationSuccess:(NSNotification*) notification {
    
    self.streamPlayer = [[SPTAudioStreamingController alloc] initWithClientId:[SPTAuth defaultInstance].clientID];
    
    [self.streamPlayer loginWithSession:[SPTAuth defaultInstance].session callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Logging error: %@", error);
            return;
        } else {
            self.playStreamButton.enabled = YES;
        }
        
    }];
}

#pragma mark - Actions

-(void) pauseStream {
    [self.streamPlayer stop:^(NSError *error) {
        if(error != nil) {
            NSLog(@"Stop steam error : %@",error);
            return;
        }
    }];
    [self.playStreamButton setTitle:@"Play stream" forState:UIControlStateNormal];
}

-(void) playStream {
    NSURL *trackURI = [NSURL URLWithString:@"spotify:track:58s6EuEYJdlb0kO7awm3Vp"];
    SPTPlayOptions* playOptions = [[SPTPlayOptions alloc] init];
    playOptions.trackIndex = 0;
    playOptions.startTime = self.streamPlayer.currentPlaybackPosition;
    [self.streamPlayer playURIs:@[trackURI] withOptions:playOptions callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Starting playback error: %@", error);
            return;
        }
    }];
    [self.playStreamButton setTitle:@"Pause stream" forState:UIControlStateNormal];
    
    if(self.isMusicPlaying) [self pauseMusic];
}

-(void) pauseMusic {
    [self.player pause];
    [self.playMusicButton setTitle:@"Play music" forState:UIControlStateNormal];
    
    self.isMusicPlaying = !self.isMusicPlaying;
}

-(void) playMusic {
    [self.player play];
    [self.playMusicButton setTitle:@"Pause music" forState:UIControlStateNormal];
    if(self.streamPlayer.isPlaying) [self pauseStream];
    
    self.isMusicPlaying = !self.isMusicPlaying;
}

- (IBAction)playStreamAction:(UIButton *)sender {
    
    if([self.streamPlayer isPlaying]) [self pauseStream];
    else [self playStream];
}

- (IBAction)playMusicAction:(UIButton *)sender {
    
    if(self.isMusicPlaying) [self pauseMusic];
    else [self playMusic];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
