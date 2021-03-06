//
//  SpotifyStreamPlayer.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/13/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "SpotifyStreamPlayer.h"
#import "SpotifyService.h"

@interface SpotifyStreamPlayer ()

@property (strong, nonatomic, getter=getDefaultSession) SPTSession* session;
@property (strong, nonatomic) SPTAudioStreamingController* player;
@property (assign, nonatomic) MediaStreamAudioPlayerState playerState;
@property (strong, nonatomic) NSString* uri;
@property (assign, nonatomic) NSTimeInterval currentOffset;

@end

@implementation SpotifyStreamPlayer

- (instancetype)init {
    if (self = [super init]) {
        self.player = [[SPTAudioStreamingController alloc] initWithClientId:kSpotifyClientId];
        self.playerState = MediaStreamAudioPlayerStateReady;
        if (!self.player.loggedIn) {
            [self.player loginWithSession:self.session callback:^(NSError *error) {
                if (error) {
                    NSLog(@"Error logging in Spotify player: %@", error.debugDescription);
                    [[SpotifyService sharedService] login];
                }
            }];
        }
    }
    return self;
}

- (SPTSession*) getDefaultSession {
    if (_session) return _session;
    _session = [[SpotifyService sharedService] getDefaultSession];
    return _session;
}

- (void)play:(NSString *)streamURL {
    self.uri = streamURL;
    [SPTTrack trackWithURI:[NSURL URLWithString:streamURL] session:self.session callback:^(NSError *error, id object) {
        if (error) {
            NSLog(@"Track lookup error: %@", error.debugDescription);
        } else {
            SPTTrack* track = object;
            [self.player playURIs:@[ track.uri ] withOptions:[SPTPlayOptions new] callback:^(NSError *error) {
                if (!error) {
                    self.playerState = MediaStreamAudioPlayerStatePlaying;
                }
            }];
        }
    }];
}

- (void)stop {
    [self.player stop:^(NSError *error) {
        if (error) {
            NSLog(@"Spotify player error in stop: %@", error.debugDescription);
        } else {
            self.playerState = MediaStreamAudioPlayerStateStopped;
        }

    }];
}

- (void)pause {
    [self pauseResume];
}

- (void)resume {
    [self pauseResume];
}

- (void) pauseResume {
    if (self.player.isPlaying) {
        _currentOffset = self.player.currentPlaybackPosition;
        [self.player setIsPlaying:NO callback:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                _playerState = MediaStreamAudioPlayerStatePaused;
            }
        }];
    } else {
        [SPTTrack trackWithURI:[NSURL URLWithString:self.uri] session:self.session callback:^(NSError *error, id object) {
        if (error) {
            NSLog(@"Track lookup error: %@", error.debugDescription);
        } else {
            [self.player seekToOffset:_currentOffset callback:^(NSError *error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                }
                [self.player setIsPlaying:YES callback:^(NSError *error) {
                    _playerState = MediaStreamAudioPlayerStatePlaying;
                }];
            }];
        }
        }];
    }
}

- (MediaStreamAudioPlayerState)state {
    return self.playerState;
}

- (double)duration {
    return [self.player currentTrackDuration];
}

- (double)progress {
    return [self.player currentPlaybackPosition];
}

@end
