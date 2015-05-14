//
//  AppDelegate.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/11/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"
#import "MenuViewController.h"
#import "SpotifyService.h"

#import <TheSidebarController/TheSidebarController.h>
#import <CocoaSoundCloudAPI/SCSoundCloud.h>
#import <Spotify/Spotify.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
//    SearchViewController *contentViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainNavigationViewController"];
 
    UINavigationController *contentNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainNavigationViewController"];
    contentNavigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    contentNavigationController.view.layer.shadowOffset = (CGSize){0.0, 0.0};
    contentNavigationController.view.layer.shadowOpacity = 0.8;
    contentNavigationController.view.layer.shadowRadius = 10.0;
    
    MenuViewController *leftSidebarViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController leftSidebarViewController:leftSidebarViewController rightSidebarViewController:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = sidebarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = NO;
    
    // Ask SPTAuth if the URL given is a Spotify authentication callback
    if ([url.absoluteString containsString:@"#access_token"]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {

             if (error != nil) {
                 NSLog(@"*** Auth error: %@", error);
                 return;
             } else {
                [[SpotifyService sharedService] saveSession:session];
             }
        }];
    } else {
        handled = [SCSoundCloud handleRedirectURL:url];
    }
    
    return handled;
}

@end
