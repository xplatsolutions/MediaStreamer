//
//  SpotifyService.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "SpotifyService.h"
#import "MediaTrack.h"

@interface SpotifyService ()

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;

@end

@implementation SpotifyService

//#define kClientId @"0c2aaf3bbb694ffb917fbb2cf04b2ce1"
#define kSecret @"efc1634edcae4bdd9d55c77199d3c88e"
#define kSpotifySessionKey @"SpotifySession"

NSString* const kSpotifyClientId = @"0c2aaf3bbb694ffb917fbb2cf04b2ce1";

#pragma mark -
#pragma mark [ Singleton ]

+ (instancetype) sharedService
    {
    static SpotifyService* sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,
        ^{
        sharedManager = [[SpotifyService alloc] init];
        });
    
    return sharedManager;
    }

- (instancetype)init {
    if (self = [super init]) {
        [[SPTAuth defaultInstance] setClientID:kSpotifyClientId];
        [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"mediastreamer://"]];
        [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope]];
    }
    return self;
}

- (void) saveSession:(SPTSession*)session {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    [defaults setValue:sessionData forKey:kSpotifySessionKey];
    [defaults synchronize];
}

- (SPTSession*) getDefaultSession {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* sessionData = [defaults objectForKey:kSpotifySessionKey];
    SPTSession* session = [NSKeyedUnarchiver unarchiveObjectWithData:sessionData];
    return session;
}

- (BOOL) isSessionValid {
  SPTSession* session = [self getDefaultSession];
  return session && session.isValid;
}

- (void) renewSession {
    [[SPTAuth defaultInstance] renewSession:[self getDefaultSession] callback:^(NSError *error, SPTSession *session) {
        if (!error) {
            [self saveSession:session];
        }
    }];
}

- (void) login {
    // Construct a login URL and open it
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    
    [[UIApplication sharedApplication] openURL:loginURL];
}

- (void)search:(NSString *)searchString withCompletionHandler:(void (^)(NSArray *))completionHandler {
    [SPTRequest performSearchWithQuery:searchString queryType:SPTQueryTypeTrack offset:0 session:self.session callback:^(NSError *error, id object) {
        SPTListPage* listPage = object;
        NSMutableArray* tracks = [NSMutableArray array];
        for (SPTTrack* track in listPage.tracksForPlayback) {
            MediaTrack* mediaTrack = [MediaTrack new];
            mediaTrack.uid = track.identifier;
            mediaTrack.streamURL = track.playableUri.absoluteString;
            mediaTrack.artworkURL = track.album.largestCover.imageURL.absoluteString;
            mediaTrack.title = track.name;
            [tracks addObject:mediaTrack];
        }
        if (completionHandler) {
            completionHandler(tracks);
        }
    }];
}

@end
