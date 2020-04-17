//
//  EvOAppDelegate.h
//  EvO
//
//  Created by macmini on 07/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "/usr/include/sqlite3.h"

@interface EvOAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MainViewController * aMainViewController;
	sqlite3 * database;
	BOOL _firsttime;
}
@property (nonatomic) sqlite3 * database;


@end

