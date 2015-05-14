//
//  MediaTrack.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "MediaTrack.h"

@implementation MediaTrack

-(id)copyWithZone:(NSZone *)zone {
    MediaTrack* mediaTrackCopy = [[MediaTrack allocWithZone:zone] init];
    mediaTrackCopy.uid = self.uid;
    mediaTrackCopy.streamURL = self.streamURL;
    mediaTrackCopy.artworkURL = self.artworkURL;
    mediaTrackCopy.title = self.title;
    return mediaTrackCopy;
}

@end
