//
//  SoundCloudStreamPlayer.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/13/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "SoundCloudStreamPlayer.h"
#import <StreamingKit/STKAudioPlayer.h>

@interface SoundCloudStreamPlayer ()

@property (strong, nonatomic) STKAudioPlayer* audioPlayer;

@end

@implementation SoundCloudStreamPlayer

- (instancetype)init {
    if (self = [super init]) {
        self.audioPlayer = [[STKAudioPlayer alloc] init];
    }
    return self;
}

- (void)stop {
    [self.audioPlayer stop];
}

-(void)resume {
    [self.audioPlayer resume];
}

- (void)pause {
    [self.audioPlayer pause];
}

- (void)play:(NSString*)streamURL {
    [self.audioPlayer play:streamURL];
}

- (double)duration {
    return self.audioPlayer.duration;
}

- (double)progress {
    return self.audioPlayer.progress;
}

- (MediaStreamAudioPlayerState)state {
    MediaStreamAudioPlayerState mediaStreamState = MediaStreamAudioPlayerStateReady;
    switch (self.audioPlayer.state) {
        case STKAudioPlayerStateBuffering:
            mediaStreamState = MediaStreamAudioPlayerStateBuffering;
            break;
        case STKAudioPlayerStateDisposed:
            mediaStreamState = MediaStreamAudioPlayerStateDisposed;
            break;
        case STKAudioPlayerStateError:
            mediaStreamState = MediaStreamAudioPlayerStateError;
            break;
        case STKAudioPlayerStatePaused:
            mediaStreamState = MediaStreamAudioPlayerStatePaused;
            break;
        case STKAudioPlayerStatePlaying:
            mediaStreamState = MediaStreamAudioPlayerStatePlaying;
            break;
        case STKAudioPlayerStateReady:
            mediaStreamState = MediaStreamAudioPlayerStateReady;
            break;
        case STKAudioPlayerStateRunning:
            mediaStreamState = MediaStreamAudioPlayerStateRunning;
            break;
        case STKAudioPlayerStateStopped:
            mediaStreamState = MediaStreamAudioPlayerStateStopped;
            break;
    }
    return mediaStreamState;
}

- (void)dealloc {
    [self.audioPlayer dispose];
    self.audioPlayer = nil;
}

@end
