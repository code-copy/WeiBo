//
//  AppDelegate.m
//  微博练习
//
//  Created by Silver on 15/4/2.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LeftViewController *leftCol = [[LeftViewController alloc] init];
    RightViewController *rightCol = [[RightViewController alloc] init];
    
    MainController *centerCol = [[MainController alloc] init];
    MMDrawerController *mainCol = [[MMDrawerController alloc] initWithCenterViewController:centerCol leftDrawerViewController:leftCol rightDrawerViewController:rightCol];
    
    [mainCol setMaximumLeftDrawerWidth:100];
    [mainCol setMaximumRightDrawerWidth:100];
    
    [mainCol setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mainCol setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [mainCol
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
    
    self.window.rootViewController = mainCol;
    
    //self.window.rootViewController = [[MainController alloc] init];
    
    self.sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURL andDelegate:self];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSDictionary *sinaWeiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
//    
//    if ([sinaWeiboInfo objectForKey:@"AccessTokenKey"] && [sinaWeiboInfo objectForKey:@"ExpirationDateKey"] && [sinaWeiboInfo objectForKey:@"UserIDKey"]) {
//        _sinaWeibo.accessToken = [sinaWeiboInfo objectForKey:@"AccessTokenKey"];
//        _sinaWeibo.expirationDate = [sinaWeiboInfo objectForKey:@"ExpirationDateKey"];
//        _sinaWeibo.userID = [sinaWeiboInfo objectForKey:@"UserIDKey"];
//    }
//
    return YES;
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken,@"AccessTokenKey",sinaweibo.expirationDate,@"ExpirationDateKey",sinaweibo.userID,@"UserIDKey",sinaweibo.refreshToken,@"refresh_token",nil];
    [[NSUserDefaults standardUserDefaults]setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken,@"AccessTokenKey",sinaweibo.expirationDate,@"ExpirationDateKey",sinaweibo.userID,@"UserIDKey",sinaweibo.refreshToken,@"refresh_token",nil];
    [[NSUserDefaults standardUserDefaults]setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{

    NSLog(@"登录失败：%@", error);
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
