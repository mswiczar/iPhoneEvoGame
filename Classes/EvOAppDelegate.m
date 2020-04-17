//
//  EvOAppDelegate.m
//  EvO
//
//  Created by macmini on 07/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "EvOAppDelegate.h"
#import "Score.h"
#import "Beacon.h"

@implementation EvOAppDelegate

@synthesize database;


- (void)createEditableCopyOfDatabaseIfNeeded 
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"evo2.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    _firsttime=YES;
	if (success)
	{
		_firsttime = NO;
		return;
	}
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"evo2.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) 
	{
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


- (void)initializeDatabase
{
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"evo2.sql"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) 
	{
	} 
	else 
	{
		// Even though the open failed, call close to properly clean up resources.
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		// Additional error handling, as appropriate...
	}
}


-(void)startdatabase
{
	[self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];
}


/*

-(void)playMovieAtURL:(NSURL*)theURL 

{
	MPMoviePlayerController* theMovie;
	
	theMovie=[[MPMoviePlayerController alloc] initWithContentURL:theURL]; 
    theMovie.scalingMode=MPMovieScalingModeAspectFill; 
	theMovie.movieControlMode=YES
	;   // theMovie.userCanShowTransportControls=NO;
	
    // Register for the playback finished notification. 
	
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(myMovieFinishedCallback:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:theMovie]; 
	
    // Movie playback is asynchronous, so this method returns immediately. 
    [theMovie play]; 
} 

// When the movie is done,release the controller. 
-(void)myMovieFinishedCallback:(NSNotification*)aNotification 
{
    MPMoviePlayerController* theMovie=[aNotification object]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:theMovie]; 
	
    // Release the movie instance created in playMovieAtURL
    [theMovie release]; 
	[window addSubview:aMainViewController.view];

}


-(void)clickvideo
{
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"evo-directions-movie-test.m4v"];
	NSURL *_movieURL = [NSURL fileURLWithPath:defaultDBPath];
	[self playMovieAtURL:_movieURL];
}
*/




- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	NSString *applicationCode = @"6ed6d3b0fbe8af2c1a3fa6cddf756429";
	[Beacon initAndStartBeaconWithApplicationCode:applicationCode useCoreLocation:NO];
	
	[self startdatabase];
    // Override point for customization after application launch
//	[application setStatusBarHidden:YES animated:YES];
	aMainViewController= [[MainViewController alloc] initWithNibName:@"MainWindow" bundle:nil];

	//	aloginObject = [[NLogin alloc] initWithPrimaryKey:0 database:database];
	//	LoginViewController *alogin = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	//	UINavigationController * MainNavigationController = [[UINavigationController alloc] initWithRootViewController:alogin];
	
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	if (_firsttime)
	{
		[aMainViewController setupfirst];
	}
	//[aMainViewController setupfirst];
	[window addSubview:aMainViewController.view];

	[window makeKeyAndVisible];
	
}






- (void)applicationWillTerminate:(UIApplication *)application 
{
	[[Beacon shared] endBeacon];
	[Score finalizeStatements];
	sqlite3_close(database);
	
}





- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
