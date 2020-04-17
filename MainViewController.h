//
//  MainViewController.h
//  EvO
//
//  Created by macmini on 07/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioFX.h"
 #import <MediaPlayer/MediaPlayer.h>

#import "NSPiece.h"

@interface MainViewController : UIViewController {
	IBOutlet UIImageView *board;
	IBOutlet UIView *gameview;
	IBOutlet UIView *gameoptions;
	IBOutlet UIView *creditsview;
	IBOutlet UIView *diffview;
	IBOutlet UIView *viewfetch;
	IBOutlet UIActivityIndicatorView *aprogress;
	IBOutlet UISegmentedControl *asegmentedcontrol;
	
	
	NSMutableArray *aarray;
	CGPoint apoints[4][4];
	
	IBOutlet UILabel *alabeltotalPoints;
	IBOutlet UILabel *alabelcurrentPoint;
	IBOutlet UILabel *alabellevel;
	
	
	BOOL is_moving;
	NSInteger tipo;
	CGPoint BeginPoint;
	CGPoint EndPoint;
	NSInteger Global_row;
	NSInteger Global_col;
	
	NSUInteger points;
	
	
	AudioFX *game_over_sound;
	AudioFX *move_pieces_sound;
	AudioFX *next_level_sound;
	AudioFX *start_sound;
	AudioFX *mutation_sound;
	AudioFX *timing_sound;

	
	NSInteger mutation_counter;
	NSTimer *atimermutation;
	BOOL is_gameover;
	BOOL go_next_level;
	NSInteger alevel;
	IBOutlet UIImageView *agauge;
	NSUInteger animationinprogress;
	
	
	IBOutlet UIView *gameconfig;
	IBOutlet UIView *gameinstructions;
	IBOutlet UIView *gamehigh;
	IBOutlet UISwitch *aswitch;
	
	BOOL _pause;
	BOOL _playedfor;
	IBOutlet UITextView *atextInstructions;
	NSInteger evolution_number;
	NSMutableArray* arrayplay;

	IBOutlet UIView *aminimenu;
	
	
	IBOutlet UILabel *labelscore1;
	IBOutlet UILabel *labelscore2;
	IBOutlet UILabel *labelscore3;
	IBOutlet UILabel *labelscore4;
	IBOutlet UILabel *labelscore5;
	IBOutlet UILabel *labelscore6;
	IBOutlet UILabel *labelscore7;
	IBOutlet UILabel *labelscore8;
	IBOutlet UILabel *labelscore9;
	IBOutlet UILabel *labelscore10;

	IBOutlet UILabel *labelscoreN1;
	IBOutlet UILabel *labelscoreN2;
	IBOutlet UILabel *labelscoreN3;
	IBOutlet UILabel *labelscoreN4;
	IBOutlet UILabel *labelscoreN5;
	IBOutlet UILabel *labelscoreN6;
	IBOutlet UILabel *labelscoreN7;
	IBOutlet UILabel *labelscoreN8;
	IBOutlet UILabel *labelscoreN9;
	IBOutlet UILabel *labelscoreN10;

	
	IBOutlet UILabel *labelscoreL1;
	IBOutlet UILabel *labelscoreL2;
	IBOutlet UILabel *labelscoreL3;
	IBOutlet UILabel *labelscoreL4;
	IBOutlet UILabel *labelscoreL5;
	IBOutlet UILabel *labelscoreL6;
	IBOutlet UILabel *labelscoreL7;
	IBOutlet UILabel *labelscoreL8;
	IBOutlet UILabel *labelscoreL9;
	IBOutlet UILabel *labelscoreL10;
	
	
	
	
	IBOutlet UITextField * atextscore;
	IBOutlet UIView *HighScoreView;
	IBOutlet UILabel *label_score_add;
	NSMutableArray *arrayscore;	
	NSMutableArray *arrayscoreRemote;	
	
	NSInteger grandtotal;
	
	IBOutlet UIImageView *imageinstruction;
	NSInteger imagenumber;
	IBOutlet UIImageView *next_level_imageView;
	IBOutlet UIImageView *game_over_image;
	IBOutlet UIView *evo_little_image;
	

	NSTimer *atimerHidenNextLevel;
	BOOL firsttimeintro;
	NSInteger difficoult;
	
	
}
@property BOOL is_moving;
@property BOOL go_next_level;
@property BOOL _pause;
@property BOOL _playedfor;
@property NSInteger imagenumber;
@property NSInteger evolution_number;
-(IBAction) clickstart:(id)obj;
-(IBAction) clickhigh:(id)obj;
-(IBAction) clickinstruction:(id)obj;
-(IBAction) clickoptions:(id)obj;
@property  NSUInteger animationinprogress;

-(IBAction) clickreturnScore:(id)obj;
-(IBAction) clickreturninstructions:(id)obj;
-(IBAction) clickreturnOptions:(id)obj;
-(IBAction) clickvideo:(id)obj;


-(IBAction) clickMinimenu:(id)obj;
-(void)increaselevel;
-(void)loadScoresRemote;
-(void)loadScoresLocal;

-(IBAction) clickSaveScore:(id)obj;


-(IBAction) clickNextInst:(id)obj;
-(IBAction) clickPrevInst:(id)obj;
-(void) setupfirst;

-(UIImage*) getImageNamefrompos;

-(IBAction) clickPurchase:(id)obj;
-(IBAction) clickPurchaseReturn:(id)obj;


-(IBAction) clickreturnCredits:(id)obj;
-(IBAction) clickCredits:(id)obj;
-(IBAction) clickstart_first:(id)obj;

-(IBAction) click_return_diff:(id)obj;
- (IBAction)segmentAction:(id)sender;


@end
