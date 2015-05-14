//
//  MediaServiceFactory.h
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"
#import "MediaServiceProtocol.h"
#import "MediaStreamPlayerProtocol.h"

@interface MediaTypeFactory : NSObject

+ (id<MediaServiceProtocol>) serviceForMediaType:(MediaServiceType)mediaType;
+ (id<MediaStreamPlayerProtocol>) playerForMediaType:(MediaServiceType)mediaType;

@end
