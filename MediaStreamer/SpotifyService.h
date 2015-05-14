//
//  SpotifyService.h
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "MediaServiceProtocol.h"
#import <Spotify/Spotify.h>

@interface SpotifyService : NSObject <MediaServiceProtocol>

extern NSString* const kSpotifyClientId;

+ (instancetype) sharedService;

- (void) saveSession:(SPTSession*)session;
- (BOOL) isSessionValid;
- (SPTSession*) getDefaultSession;
- (void) renewSession;

@end
