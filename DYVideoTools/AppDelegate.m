//
//  AppDelegate.m
//  DYVideoTools
//
//  Created by qiyun on 16/8/25.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "AppDelegate.h"
#import "DYUHomeViewController.h"
#import "DYUHomeTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*
    UINavigationController *navi = [self customCreateNaviController:[[DYUHomeViewController alloc] init]
                                                          setVCTitle:@"douyu.tv.com"
                                                            setImage:[UIImage imageNamed:@"btn_camera_done_a"]
                                                     setSeletedImage:[UIImage imageNamed:@"btn_camera_done_b"]];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    [tabBarController setViewControllers:@[navi] animated:YES];
    tabBarController.selectedViewController = navi;
     */
    
    
    DYUHomeTabBarViewController *tabBarVC = [[DYUHomeTabBarViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
    
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyWindow];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    return YES;
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


- (UINavigationController *)customCreateNaviController:(UIViewController *)vc
                                            setVCTitle:(NSString *)title
                                              setImage:(UIImage *)image
                                       setSeletedImage:(UIImage *)seletedImage{
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    
    //HelveticaNeue-Bold
    [navi.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont fontWithName:@"Zapfino" size:19.0f],
                                                  NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    navi.navigationBar.barTintColor     = [UIColor blackColor];
    navi.navigationBar.barStyle         = UIStatusBarStyleDefault;
    
    //设置item文字颜色
    navi.navigationBar.tintColor = [UIColor whiteColor];
    [navi preferredStatusBarStyle];
    seletedImage = [seletedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc setTitle:title];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title
                                                       image:image
                                               selectedImage:seletedImage];
    
    //工具栏按钮颜色
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}
                        forState:UIControlStateSelected];
    
    [navi setTabBarItem:item];
    
    return navi;
}

@end
