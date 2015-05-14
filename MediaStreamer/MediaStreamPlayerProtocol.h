//
//  MediaStreamPlayerProtocol.h
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/13/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MediaStreamAudioPlayerState) {
    MediaStreamAudioPlayerStateReady,
    MediaStreamAudioPlayerStateRunning = 1,
    MediaStreamAudioPlayerStatePlaying = (1 << 1) | MediaStreamAudioPlayerStateRunning,
    MediaStreamAudioPlayerStateBuffering = (1 << 2) | MediaStreamAudioPlayerStateRunning,
    MediaStreamAudioPlayerStatePaused = (1 << 3) | MediaStreamAudioPlayerStateRunning,
    MediaStreamAudioPlayerStateStopped = (1 << 4),
    MediaStreamAudioPlayerStateError = (1 << 5),
    MediaStreamAudioPlayerStateDisposed = (1 << 6)
};

@protocol MediaStreamPlayerProtocol <NSObject>

@required
    - (void) stop;
    - (void) resume;
    - (void) pause;
    - (void) play:(NSString*)streamURL;
    - (double) duration;
    - (double) progress;
    - (MediaStreamAudioPlayerState) state;

@end
