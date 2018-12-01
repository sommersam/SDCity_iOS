//
//  AppDelegate.m
//  SDCity
//
//  Created by wangweidong on 2017/12/18.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RegisterNextViewController.h"
#import "MainViewController.h"
#import "HttpManager.h"
#import "UIImage+Image.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [SVProgressHUD setBackgroundColor:[SDUtils hexStringToColor:@"e5e5e5"]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController *mainVC = [[MainViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:mainVC];
    navigationController.navigationBar.barTintColor = [SDUtils hexStringToColor:@"e25947"];
    [navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Senty" size:32],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navigationController.navigationBar.translucent = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >10.0) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KmainWidth, 64)];
        bgView.backgroundColor = [SDUtils hexStringToColor:@"e25947"];
        [navigationController.navigationBar setValue:bgView forKey:@"backgroundView"];

        [navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[SDUtils hexStringToColor:@"e25947"]]
                                                     forBarPosition:UIBarPositionAny
                                                         barMetrics:UIBarMetricsDefault];
        [navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    [self userLoginAction];

//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    LoginViewController *loginVC = [[LoginViewController alloc]init];
//    self.window.rootViewController = loginVC;
//    [self.window makeKeyAndVisible];

    
    return YES;
}


-(void)userLoginAction{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserPassword] != nil && [[NSUserDefaults standardUserDefaults] valueForKey:UserAccount] != nil) {
        [HttpManager userLoginActionWithAccount:[[NSUserDefaults standardUserDefaults] valueForKey:UserAccount] password:[[NSUserDefaults standardUserDefaults] valueForKey:UserPassword] andHandle:^(NSString *error, NSDictionary *result) {
            
        }];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
