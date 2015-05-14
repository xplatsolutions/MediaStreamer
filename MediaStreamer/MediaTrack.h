//
//  MediaTrack.h
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaTrack : NSObject <NSCopying>

@property (strong, nonatomic) NSString* uid;
@property (strong, nonatomic) NSString* streamURL;
@property (strong, nonatomic) NSString* artworkURL;
@property (strong, nonatomic) NSString* title;


@end
