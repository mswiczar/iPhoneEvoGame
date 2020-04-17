//
//  NSPiece.m
//  EvO
//
//  Created by macmini on 10/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSPiece.h"


@implementation NSPiece
@synthesize pieceID;
@synthesize piece_type;
@synthesize row;
@synthesize col;
@synthesize elcolor;
@synthesize shapetype;


- (id)initWithType:(NSInteger)typo apieceID:(NSInteger)apieceID;
{
	NSString* imagename;
	switch (typo) {
		case 0:
			imagename = @"ICON_X_MUTATION.png";
			elcolor =[UIColor blackColor];
			shapetype=0;
			break;
		case 1:
			imagename = @"ICON_square_BLUE.png";
			elcolor =[UIColor blueColor];
			shapetype=1;
			break;
		case 2:
			imagename = @"ICON_square_GREEN.png";
			elcolor =[UIColor greenColor];
			shapetype=1;
			break;
		case 3:
			imagename = @"ICON_square_YELLOW.png";
			elcolor =[UIColor yellowColor];
			shapetype=1;
			break;
		case 4:
			imagename = @"ICON_square_RED.png";
			elcolor =[UIColor redColor];
			shapetype=1;
			break;
		case 5:
			imagename = @"ICON_circle_BLUE.png";
			elcolor =[UIColor blueColor];
			shapetype=2;
			break;
		case 6:
			imagename = @"ICON_circle_GREEN.png";
			elcolor =[UIColor greenColor];
			shapetype=2;
			break;
		case 7:
			imagename = @"ICON_circle_YELLOW.png";
			elcolor =[UIColor yellowColor];
			shapetype=2;
			break;
		case 8:
			imagename = @"ICON_circle_RED.png";
			elcolor =[UIColor redColor];
			shapetype=2;
			break;
		case 9:
			imagename = @"ICON_tri_BLUE.png";
			elcolor =[UIColor blueColor];
			shapetype=3;
			break;
		case 10:
			imagename = @"ICON_tri_GREEN.png";
			elcolor =[UIColor greenColor];
			shapetype=3;
			break;
		case 11:
			imagename = @"ICON_tri_YELLOW.png";
			elcolor =[UIColor yellowColor];
			shapetype=3;
			break;
		case 12:
			imagename = @"ICON_tri_RED.png";
			elcolor =[UIColor redColor];
			shapetype=3;
			break;
		case 13:
			imagename = @"ICON_cross_BLUE.png";
			elcolor =[UIColor blueColor];
			shapetype=4;
			break;
		case 14:
			imagename = @"ICON_cross_GREEN.png";
			elcolor =[UIColor greenColor];
			shapetype=4;
			break;
		case 15:
			imagename = @"ICON_cross_YELLOW.png";
			elcolor =[UIColor yellowColor];
			shapetype=4;
			break;
		case 16:
			imagename = @"ICON_cross_RED.png";
			elcolor =[UIColor redColor];
			shapetype=4;
			break;
			
		default:
			break;
	}

	if (self=[super initWithImage:[UIImage imageNamed:imagename]])
	{
		self.pieceID = apieceID;
		self.piece_type = typo;
		self.opaque=NO;
		self.autoresizingMask= UIViewAutoresizingNone;
		self.contentMode=UIViewContentModeCenter;
	}
	
	return self;
}

- (void)changeimage:(NSInteger)typo
{
	NSString* imagename;
	switch (typo) {
		case 0:
			imagename = @"ICON_X_MUTATION.png";
			elcolor =[UIColor blackColor];
			shapetype=0;
			break;
		case 1:
			imagename = @"ICON_square_BLUE.png";
			elcolor =[UIColor blueColor];
			shapetype=1;
			break;
		case 2:
			imagename = @"ICON_square_GREEN.png";
			elcolor =[UIColor greenColor];
			shapetype=1;
			break;
		case 3:
			imagename = @"ICON_square_YELLOW.png";
			elcolor =[UIColor yellowColor];
			shapetype=1;
			break;
		case 4:
			imagename = @"ICON_square_RED.png";
			shapetype=1;
			elcolor =[UIColor redColor];
			break;
		case 5:
			imagename = @"ICON_circle_BLUE.png";
			elcolor =[UIColor blueColor];
			shapetype=2;
			break;
		case 6:
			imagename = @"ICON_circle_GREEN.png";
			elcolor =[UIColor greenColor];
			shapetype=2;
			break;
		case 7:
			imagename = @"ICON_circle_YELLOW.png";
			elcolor =[UIColor yellowColor];
			shapetype=2;
			break;
		case 8:
			imagename = @"ICON_circle_RED.png";
			elcolor =[UIColor redColor];
			shapetype=2;
			break;
		case 9:
			imagename = @"ICON_tri_BLUE.png";
			elcolor =[UIColor blueColor];
			shapetype=3;
			break;
		case 10:
			imagename = @"ICON_tri_GREEN.png";
			elcolor =[UIColor greenColor];
			shapetype=3;
			
			break;
		case 11:
			imagename = @"ICON_tri_YELLOW.png";
			elcolor =[UIColor yellowColor];
			shapetype=3;
			break;
		case 12:
			imagename = @"ICON_tri_RED.png";
			elcolor =[UIColor redColor];
			shapetype=3;
			break;
		case 13:
			imagename = @"ICON_cross_BLUE.png";
			elcolor =[UIColor blueColor];
			shapetype=4;
			break;
		case 14:
			imagename = @"ICON_cross_GREEN.png";
			elcolor =[UIColor greenColor];
			shapetype=4;
			break;
		case 15:
			imagename = @"ICON_cross_YELLOW.png";
			elcolor =[UIColor yellowColor];
			shapetype=4;
			break;
		case 16:
			imagename = @"ICON_cross_RED.png";
			elcolor =[UIColor redColor];
			shapetype=4;
			break;
			
		default:
			break;
	}
	self.piece_type = typo;
//	UIImage *aux = self.image;
	self.image= [UIImage imageNamed:imagename];
/*	if (self.image!=aux)
		[aux release];
*/	
}

-(NSInteger)getbasetype
{
	if (shapetype==1)
	{
		return 1;
	}

	if (shapetype==2)
	{
		return 5;
	}

	if (shapetype==3)
	{
		return 9;
	}

	if (shapetype==4)
	{
		return 13;
	}
	return 0;
	
}




@end
