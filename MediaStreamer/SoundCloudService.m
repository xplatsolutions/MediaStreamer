//
//  SoundCloudService.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "SoundCloudService.h"
#import <CocoaSoundCloudAPI/SCSoundCloud.h>
#import <CocoaSoundCloudAPI/SCRequest.h>
#import "MediaTrack.h"

@interface SoundCloudService ()

@property (nonatomic, strong) id searchOpaqueObject;

@end

@implementation SoundCloudService

#define kClientId @"ee4e74dfd7f12054a22c52b3a1773526"
#define kSecret @"c20a178cf1637fb2815b68851ed94fed"

#pragma mark -
#pragma mark [ Singleton ]

+ (instancetype) sharedService
    {
    static SoundCloudService* sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,
        ^{
        sharedManager = [[SoundCloudService alloc] init];
        });
    
    return sharedManager;
    }

- (instancetype)init {
    if (self = [super init]) {
        [SCSoundCloud setClientID:kClientId
                        secret:kSecret
                   redirectURL:[NSURL URLWithString:@"mediastreamer://oauth"]];
    }
    return self;
}

- (void) login {
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        
        [[UIApplication sharedApplication] openURL:preparedURL];

    }];
}

- (void)search:(NSString *)searchString withCompletionHandler:(void (^)(NSArray* results))completionHandler {
    
    
    if (!self.searchOpaqueObject) {
    SCAccount *account = [SCSoundCloud account];
    self.searchOpaqueObject = [SCRequest performMethod:SCRequestMethodGET
                       onResource:[NSURL URLWithString:@"https://api.soundcloud.com/tracks.json"]
                  usingParameters:@{ @"q": searchString, @"client_id": kClientId }
                      withAccount:account
           sendingProgressHandler:nil
                  responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                        self.searchOpaqueObject = nil;
                        // Handle the response
                        if (error) {
                            NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                        } else {
                            // Check the statuscode and parse the data
//                            NSLog(@"%@", data);
                            NSMutableArray* tracks = [NSMutableArray array];
                            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                            if (httpResponse.statusCode < 299) {
                            NSError* jsonError = nil;
                            NSArray* jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                            if (jsonError) {
                                NSLog(@"%@", jsonError.debugDescription);
                            }
                            else {
                                // load models
//                                NSLog(@"Tracks: %@", jsonData);
                                for (NSDictionary* dict in jsonData) {
                                    MediaTrack* mediaTrack = [MediaTrack new];
                                    mediaTrack.uid = [dict valueForKey:@"id"];
                                    mediaTrack.streamURL = [NSString stringWithFormat:@"%@.json?client_id=%@", [dict valueForKey:@"stream_url"], kClientId];
                                    mediaTrack.artworkURL = [dict valueForKey:@"artwork_url"];
                                    mediaTrack.title = [dict valueForKey:@"title"];
                                    [tracks addObject:mediaTrack];
                                }
                            }
                            }
                            if (completionHandler) {
                                completionHandler(tracks);
                            }
                        }
          }];
    }
}

- (void) cancelSearch {
    if (self.searchOpaqueObject) {
        [SCRequest cancelRequest:self.searchOpaqueObject];
    }
}

@end
