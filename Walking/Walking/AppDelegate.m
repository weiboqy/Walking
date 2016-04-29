//
//  AppDelegate.m
//  Walking
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "AppDelegate.h"
#import "WKTabBarViewController.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WKWelcomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // window作为启动窗口
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 根视图
//    self.window.rootViewController = [[WKTabBarViewController alloc]init];
    // 窗口展示
    [self.window makeKeyAndVisible];
    
    [UMSocialData setAppKey:@"570bb59a67e58e78b30005a0"];

    [UMSocialQQHandler setQQWithAppId:@"100424468"appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        WKLog(@"第一次启动");
        
        WKWelcomeViewController *welcomeVC = [[WKWelcomeViewController alloc]init];
        self.window.rootViewController = welcomeVC;
    }else {
        WKLog(@"不是第一次启动");
        // 根视图
        self.window.rootViewController = [[WKTabBarViewController alloc]init];
        
        _image = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _image.image = [UIImage imageNamed:@"夜空视角.jpg"];
        [self.window addSubview:_image];
        [self.window bringSubviewToFront:_image];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
        _image.alpha = 0.0;
        _image.frame = CGRectMake(-60, -85, 440, 635);
        
    }
   
    
    
    
    
    [UIView commitAnimations];
    return YES;
}
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [_image removeFromSuperview];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
