//
//  MAction.m
//  Monster
//
//  Created by Ryan Renna on 10-05-17.

#import "MAction.h"
@implementation MAction
@synthesize moves;
-(id)initWithMove : (MMove*) pMove
{	
	if( (self=[super init] )) 
	{
		moves = [[NSMutableArray alloc] initWithObjects:pMove,nil];
	}
	return self;
}

-(id)initWithMoves : (MMove*) move , ...;
{
	if( (self=[super init] )) 
	{
		moves = [[NSMutableArray alloc] init];
		[moves addObject:move];
		va_list args;
		va_start(args, move);
		for (MMove *arg = move; arg != nil; arg = va_arg(args, MMove*))
		{
			[moves addObject:arg];
		}
		va_end(args);
		
	}
	return self;
}
-(id)initWithMoveArray : (NSArray*) pMoves
{
	if( (self=[super init] )) 
	{
		moves = [pMoves retain];
	}
	return self;
}
- (void)dealloc {
	[moves release];
	[super dealloc];
}
@end
