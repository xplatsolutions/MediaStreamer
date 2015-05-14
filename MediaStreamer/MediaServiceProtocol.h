//
//  MediaServiceProtocol.h
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MediaServiceProtocol <NSObject>

@required
    - (void) login;
    - (void) search:(NSString *)searchString withCompletionHandler:(void (^)(NSArray* results))completionHandler;
    
@end
