//
//  SoundCloudService.h
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "MediaServiceProtocol.h"

@import UIKit;

@interface SoundCloudService : NSObject <MediaServiceProtocol>

+ (instancetype) sharedService;

//- (void) login;
//- (void) search:(NSString *)searchString withCompletionHandler:(void (^)(NSArray* results))completionHandler;

@end
