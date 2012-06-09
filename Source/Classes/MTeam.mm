//  team.m
//  Monster
//
//  Created by Ryan Renna on 10-05-24.

#import "MTeam.h"

@implementation MTeam
@synthesize controlled;
@synthesize mainEntity;
-(id)initWithColor:(UIColor*) pColor isPlayerControlled:(BOOL)pControlled
{
	if( (self=[super init] )) {
		color = [pColor retain];
		controlled = pControlled;
		mainEntity = nil;
		[color retain];
	}
	return self;
}
-(void)setMainEntity:(MEntity*) pEntity
{
	mainEntity = [pEntity retain];
}
-(void)dealloc
{
	[mainEntity release];
	[color release];
	[super dealloc];
}
@end
