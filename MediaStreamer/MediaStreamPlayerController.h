//
//  MediaStreamPlayerController.h
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaTrack.h"
#import "MediaStreamPlayerProtocol.h"

@interface MediaStreamPlayerController : UIViewController

@property (copy, nonatomic) MediaTrack* mediaTrack;
@property (strong, nonatomic) id<MediaStreamPlayerProtocol> mediaStreamPlayer;

@end
