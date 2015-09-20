//
//  AppDelegate.m
//  SpotifyTestApp
//
//  Created by Igor on 18/09/15.
//  Copyright (c) 2015 rutmb. All rights reserved.
//

#import "AppDelegate.h"
#import <Spotify/Spotify.h>

#import "SPTAuthNotification.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[SPTAuth defaultInstance] setClientID:@"84a7f90d959b4e499a15c365fe022502"];
    [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"my-test-app-login://callback"]];
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope]];
    
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    
    [application performSelector:@selector(openURL:)
                      withObject:loginURL afterDelay:0.1];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (error != nil) {
                NSLog(@"Auth error: %@", error);
                return;
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:SPTAuthNotificationSuccess object:nil];
            }
        }];
        return YES;
    }
    
    return NO;
}


@end
