//
//  MainViewController.m
//  EvO
//
//  Created by macmini on 07/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "Score.h"
#import "/usr/include/sqlite3.h"
#import "EvOAppDelegate.h"
#import "NSCallScore.h"

#define left_right 1
#define right_left 2
#define top_bottom 3
#define bottom_top 4
#define max_gauge 212


@interface MainViewController (PrivateMethods)

-(void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(NSPiece *)theView;
-(void)animateView:(NSPiece *)theView toPosition:(CGPoint) thePosition;
-(void) dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event;
-(void) dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position;
-(void) dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position;
-(void)rotateFirstTouchAtPoint:(CGPoint)touchPoint forView:(NSPiece *)theView;
-(void)testrowscol;
-(void) setalldifferents;
-(NSPiece *)Getpiecefromx:(NSInteger)x y:(NSInteger)y;
@end 

@implementation MainViewController
@synthesize is_moving;
@synthesize animationinprogress;
@synthesize go_next_level;
@synthesize _pause;
@synthesize evolution_number;
@synthesize _playedfor;
@synthesize imagenumber;
-(void)NewGame
{
	evo_little_image.hidden=YES;
	game_over_image.hidden=YES;
	alevel=0;
	CGRect arect;
	arect = agauge.frame;
	arect.size.width=0;
	agauge.frame=arect;
	self.animationinprogress=0;
	self.evolution_number=0;
	is_gameover=NO;
	mutation_counter=0;
	self.is_moving=NO;
	tipo=1;
	points=0;
	is_gameover=NO;
	mutation_counter=0;
	[self increaselevel];
	alabelcurrentPoint.text =[NSString stringWithFormat:@"%d",0] ;
	alabeltotalPoints.text =[NSString stringWithFormat:@"%d",0] ;
	
}

-(void)showscoresss:obj
{
	game_over_image.hidden=YES;

	Score* atempscore = 	(Score*)[arrayscore objectAtIndex:9];
	if (points > atempscore.puntos)
	{
		CGRect  arect = HighScoreView.frame;
		arect.origin.x=5;
		arect.origin.y=70;
		HighScoreView.frame = arect;
		
		[self.view  addSubview: HighScoreView];
		label_score_add.text = [NSString stringWithFormat:@"%d",points];
	}
	else
	{
		
		asegmentedcontrol.tintColor= [UIColor blackColor];
		asegmentedcontrol.selectedSegmentIndex = 0;
		[self loadScoresLocal];
		[HighScoreView removeFromSuperview];
		
		[self.view addSubview:gamehigh];
		
		
	}
	
}

-(void)workOnBackground:(BOOL)background
{
	self.view.userInteractionEnabled = !background;
	if (background)
	{
		viewfetch.hidden=NO;
		[aprogress startAnimating];
	}
	else
	{
		[aprogress stopAnimating];
		viewfetch.hidden=YES;
	}
}



- (IBAction)segmentAction:(id)sender
{
	if ([sender selectedSegmentIndex]==1)
	{
		[self workOnBackground:YES];
		[self performSelectorInBackground:@selector(saving:)  withObject:nil];
	}
	else
	{
		[self loadScoresLocal];
	}
}


 
 -(void)saving:aobj
 {
	 NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
	 sleep(.3);
		[NSCallScore callGetscore:arrayscoreRemote];
		[self workOnBackground:NO];
		[self loadScoresRemote];
	 sleep(.3);
	 [autoreleasepool release];
 }
 
 

 
 






-(void) endLevel4
{
	evo_little_image.hidden=NO;

}


-(void)gameover
{
	if (!is_gameover)
	{
		game_over_image.hidden=NO;
		asegmentedcontrol.selectedSegmentIndex = 0;
		
		[self loadScoresLocal];
		is_gameover=YES;
		if (aswitch.on)
			[game_over_sound play];
		
		atimerHidenNextLevel = [ [NSTimer scheduledTimerWithTimeInterval: 2.0
																  target:self
																selector:@selector(showscoresss:)
																userInfo:nil
																 repeats:NO]
								retain
								];	
		
		
	};
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==1)
	{
		exit(1);
	}
	else
	{
		[gamehigh removeFromSuperview];
		[self NewGame];
	}
}


-(void)hidenextlevel:obj
{
	next_level_imageView.hidden=YES;
}




-(void)increaselevel
{
	if (alevel!=0)
	{
		next_level_imageView.hidden=NO;
		atimerHidenNextLevel = [ [NSTimer scheduledTimerWithTimeInterval: 2
																  target:self
																selector:@selector(hidenextlevel:)
																userInfo:nil
																 repeats:NO]
								retain
								];	
		
	};
	
	

	if (aswitch.on)
		[next_level_sound play];
	
	alevel++;
	alabellevel.text = [NSString stringWithFormat:@"%d",alevel];
	mutation_counter=0;
	NSPiece *apiece;
	for (int _x =0 ; _x<16 ; _x++)
	{
		apiece= [aarray objectAtIndex:_x];
		[apiece changeimage:1];
	}
	for (int _x =0 ; _x<16 ; _x++)
	{
		apiece= [aarray objectAtIndex:_x];
		[apiece changeimage:1];
	}
	CGRect arect;
	arect = agauge.frame;
	arect.size.width=0;
	agauge.frame=arect;
	mutation_counter=0;
	[self setalldifferents];
	self.evolution_number=0;
	self._playedfor=NO;
	points=points+500;
	if (alevel==4)
	{
		is_gameover=YES;
		[self endLevel4];
	}

	
}


// this method is to mutate to the star.
-(void)Mutateone
{
	NSPiece * apiecetomutate;
	double r = (   (double)rand() / ((double)(RAND_MAX)+(double)(1)) );
	NSInteger arandom = 16*r;
	apiecetomutate= [aarray objectAtIndex:arandom];
	while (apiecetomutate.piece_type==0)
	{
		r = (   (double)rand() / ((double)(RAND_MAX)+(double)(1)) );
		arandom = 16*r;
		apiecetomutate= [aarray objectAtIndex:arandom];
	}
	[apiecetomutate changeimage:0];
	if (aswitch.on)
		[mutation_sound play];
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

	CGRect arect;
	arect = agauge.frame;
	arect.size.width=0;
	agauge.frame=arect;
	self._playedfor=NO;

	return;
}

//this method is to get the time to mutate a piece in each level
-(NSInteger)gettimerfromlevel
{
 NSInteger salida=20;
	
 if (difficoult==0)
 {
	switch (alevel) {
		case 1:
			salida=20;
			break;
		case 2:
			salida=15;
			break;
		case 3:
			salida=10;
			break;
		case 4:
			salida=7;
			break;
		case 5:
			salida=7;
			break;
		case 6:
			salida=7;
			break;
		case 7:
		case 8:
		case 9:
			salida=7;
			break;
			
		case 10:
		case 11:
		case 12:
			salida=7;
			break;
		case 13:
			salida=7;
			break;
		case 14:
			salida=7;
			break;
		case 15:
			salida=7;
			break;
			
		default:
			salida=6;
			break;
	}
 }
	if (difficoult==1)
	{
		switch (alevel) {
			case 1:
				salida=20;
				break;
			case 2:
				salida=15;
				break;
			case 3:
				salida=10;
				break;
			case 4:
				salida=7;
				break;
			case 5:
				salida=7;
				break;
			case 6:
				salida=7;
				break;
			case 7:
			case 8:
			case 9:
				salida=7;
				break;
				
			case 10:
			case 11:
			case 12:
				salida=7;
				break;
			case 13:
				salida=7;
				break;
			case 14:
				salida=7;
				break;
			case 15:
				salida=7;
				break;
				
			default:
				salida=6;
				break;
		}
	}
	if (difficoult==2)
	{
		switch (alevel) {
			case 1:
				salida=20;
				break;
			case 2:
				salida=15;
				break;
			case 3:
				salida=10;
				break;
			case 4:
				salida=7;
				break;
			case 5:
				salida=7;
				break;
			case 6:
				salida=7;
				break;
			case 7:
			case 8:
			case 9:
				salida=7;
				break;
				
			case 10:
			case 11:
			case 12:
				salida=7;
				break;
			case 13:
				salida=7;
				break;
			case 14:
				salida=7;
				break;
			case 15:
				salida=7;
				break;
				
			default:
				salida=6;
				break;
		}
	}	
	
	
	
	return salida;
}

//this method execute every 1 seconds
-(void) MutationTimer:(id)obj
{
	if (self._pause==YES)
	{
		return;
	}
	if (is_gameover)
	{
		return;
	}
	NSPiece *piece0;
	NSPiece *piece1;
	NSPiece *piece2;
	NSPiece *piece3;
	NSInteger atimer = [self gettimerfromlevel];
	
	if (mutation_counter+6>(atimer))
	{
		if 	(self._playedfor==NO)
		{	
			self._playedfor=YES;
			if (aswitch.on)
			{
				[timing_sound play];
			}
		}
	};
	
	mutation_counter++;
	if (mutation_counter==atimer)
	{
		mutation_counter=0;
		[self Mutateone];
		for (int _y =0 ; _y<4 ; _y++)
		{
			piece0 = [self Getpiecefromx:0 y:_y];
			piece1 = [self Getpiecefromx:1 y:_y];
			piece2 = [self Getpiecefromx:2 y:_y];
			piece3 = [self Getpiecefromx:3 y:_y];
			if ((piece0.elcolor==[UIColor blackColor]) && (piece1.elcolor==[UIColor blackColor]) && 
				(piece2.elcolor==[UIColor blackColor]) && (piece3.elcolor==[UIColor blackColor]))
			{
				[self gameover];
			}
		}
		for (int _x =0 ; _x <4 ; _x ++)
		{
			piece0 = [self Getpiecefromx:_x y:0];
			piece1 = [self Getpiecefromx:_x y:1];
			piece2 = [self Getpiecefromx:_x y:2];
			piece3 = [self Getpiecefromx:_x y:3];
			if ((piece0.elcolor==[UIColor blackColor]) && (piece1.elcolor==[UIColor blackColor]) && 
				(piece2.elcolor==[UIColor blackColor]) && (piece3.elcolor==[UIColor blackColor]))
			{
				[self gameover];
			}
		}			
	}
	else
	{
		CGRect arect;
		arect = agauge.frame;
		arect.size.height=11;
		arect.size.width=(max_gauge /atimer+1)*mutation_counter;
		agauge.frame=arect;
	}
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		arrayscore = [[NSMutableArray alloc] init];
		arrayscoreRemote = [[NSMutableArray alloc] init];
		self._pause=YES;
		aarray = [[NSMutableArray alloc] init];
		self.is_moving=NO;
		tipo=1;
		points=0;
		is_gameover=NO;
		mutation_counter=0;
		self.imagenumber=0;
		game_over_sound = [[AudioFX alloc] initWithPath:@"lose.caf"] ;
		move_pieces_sound = [[AudioFX alloc] initWithPath:@"click.caf"] ;
		next_level_sound = [[AudioFX alloc] initWithPath:@"x2.caf"] ;
		start_sound = [[AudioFX alloc] initWithPath:@"slide.caf"] ;
		mutation_sound = [[AudioFX alloc] initWithPath:@"tone.caf"] ;
		firsttimeintro=NO;

		arrayplay = [[NSMutableArray alloc] init];
		AudioFX *evolution_sound;

		/*
		evolution_sound = [[AudioFX alloc] initWithPath:@"1.caf"] ;
		[arrayplay addObject: evolution_sound];

		evolution_sound = [[AudioFX alloc] initWithPath:@"02k1.caf"] ;
		[arrayplay addObject: evolution_sound];
		
		evolution_sound = [[AudioFX alloc] initWithPath:@"03k1.caf"] ;
		[arrayplay addObject: evolution_sound];
	
		evolution_sound = [[AudioFX alloc] initWithPath:@"04k1.caf"] ;
		[arrayplay addObject: evolution_sound];

		evolution_sound = [[AudioFX alloc] initWithPath:@"05k1.caf"] ;
		[arrayplay addObject: evolution_sound];

		evolution_sound = [[AudioFX alloc] initWithPath:@"06k1.caf"] ;
		[arrayplay addObject: evolution_sound];
		 */
	
		timing_sound = [[AudioFX alloc] initWithPath:@"ticking_1.caf"] ;
		next_level_imageView.hidden=YES;
		
		alevel=1;
		CGRect arect;
		arect = agauge.frame;
		arect.size.width=0;
		agauge.frame=arect;
		self.animationinprogress=0;
		self.evolution_number=0;

    }
    return self;
}

-(void) initinstructions
{
	/*
	atextInstructions.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@",
	@"1.   The object of the game is to 'Evolve' the shapes(in ascending order: square, circle, triangle, cross) from the basic square to the more advanced cross and keep moveing on thru the next levels.",
	@"2.   The basic 'square' shapes fill the start screen board. One must join three squares of the same color to achieve an evolution to the next shape: 'circle'.",
	@"3.   The first way to create an evolution is byJoining three colors together , regardless of the objects shape",
	@"4.   The second way in which one may cause an evolution is by joining three of the higher level shapes together (any of the three: cirlces, triangles and/or cross'). For example: three circles regardless of thier color will evolve to two cirlces and one triangle.",
	@"5.   During each level 'mutation' shapes will begin to occur based on a timer and the players skill.  If at any time four mutations are joined together the game is over."];
	
	*/
	
	
	
	
}


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
//	[self initinstructions];
	[self.view addSubview:gameoptions];
	NSPiece *apiece;
	CGRect arect;
	NSInteger arandom;
	srand ( time(NULL) );
	double r;
	for (int i=0;i<16;i++)
	{
		r = (   (double)rand() / ((double)(RAND_MAX)+(double)(1)) );
		arandom = 4*r+1;
		apiece = [[NSPiece alloc] initWithType:(arandom) apieceID:i];
		arect = apiece.frame;
		arect.origin.x = 56* ((i %4))+3;
		arect.origin.y=56 * (i/4)+5;
		
		apoints[i %4][i/4].x = arect.origin.x + board.frame.origin.x;
		apoints[i %4][i/4].y = arect.origin.y + board.frame.origin.y;
		apiece.row = (i %4);
		apiece.col = (i /4);
		
		[board addSubview:apiece];
		apiece.frame = arect;
		[aarray addObject:apiece];
		[apiece release];
	}
	[self setalldifferents];
	[super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self._pause==YES)
	{
		return;
	}
    NSInteger numTaps = [[touches anyObject] tapCount];
	if(numTaps >= 2) 
	{
		if (numTaps == 2) 
		{
			for (UITouch *touch in touches) 
			{
				CGPoint apoint =[touch locationInView:self.view];
				if (apoint.y > 420)
				{
					if (self._pause==NO)
					{
						self._pause=YES;
						CGRect arect = aminimenu.frame;
						arect.origin.x=72;
						arect.origin.y=185;
						aminimenu.frame = arect;
						[self.view addSubview:aminimenu];
						break;
					}
				}
				
			}
//			mustRotate=YES;
		}
		else
		{
		//	mustRotate=NO;
		}
	} 
	else 
	{
		//mustRotate=NO;
	}
	NSInteger touchCount = 0;
	for (UITouch *touch in touches) {
		[self dispatchFirstTouchAtPoint:[touch locationInView:self.view] forEvent:nil];
		touchCount++;  
	}	
}
// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	NSInteger touchCount = 0;
	for (UITouch *touch in touches){
	 	[self dispatchTouchEvent:[touch view] toPosition:[touch locationInView:self.view]];
	    touchCount++;
	}
	
}
// Handles the end of a touch event.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches){
		[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self.view]];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	//	touchPhaseText.text = @"Phase: Touches cancelled";
    // Enumerates through all touch object
    for (UITouch *touch in touches){
		// Sends to the dispatch method, which will make sure the appropriate subview is acted upon
		[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self.view]];
	}
}


-(void) GetGLobalColRow
{
	//CG_EXTERN bool CGRectContainsPoint(CGRect rect, CGPoint point)
	CGRect  arect;
	int aux_y=0;
	int aux_x=0;
	
	for (int i=0; i< 4 ; i++)
	{
		arect.origin.y = apoints[0][i].y;
		arect.origin.x = 0;
		arect.size.height = 50;
		arect.size.width = 320;
		if (CGRectContainsPoint(arect, BeginPoint))
		{
			aux_y= i+1;
			break;
		}
	}
	Global_row = aux_y;
	for (int i=0; i< 4 ; i++)
	{
		arect.origin.y =0;
		arect.origin.x = apoints[i][0].x;
		arect.size.height = 480;
		arect.size.width = 50;
		if (CGRectContainsPoint(arect, BeginPoint))
		{
			aux_x= i+1;
			break;
		}
	}
	Global_col =aux_x;
	
}

-(void) dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event
{
	if (self._pause)
	{
		return;
	}
	// verificar que fila y que columna
	if (self.is_moving==NO)
	{
		//alabeldbg.text = [NSString stringWithFormat:@"(%.0f,%.0f)",touchPoint.x,touchPoint.y];
		BeginPoint=touchPoint;
		[self GetGLobalColRow];
	}
	else
	{
		BeginPoint.x=0;
		BeginPoint.y=0;
	}
	

	
}


-(void) dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position
{
	//alabeldbg.text =[NSString stringWithFormat:@"%@ - (%.0f,%.0f)",alabeldbg.text, position.x,position.y];
}
-(NSPiece *)Getpiecefromx:(NSInteger)x y:(NSInteger)y
{
	NSPiece *temppiece;
	NSInteger total;
	total = [aarray count];
	for (NSInteger i=0 ; i< total;i++)	
	{
		temppiece =	(NSPiece *) [aarray objectAtIndex:i];
		if( (temppiece.row==x) && (temppiece.col==y))
		{
			return  temppiece;
		}
	}		
	return nil;
	
}


 
-(NSPiece*) getLowestpos:(NSPiece*)apiece0 piece1:(NSPiece*)piece1 piece2:(NSPiece*)piece2 piece3:(NSPiece*)piece3
{
	if( piece3 ==nil)
	{
		if ((apiece0.shapetype) <= (piece1.shapetype))
		{
			if ((apiece0.shapetype) <= (piece2.shapetype))
			{
				return apiece0;
			}
			else
			{
				return piece2;
			}
		}
		else
		{
			if ((piece1.shapetype) <=(piece2.shapetype))
			{
				return  piece1;
			}
			else
			{
				return  piece2;
			
			}
		}
	}
	else
	{

	}
	return apiece0;
	
}

-(void)changeColor:(NSPiece*)piece0 piece1:(NSPiece*)piece1 piece2:(NSPiece*)piece2 piece3:(NSPiece*)piece3
{
	NSInteger arandom;
	double r;

	r= (   (double)rand() / ((double)(RAND_MAX)+(double)(1)) );
	arandom = 4*r;
	[piece0 changeimage:[piece0 getbasetype]+arandom];
	
	r= (   (double)rand() / ((double)(RAND_MAX)+(double)(1)) );
	arandom = 4*r;
	[piece1 changeimage:[piece1 getbasetype]+arandom];
	
	r= (   (double)rand() / ((double)(RAND_MAX)+(double)(1)) );
	arandom = 4*r;
	[piece2 changeimage:[piece2 getbasetype]+arandom];
	
	if (piece3!=nil)
	{
		r= (   (double)rand() / ((double)(RAND_MAX)+(double)(1)) );
		arandom = 4*r;
		[piece3 changeimage:[piece3 getbasetype]+arandom];
	}
	
	return;
}




-(void)getchangeImageRow:(NSPiece*)apiece0 piece1:(NSPiece*)piece1 piece2:(NSPiece*)piece2 piece3:(NSPiece*)piece3
{
// aca hay que buscar
// si son 3 piezas o 4 piezas
	NSPiece *auxpiece1=nil;
	NSPiece *auxpiece2=nil;;
	if (piece3!=nil)
	{
		for (int zzz=1;zzz<4;zzz++)
		{
			if (apiece0.shapetype==zzz)
			{
				if (auxpiece1==nil)
				{
					auxpiece1=apiece0;
				}
				else
				{
					if (auxpiece2==nil)
					{
						auxpiece2=apiece0;
					}
					else
					{
						break;
					}
				}
			}
			if (piece1.shapetype==zzz)
			{
				if (auxpiece1==nil)
				{
					auxpiece1=piece1;
				}
				else
				{
					if (auxpiece2==nil)
					{
						auxpiece2=piece1;
					}
					else
					{
						break;
					}
				}
				
			}
			if (piece2.shapetype==zzz)
			{
				if (auxpiece1==nil)
				{
					auxpiece1=piece2;
				}
				else
				{
					if (auxpiece2==nil)
					{
						auxpiece2=piece2;
					}
					else
					{
						break;
					}
				}
				
			}
			if (piece3.shapetype==zzz)
			{
				if (auxpiece1==nil)
				{
					auxpiece1=piece3;
				}
				else
				{
					if (auxpiece2==nil)
					{
						auxpiece2=piece3;
					}
					else
					{
						break;
					}
				}
			}
		}
		if (auxpiece1.shapetype ==4) 
		{
			auxpiece1.shapetype = 4; 
			
		}
		else
		{
			auxpiece1.shapetype = auxpiece1.shapetype+1; 
		}
		if (auxpiece2.shapetype ==4) 
		{
			auxpiece2.shapetype = 4; 
			
		}
		else
		{
			auxpiece2.shapetype = auxpiece2.shapetype+1; 
		}
		
/*
		if (aswitch.on)
		{
			AudioFX *evolution_sound;
			evolution_sound = [arrayplay objectAtIndex:(self.evolution_number%6)];
			self.evolution_number++;
			[evolution_sound play];
		}
		
		*/
		
	}
	else
	{
		NSPiece *auxpiece =  [self getLowestpos:apiece0 piece1:piece1 piece2:piece2 piece3:piece3];
		if (auxpiece.shapetype ==4) 
		{
			auxpiece.shapetype = 4; 
			
		}
		else
		{
			auxpiece.shapetype = auxpiece.shapetype+1; 
			/*
			if (aswitch.on)
			{
				AudioFX *evolution_sound;
				
				evolution_sound = [arrayplay objectAtIndex:(self.evolution_number%6)];
				self.evolution_number++;
				[evolution_sound play];
			}
			 */
			
		}
	}
	
	NSMutableArray *workingPieces;
	workingPieces = [[NSMutableArray alloc] init];
	
	[workingPieces addObject:apiece0];
	[workingPieces addObject:piece1];
	[workingPieces addObject:piece2];
	if  (piece3 != nil)
	{
		[workingPieces addObject:piece3];
	};
	
	[UIView beginAnimations:@"showlineUP" context:workingPieces];
	[UIView setAnimationDuration:0.30];
	
	
	CGAffineTransform transform = CGAffineTransformMakeScale(1.1, 1.1);
	for (int zz=0;zz< [workingPieces count];zz++)
	{
		((NSPiece*)[workingPieces objectAtIndex:zz]).transform= transform;
	}
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
	self.animationinprogress= self.animationinprogress +1;
	
}



-(NSUInteger)processlineShapeColor:(NSPiece*)piece0 piece1:(NSPiece*)piece1 piece2:(NSPiece*)piece2 piece3:(NSPiece*)piece3
{
	
	// comenzando de 0
	// verificar si son 4 iguales de color
	// verificar sin son 4 iguales de forma
	// verificar si son 3 iguales de color
	// verificar si son 3 iguales de forma
	//comenzando de 1
	// verificar si son 3 iguales de color
	// verificar si son 3 iguales de forma
	NSUInteger asalida;
	if (self.go_next_level==YES)
	{
		return 0;
	}
	
	if ((piece0.shapetype==4) && (piece1.shapetype==4) && (piece2.shapetype==4) && (piece3.shapetype==4))
	{
		self.go_next_level=YES;
		[UIView beginAnimations:@"NewLevel" context:nil];
		[UIView setAnimationDuration:0.30];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView commitAnimations];

		return 0;
	}
	
	
	if ((piece0.elcolor==[UIColor blackColor]) && (piece1.elcolor==[UIColor blackColor]) && 
		(piece2.elcolor==[UIColor blackColor]) && (piece3.elcolor==[UIColor blackColor]))
	{
		[self gameover];
		return 0;
	}
	
	NSUInteger salida=0;

	if( ((piece0.elcolor) == (piece1.elcolor)) && (piece0.elcolor!=[UIColor blackColor])) 
	{
		if ((piece1.elcolor) == (piece2.elcolor))
		{
			if ((piece2.elcolor) == (piece3.elcolor))
			{
				//0 =1 =2 =3 4 iguales color
				 asalida = ((piece0.shapetype * 10+(alevel*10))+ (piece1.shapetype * 10+(alevel*10)) + (piece2.shapetype * 10+(alevel*10)) + (piece3.shapetype * 10+(alevel*10)) );
				[self getchangeImageRow:piece0 piece1:piece1 piece2:piece2 piece3:piece3];
				return asalida;
			}
		}
	}
	
	if(( (piece0.shapetype) == (piece1.shapetype)) && ((piece0.shapetype!=1)&& (piece0.shapetype!=0) && (piece0.shapetype!=4) )) 
	{
		if ((piece1.shapetype) == (piece2.shapetype))
		{
			if ((piece2.shapetype) == (piece3.shapetype))
			{
				//0 =1 =2 =3 4 iguales forma
				asalida=  ((piece0.shapetype * 10+(alevel*10))+ (piece1.shapetype * 10+(alevel*10)) + (piece2.shapetype * 10+(alevel*10)) + (piece3.shapetype * 10+(alevel*10)) );
				[self getchangeImageRow:piece0 piece1:piece1 piece2:piece2 piece3:piece3];
				return asalida;
			}
		}
	}

	if( ((piece0.elcolor) == (piece1.elcolor)) && (piece0.elcolor!=[UIColor blackColor])) 
	{
		if ((piece1.elcolor) == (piece2.elcolor))
		{
			asalida =((piece0.shapetype * 10+(alevel*10))+ (piece1.shapetype * 10+(alevel*10)) + (piece2.shapetype * 10+(alevel*10))  );
			[self getchangeImageRow:piece0 piece1:piece1 piece2:piece2 piece3:nil];
			return asalida;

//			return 60;
		}
	}
	
	if(( (piece0.shapetype) == (piece1.shapetype)) && ((piece0.shapetype!=1)&& (piece0.shapetype!=0) && (piece0.shapetype!=4) )) 
	{
		if ((piece1.shapetype) == (piece2.shapetype))
		{
			asalida= ((piece0.shapetype * 10+(alevel*10))+ (piece1.shapetype * 10+(alevel*10)) + (piece2.shapetype * 10+(alevel*10))  );
			[self getchangeImageRow:piece0 piece1:piece1 piece2:piece2 piece3:nil];

			return asalida;
			//return 60;
		}
	}
	

	if (((piece1.elcolor) == (piece2.elcolor)) && (piece1.elcolor!=[UIColor blackColor]))
	{
		if ((piece2.elcolor) == (piece3.elcolor))
		{
			asalida= ((piece1.shapetype * 10+(alevel*10))+ (piece2.shapetype * 10+(alevel*10)) + (piece3.shapetype * 10+(alevel*10))  );
			[self getchangeImageRow:piece1 piece1:piece2 piece2:piece3 piece3:nil];
			return asalida;

//			return 60;
		}
	}
	
	if(((piece1.shapetype) == (piece2.shapetype))&& ((piece1.shapetype!=1)&&(piece1.shapetype!=0) && (piece1.shapetype!=4))) 
	{
		if ((piece2.shapetype) == (piece3.shapetype))
		{
			asalida= ((piece1.shapetype * 10+(alevel*10))+ (piece2.shapetype * 10+(alevel*10)) + (piece3.shapetype * 10+(alevel*10))  );
			[self getchangeImageRow:piece1 piece1:piece2 piece2:piece3 piece3:nil];
			return asalida;
			//return 60;
		}
	}		
	return salida;	
}

-(void)testrowscol
{
	NSPiece *apiece0;
	NSPiece *apiece1;
	NSPiece *apiece2;
	NSPiece *apiece3;
	NSUInteger salida=0;
	NSUInteger totalmove=0;
	totalmove=0;
	for (int _y =0 ; _y<4 ; _y++)
	{
		apiece0 = [self Getpiecefromx:0 y:_y];
		apiece1 = [self Getpiecefromx:1 y:_y];
		apiece2 = [self Getpiecefromx:2 y:_y];
		apiece3 = [self Getpiecefromx:3 y:_y];
		salida = [self processlineShapeColor:apiece0 piece1:apiece1 piece2:apiece2 piece3:apiece3];
		grandtotal= grandtotal+salida*10;

		alabelcurrentPoint.text =[NSString stringWithFormat:@"%d",grandtotal] ;
		points = points+salida*10;
		alabeltotalPoints.text =[NSString stringWithFormat:@"%d",points] ;
		if (salida != 0)
		{
			return;
		}
	}
	for (int _x =0 ; _x <4 ; _x ++)
	{
		apiece0 = [self Getpiecefromx:_x y:0];
		apiece1 = [self Getpiecefromx:_x y:1];
		apiece2 = [self Getpiecefromx:_x y:2];
		apiece3 = [self Getpiecefromx:_x y:3];
		salida = [self processlineShapeColor:apiece0 piece1:apiece1 piece2:apiece2 piece3:apiece3];
		grandtotal= grandtotal+salida*10;
		alabelcurrentPoint.text =[NSString stringWithFormat:@"%d",grandtotal] ;
		points = points+salida*10;
		alabeltotalPoints.text =[NSString stringWithFormat:@"%d",points] ;
		if (salida != 0)
		{
			return;
		}
	}
	self.is_moving=NO;
	self.evolution_number=0;
	grandtotal=0;

}



-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{

	
	
	if ([animationID isEqualToString:@"moving"])
	{	
		[self testrowscol];
		return;
	}
	
	if ([animationID isEqualToString:@"showlineUP"])
	{
		[UIView beginAnimations:@"showlineDOWN" context:context];
		[UIView setAnimationDuration:0.30];
		
		for (int zz=0;zz< [((NSMutableArray*) context) count];zz++)
		{
			((NSPiece*)[((NSMutableArray*) context) objectAtIndex:zz]).transform= CGAffineTransformIdentity;
		}
		
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView commitAnimations];
		
		return;
	}
	
	if ([animationID isEqualToString:@"showlineDOWN"])
	{
		NSPiece *piece0 = [((NSMutableArray*) context) objectAtIndex:0];
		NSPiece *piece1 = [((NSMutableArray*) context) objectAtIndex:1];
		NSPiece *piece2 = [((NSMutableArray*) context) objectAtIndex:2];
		NSPiece *piece3;
		if ([((NSMutableArray*) context) count]==4)
		{
			piece3 = [((NSMutableArray*) context) objectAtIndex:3];
		}
		else
		{
			piece3 =nil;
		}
		[self changeColor:piece0 piece1:piece1 piece2:piece2 piece3:piece3];
		[((NSMutableArray*) context) removeAllObjects];
		[((NSMutableArray*) context) release];
		self.animationinprogress= self.animationinprogress -1;
		if (self.go_next_level==NO)
		{
			[self testrowscol];
		}
		return;
	}
	
	
	if ([animationID isEqualToString:@"NewLevel"])
	{
		if (self.go_next_level==YES)
		{
			self.go_next_level=NO;
			[self increaselevel];
		}
		return;
	}	
	
	
}



-(BOOL)gettipomov
{
	NSInteger tipo_aux_v;
	NSInteger tipo_aux_h;
	if ((BeginPoint.x == EndPoint.x) && ( BeginPoint.y == EndPoint.y))
	{
		return NO;
	}
	else
	{
		NSInteger horiz = BeginPoint.x - EndPoint.x;
		NSInteger vert =  BeginPoint.y - EndPoint.y;
		if (horiz < 0)
		{
			tipo_aux_h = left_right;
		}
		else
		{
			tipo_aux_h = right_left;
		}
		if (vert < 0)
		{
			tipo_aux_v = top_bottom;
		}
		else
		{
			tipo_aux_v = bottom_top;
		}
		if (abs(horiz) > abs(vert))
		{
			tipo= tipo_aux_h;
		}
		else
		{
			tipo= tipo_aux_v;
		}
	}
	return YES;	
}



// mooving pieces

-(void) dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position
{   
	if (self._pause)
	{
		return;
	}
	if (is_gameover)
	{
		return;
	}
	if (self.is_moving==NO)
	{
		if ((BeginPoint.x==0) && (BeginPoint.y==0))
		{
			return;
		}
		EndPoint = position;
		if ([self gettipomov ]==NO)
		{
			return;
		}
		grandtotal=0;

		self.is_moving= YES;
		NSPiece * apiece0;
		NSPiece * apiece1;
		NSPiece * apiece2;
		NSPiece * apiece3;
		
		CGPoint apointfirst;
		[UIView beginAnimations:@"moving" context:NULL];
		[UIView setAnimationDuration:0.57];
		if (aswitch.on)
			[move_pieces_sound play];
		switch (tipo)
		{
			case left_right:
				apiece0 = [self Getpiecefromx:0 y:Global_row-1];
				apiece1 = [self Getpiecefromx:1 y:Global_row-1];
				apiece2 = [self Getpiecefromx:2 y:Global_row-1];
				apiece3 = [self Getpiecefromx:3 y:Global_row-1];
				
				
				apointfirst= apiece0.center ;
				apiece0.center = apiece1.center;
				apiece1.center = apiece2.center;
				apiece2.center = apiece3.center;
				apiece3.center = apointfirst;
				
				apiece0.row= 1;
				apiece1.row = 2;
				apiece2.row = 3;
				apiece3.row = 0;
				
				
				break;
			case right_left:
				apiece0 = [self Getpiecefromx:0 y:Global_row-1];
				apiece1 = [self Getpiecefromx:1 y:Global_row-1];
				apiece2 = [self Getpiecefromx:2 y:Global_row-1];
				apiece3 = [self Getpiecefromx:3 y:Global_row-1];
				
				apointfirst= apiece3.center ;
				apiece3.center = apiece2.center;
				apiece2.center = apiece1.center;
				apiece1.center = apiece0.center;
				apiece0.center = apointfirst;

				apiece0.row = 3;
				apiece1.row = 0;
				apiece2.row = 1;
				apiece3.row = 2;
				
				
				break;
			case top_bottom:
				apiece0 = [self Getpiecefromx:Global_col-1 y:0];
				apiece1 = [self Getpiecefromx:Global_col-1 y:1];
				apiece2 = [self Getpiecefromx:Global_col-1 y:2];
				apiece3 = [self Getpiecefromx:Global_col-1 y:3];
				
				
				apointfirst= apiece0.center ;
				apiece0.center = apiece1.center;
				apiece1.center = apiece2.center;
				apiece2.center = apiece3.center;
				apiece3.center = apointfirst;

				apiece0.col = 1;
				apiece1.col = 2;
				apiece2.col = 3;
				apiece3.col = 0;
				

				
				break;

			case bottom_top:
				apiece0 = [self Getpiecefromx:Global_col-1 y:0];
				apiece1 = [self Getpiecefromx:Global_col-1 y:1];
				apiece2 = [self Getpiecefromx:Global_col-1 y:2];
				apiece3 = [self Getpiecefromx:Global_col-1 y:3];
				
				apointfirst= apiece3.center ;
				apiece3.center = apiece2.center;
				apiece2.center = apiece1.center;
				apiece1.center = apiece0.center;
				apiece0.center = apointfirst;

				apiece0.col = 3;
				apiece1.col = 0;
				apiece2.col = 1;
				apiece3.col = 2;
				break;
		}
		
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView commitAnimations];

	}
	
}



-(IBAction) clickstart_first:(id)obj
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[gameoptions removeFromSuperview];
	[self.view addSubview:diffview];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	[UIView commitAnimations];

}

-(IBAction) click_return_diff:(id)obj
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[diffview removeFromSuperview];
	[self.view addSubview:gameoptions];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
	[UIView commitAnimations];
	
}



-(IBAction) clickstart:(id)obj
{
	UIButton *abuton;
	abuton = (UIButton *)obj;

	difficoult = abuton.tag;
	if (aswitch.on)
		[start_sound play];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[self.view addSubview:gameview];
	[diffview removeFromSuperview];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	[UIView commitAnimations];
	[atimermutation invalidate];
	atimermutation = [ [NSTimer scheduledTimerWithTimeInterval: 1
												target:self
											  selector:@selector(MutationTimer:)
											  userInfo:nil
											   repeats:YES]
			  retain
			  ];		
	self._pause=NO;
	self._playedfor=NO;
	[self NewGame];
}



-(IBAction) clickhigh:(id)obj
{
	asegmentedcontrol.selectedSegmentIndex = 0;

	[self loadScoresLocal];
	
	[self.view addSubview:gamehigh];
/*
	UIAlertView * backAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Menu", @"")
										   message:NSLocalizedString(@"High score", @"")
										  delegate:nil 
								 cancelButtonTitle:@"OK"
								 otherButtonTitles:nil];
	
	[backAlert show];
	[backAlert release];
*/	
}

-(IBAction) clickinstruction:(id)obj
{
	self.imagenumber=0;
	imageinstruction.image =[self getImageNamefrompos];  

	[self.view addSubview:gameinstructions];
	
	/*
	 UIAlertView * backAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Menu", @"")
	 message:NSLocalizedString(@"Instructions", @"")
	 delegate:nil 
	 cancelButtonTitle:@"OK"
	 otherButtonTitles:nil];
	 
	 [backAlert show];
	 [backAlert release];
	 */
	
}

	


-(IBAction) clickoptions:(id)obj
{
	[self.view addSubview:gameconfig];

	
	
	
	/*
	UIAlertView * backAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Menu", @"")
														 message:NSLocalizedString(@"Options", @"")
														delegate:nil 
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
	
	[backAlert show];
	[backAlert release];
	*/
}



-(void)getchangeFirst:(NSPiece*)apiece0 piece1:(NSPiece*)piece1 piece2:(NSPiece*)piece2 piece3:(NSPiece*)piece3
{
	[self changeColor:apiece0 piece1:piece1 piece2:piece2 piece3:piece3];
}

-(NSUInteger)processlineFirst:(NSPiece*)piece0 piece1:(NSPiece*)piece1 piece2:(NSPiece*)piece2 piece3:(NSPiece*)piece3
{
	NSUInteger salida=0;
	if( (piece0.elcolor) == (piece1.elcolor)) 
	{
		if ((piece1.elcolor) == (piece2.elcolor))
		{
			if ((piece2.elcolor) == (piece3.elcolor))
			{
				//0 =1 =2 =3
				[self getchangeFirst:piece0 piece1:piece1 piece2:piece2 piece3:piece3];
				salida=40*2;
			}
			else
			{
				[self getchangeFirst:piece0 piece1:piece1 piece2:piece2 piece3:nil];
				salida=30;
			}
		}
	}
	else
	{
		if ((piece1.elcolor) == (piece2.elcolor))
		{
			if ((piece2.elcolor) == (piece3.elcolor))
			{
				[self getchangeFirst:piece1 piece1:piece2 piece2:piece3 piece3:nil];
				salida=30;
			}
		}
	}
	return salida;	
}



-(void) setalldifferents
{
	NSPiece *apiece0;
	NSPiece *apiece1;
	NSPiece *apiece2;
	NSPiece *apiece3;
	BOOL continuar=TRUE;
	BOOL salida=NO;
	NSUInteger totalmove=0;
	//verify 
	totalmove=0;
	while (continuar)
	{
		continuar=NO;
		for (int _y =0 ; _y<4 ; _y++)
		{
			apiece0 = [self Getpiecefromx:0 y:_y];
			apiece1 = [self Getpiecefromx:1 y:_y];
			apiece2 = [self Getpiecefromx:2 y:_y];
			apiece3 = [self Getpiecefromx:3 y:_y];
			salida = [self processlineFirst:apiece0 piece1:apiece1 piece2:apiece2 piece3:apiece3];
			totalmove= totalmove+salida;
			if (salida!=0)
			{
				continuar=YES;
			}
		}
		for (int _x =0 ; _x <4 ; _x ++)
		{
			apiece0 = [self Getpiecefromx:_x y:0];
			apiece1 = [self Getpiecefromx:_x y:1];
			apiece2 = [self Getpiecefromx:_x y:2];
			apiece3 = [self Getpiecefromx:_x y:3];
			salida = [self processlineFirst:apiece0 piece1:apiece1 piece2:apiece2 piece3:apiece3];
			totalmove= totalmove+salida;
			
			if (salida!=0)
			{
				continuar=YES;
			}
		}
	}
}


-(IBAction) clickreturnCredits:(id)obj
{

	[creditsview removeFromSuperview];

}

-(IBAction) clickCredits:(id)obj
{
	[self.view addSubview:creditsview];

}



-(IBAction) clickreturnScore:(id)obj
{
	if (is_gameover)
	{
		[self.view addSubview: gameoptions];
		[gameview removeFromSuperview];
	}
	[gamehigh removeFromSuperview];
	
	
}
-(IBAction) clickreturninstructions:(id)obj
{
	[atimerHidenNextLevel invalidate];

	[gameinstructions removeFromSuperview];

}

-(IBAction) clickreturnOptions:(id)obj
{

	[gameconfig removeFromSuperview];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	return NO;
}


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
}


-(IBAction) clickvideo:(id)obj
{
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"evo-directions-movie-test.m4v"];
	

		
	NSURL *_movieURL = [NSURL fileURLWithPath:defaultDBPath];
	[self playMovieAtURL:_movieURL];
}

-(IBAction) clickMinimenu:(id)obj
{
	UIButton * abutonm = (UIButton *)obj;
	if (abutonm.tag==0)
	{
		[aminimenu removeFromSuperview];
		self._pause=NO;
		return;
	}
	if (abutonm.tag==1)
	{
		[aminimenu removeFromSuperview];
		[gameview removeFromSuperview];
		[self.view addSubview:gameoptions];

		return;
	}
	if (abutonm.tag==2)
	{
//		[aminimenu removeFromSuperview];
		[self.view addSubview:gameconfig];
	}
	
	
}


-(void)loadScoresRemote
{


		for (int i=0;i<10;i++)
		{
			Score* ascore;
			ascore= [[Score alloc] init];
			ascore.level=0;
			ascore.nombre=@"";
			ascore.puntos=0;
			[arrayscoreRemote addObject:ascore];
		}
	
	labelscoreN1.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:0]).puntos];
	labelscoreN2.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:1]).puntos];
	labelscoreN3.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:2]).puntos];
	labelscoreN4.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:3]).puntos];
	labelscoreN5.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:4]).puntos];
	labelscoreN6.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:5]).puntos];
	labelscoreN7.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:6]).puntos];
	labelscoreN8.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:7]).puntos];
	labelscoreN9.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:8]).puntos];
	labelscoreN10.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:9]).puntos];
	
	labelscore1.text = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:0]).nombre];
	labelscore2.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:1]).nombre];
	labelscore3.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:2]).nombre];
	labelscore4.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:3]).nombre];
	labelscore5.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:4]).nombre];
	labelscore6.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:5]).nombre];
	labelscore7.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:6]).nombre];
	labelscore8.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:7]).nombre];
	labelscore9.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:8]).nombre];
	labelscore10.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscoreRemote objectAtIndex:9]).nombre];
	
	
	labelscoreL1.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:0]).level];
	labelscoreL2.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:1]).level];
	labelscoreL3.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:2]).level];
	labelscoreL4.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:3]).level];
	labelscoreL5.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:4]).level];
	labelscoreL6.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:5]).level];
	labelscoreL7.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:6]).level];
	labelscoreL8.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:7]).level];
	labelscoreL9.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:8]).level];
	labelscoreL10.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscoreRemote objectAtIndex:9]).level];
	
	
}


-(void)loadScoresLocal
{
	[arrayscore removeAllObjects];
	[Score gethigh:arrayscore];
	
	labelscoreN1.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:0]).puntos];
	labelscoreN2.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:1]).puntos];
	labelscoreN3.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:2]).puntos];
	labelscoreN4.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:3]).puntos];
	labelscoreN5.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:4]).puntos];
	labelscoreN6.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:5]).puntos];
	labelscoreN7.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:6]).puntos];
	labelscoreN8.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:7]).puntos];
	labelscoreN9.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:8]).puntos];
	labelscoreN10.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:9]).puntos];

	labelscore1.text = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:0]).nombre];
	labelscore2.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:1]).nombre];
	labelscore3.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:2]).nombre];
	labelscore4.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:3]).nombre];
	labelscore5.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:4]).nombre];
	labelscore6.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:5]).nombre];
	labelscore7.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:6]).nombre];
	labelscore8.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:7]).nombre];
	labelscore9.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:8]).nombre];
	labelscore10.text  = [NSString stringWithFormat:@"%@", ((Score*)[arrayscore objectAtIndex:9]).nombre];
	

	labelscoreL1.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:0]).level];
	labelscoreL2.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:1]).level];
	labelscoreL3.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:2]).level];
	labelscoreL4.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:3]).level];
	labelscoreL5.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:4]).level];
	labelscoreL6.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:5]).level];
	labelscoreL7.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:6]).level];
	labelscoreL8.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:7]).level];
	labelscoreL9.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:8]).level];
	labelscoreL10.text= [NSString stringWithFormat:@"%d", ((Score*)[arrayscore objectAtIndex:9]).level];
	
	
	
	
	

}

-(IBAction) clickSaveScore:(id)obj
{
	[atextscore	endEditing:YES];
	Score * alastscore;
	alastscore=[[Score alloc] init];
	alastscore.nombre = atextscore.text;
	alastscore.puntos = points;
	alastscore.level= alevel;
	EvOAppDelegate *appDelegate = (EvOAppDelegate *)[[UIApplication sharedApplication] delegate];
	alastscore.database = appDelegate.database;
	[alastscore insert];
	[NSCallScore callSetScore:alevel points:points nombre:atextscore.text];
	asegmentedcontrol.selectedSegmentIndex = 0;

	[self loadScoresLocal];
	[HighScoreView removeFromSuperview];
	[self.view addSubview:gamehigh];
	
	/*
	UIAlertView * backAlert = [[UIAlertView alloc] initWithTitle:@"Game Over"
														 message:@"Do you want to play again?"
														delegate:self 
											   cancelButtonTitle:@"YES"
											   otherButtonTitles:nil];
	[backAlert addButtonWithTitle:@"NO"];
	
	[backAlert show];
	[backAlert release];
	*/

}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField	endEditing:YES];

	return YES;
}

-(UIImage*) getImageNamefrompos
{
	NSString *stringimage;
	switch (self.imagenumber) 
	{
		case 0:
			stringimage = @"instuctions_2.png";
			break;
		case 1:
			stringimage = @"instuctions_3.png";
			break;
		case 2:
			stringimage = @"instuctions_4.png";
			break;
		case 3:
			stringimage = @"instuctions_5.png";
			break;
			
	}
	return [UIImage imageNamed:stringimage];
}


-(IBAction) clickNextInst:(id)obj
{
	[atimerHidenNextLevel invalidate];
	if (self.imagenumber==3)
	{
		if (firsttimeintro)
		{
			firsttimeintro=NO;
			[gameinstructions removeFromSuperview];
		}
		return;
	}
	else
	{
		self.imagenumber=self.imagenumber+1;
	}
	
	imageinstruction.image =[self getImageNamefrompos];  

}

-(IBAction) clickPrevInst:(id)obj
{
	[atimerHidenNextLevel invalidate];

	if (self.imagenumber==0)
	{
		return;
	}
	else
	{
		self.imagenumber=self.imagenumber-1;
	}
	imageinstruction.image =[self getImageNamefrompos];  
	
	
}

-(IBAction) showinst:(id)obj
{
	if (self.imagenumber==3)
	{
		if (firsttimeintro)
		{
			firsttimeintro=NO;
			[atimerHidenNextLevel invalidate];

			[gameinstructions removeFromSuperview];
		}
		return;
	}
	else
	{
		self.imagenumber=self.imagenumber+1;
	}
	
	imageinstruction.image =[self getImageNamefrompos];  
	
}




-(void) setupfirst
{
	firsttimeintro=YES;
	next_level_imageView.hidden=YES;
	
	[self.view addSubview:gameinstructions];

	atimerHidenNextLevel = [ [NSTimer scheduledTimerWithTimeInterval: 3.0
	 target:self
	 selector:@selector(showinst:)
	 userInfo:nil
	 repeats:YES]
	 retain
	 ];	
	
}


-(IBAction) clickPurchase:(id)obj
{
	evo_little_image.hidden=YES;
    NSString *ccURL = [NSString stringWithString:@"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/browserRedirect?url=itms%253A%252F%252Fax.itunes.apple.com%252FWebObjects%252FMZStore.woa%252Fwa%252FviewSoftware%253Fid%253D296595375%2526mt%253D8"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:ccURL]];

}

-(IBAction) clickPurchaseReturn:(id)obj
{
	evo_little_image.hidden=YES;
	if (is_gameover)
	{
		[self.view addSubview: gameoptions];
		[gameview removeFromSuperview];
	}
	[gamehigh removeFromSuperview];
	
}


@end

