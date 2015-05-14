//
//  MediaServiceFactory.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "MediaTypeFactory.h"
#import "SpotifyService.h"
#import "SoundCloudService.h"
#import "SoundCloudStreamPlayer.h"
#import "SpotifyStreamPlayer.h"

@implementation MediaTypeFactory

+ (id<MediaServiceProtocol>) serviceForMediaType:(MediaServiceType)mediaType {
    id<MediaServiceProtocol> service = nil;
    switch (mediaType) {
        case MediaServiceTypeUnknown:
            // Do nothing at the moment
            break;
        case MediaServiceTypeSoundCloud:
            service = [SoundCloudService new];
            break;
        case MediaServiceTypeSpotify:
            service = [SpotifyService new];
            break;
    }
    return service;
}

+ (id<MediaStreamPlayerProtocol>) playerForMediaType:(MediaServiceType)mediaType {
    id<MediaStreamPlayerProtocol> player = nil;
    switch (mediaType) {
        case MediaServiceTypeUnknown:
            // Do nothing at the moment
            break;
        case MediaServiceTypeSoundCloud:
            player = [SoundCloudStreamPlayer new];
            break;
        case MediaServiceTypeSpotify:
            player = [SpotifyStreamPlayer new];
            break;
    }
    return player;
}

@end
