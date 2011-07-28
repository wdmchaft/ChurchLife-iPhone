//
//  ChurchLifeAppDelegate.m
//  ChurchLife
//
//  Created by Jamey on 6/9/11.
//  Copyright 2011 ACS Technologies. All rights reserved.

#import "ChurchLifeAppDelegate.h"
#import "LoginViewController.h"
#import "AcsLink.h"

@implementation ChurchLifeAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    //load from preferences
    NSString *filePath = [self dataFilePath];
    BOOL loggedIn = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
        if ([array count] == 3)
        {
            NSString *userName = [array objectAtIndex:0];
            NSString *siteNumber;
            NSObject *object = [array objectAtIndex:1];
            if ([object isKindOfClass:[NSString class]])          
                siteNumber = [array objectAtIndex:1];
            else if ([object isKindOfClass:[NSNumber class]])
                siteNumber = [[array objectAtIndex:1] stringValue];
            NSString *password = [array objectAtIndex:2];
            
            loggedIn = [AcsLink LoginBySite:[siteNumber integerValue] userName:userName password:password];
        }
        else //file not in correct format. delete it.
        {
            [self deletePreferences];
        }
    };
    
    if (!loggedIn)
    {
        [self showLoginForm];
    }
    
    return YES;
}

- (void)showLoginForm
{
    //reset navigation controllers
    for (int i = 0; i < [self.tabBarController.viewControllers count]; i++)
    {
        UINavigationController *nav = (UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:i];
        [nav popToRootViewControllerAnimated:NO];
    }    
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [loginViewController release];
    [self.tabBarController presentModalViewController:navigationController animated:true]; 
    [navigationController release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:dataFile];
}

- (void)deletePreferences
{
    NSString *filePath = [self dataFilePath];
    NSError *error;
    if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);  
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
