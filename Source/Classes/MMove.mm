//  MMove.m
//  Monster
//
//  Created by Ryan Renna on 10-05-17.

#import "MMove.h"

@implementation MMove
@synthesize sourcePosition;
@synthesize destinationPosition;
@synthesize skill;
-(id)init:(Vertex) pSourcePosition : (Vertex) pDestinationPosition : (MSkill*) pSkill
{
	if( (self=[super init] )) {
	sourcePosition = pSourcePosition;
    destinationPosition = pDestinationPosition;
	skill = pSkill;
	}
	return self;
}
-(void)dealloc
{
	[super dealloc];
}
@end
