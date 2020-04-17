//
//  NSPiece.h
//  EvO
//
//  Created by macmini on 10/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSPiece : UIImageView {
	NSInteger pieceID;
	NSInteger piece_type; 
	NSInteger row;
	NSInteger col;
	UIColor* elcolor;
	NSInteger shapetype;
}

- (id)initWithType:(NSInteger)typo apieceID:(NSInteger)apieceID;
- (void)changeimage:(NSInteger)typo;
-(NSInteger)getbasetype;

@property (nonatomic)  NSInteger pieceID;
@property (nonatomic)  NSInteger piece_type;
@property (nonatomic)  NSInteger shapetype;

@property (nonatomic)  NSInteger row;
@property (nonatomic)  NSInteger col;

@property (nonatomic,readonly)  UIColor* elcolor;





@end
