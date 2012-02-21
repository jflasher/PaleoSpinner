//
//  PaleoSpinnerAppDelegate.m
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PaleoSpinnerAppDelegate.h"

@implementation PaleoSpinnerAppDelegate

@synthesize window, tabBarController, lastAcceleration;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    	
	// Shake delegate
	[UIAccelerometer sharedAccelerometer].delegate = self;
	
	// Copy over the data files if they're not already in the user accessible dir
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath, *writeablePath;
	BOOL fileExists;
	
	// Protein file
	writeablePath = [documentsDirectory stringByAppendingPathComponent:@"protein.txt"];
	fileExists = [fileManager fileExistsAtPath:writeablePath];
	if (!fileExists) {
		filePath = [[NSBundle mainBundle] pathForResource:@"protein" ofType:@"txt"];
		[fileManager copyItemAtPath:filePath toPath:writeablePath error:&error];
	}
	// Fat file
	writeablePath = [documentsDirectory stringByAppendingPathComponent:@"fat.txt"];
	fileExists = [fileManager fileExistsAtPath:writeablePath];
	if (!fileExists) {
		filePath = [[NSBundle mainBundle] pathForResource:@"fat" ofType:@"txt"];
		[fileManager copyItemAtPath:filePath toPath:writeablePath error:&error];	
	}
	// Carb file
	writeablePath = [documentsDirectory stringByAppendingPathComponent:@"carb.txt"];
	fileExists = [fileManager fileExistsAtPath:writeablePath];
	if (!fileExists) {
		filePath = [[NSBundle mainBundle] pathForResource:@"carb" ofType:@"txt"];
		[fileManager copyItemAtPath:filePath toPath:writeablePath error:&error];	
	}
	// Flavor file
	writeablePath = [documentsDirectory stringByAppendingPathComponent:@"flavor.txt"];
	fileExists = [fileManager fileExistsAtPath:writeablePath];
	if (!fileExists) {
		filePath = [[NSBundle mainBundle] pathForResource:@"flavor" ofType:@"txt"];
		[fileManager copyItemAtPath:filePath toPath:writeablePath error:&error];	
	}	
	// yum file
	writeablePath = [documentsDirectory stringByAppendingPathComponent:@"yum.txt"];
	fileExists = [fileManager fileExistsAtPath:writeablePath];
	if (!fileExists) {
		filePath = [[NSBundle mainBundle] pathForResource:@"yum" ofType:@"txt"];
		[fileManager copyItemAtPath:filePath toPath:writeablePath error:&error];	
	}
	// Yuck file
	writeablePath = [documentsDirectory stringByAppendingPathComponent:@"yuck.txt"];
	fileExists = [fileManager fileExistsAtPath:writeablePath];
	if (!fileExists) {
		filePath = [[NSBundle mainBundle] pathForResource:@"yuck" ofType:@"txt"];
		[fileManager copyItemAtPath:filePath toPath:writeablePath error:&error];	
	}

	// Add the tab bar controller's view to the window and display.
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
    return YES;
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	if (self.lastAcceleration) {
		if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.7)) {
			histeresisExcited = YES;
			
			/* SHAKE DETECTED. DO HERE WHAT YOU WANT. */
			[[NSNotificationCenter defaultCenter] postNotificationName:@"shakeDetected" object:self userInfo:nil];
			
		} else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
			histeresisExcited = NO;
		}
	}
	
	self.lastAcceleration = acceleration;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
	[lastAcceleration release];
    [super dealloc];
}


@end
