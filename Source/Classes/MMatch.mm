//
//  Match.m
//  Monster
//
//  Created by Ryan Renna on 10-05-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MMatch.h"

@implementation MMatch
@synthesize round;
@synthesize turnComplete;
@synthesize maxRound;
@synthesize matchstate;
@synthesize controlstate;
@synthesize currentTeam;
@synthesize teams;
@synthesize map;
-(id)initWithMaxRoundAndTeams:(int)pMaxRound : (MTeam*) firstTeam, ...;
{
	if( (self=[super init] )) 
	{
		maxRound = pMaxRound;
		teams = [[NSMutableArray alloc] initWithCapacity:4];
		map = [[MMap alloc] init];
		teamTurnQueue = [[NSMutableArray alloc] initWithCapacity:4];
		va_list args;
		va_start(args, firstTeam);
		for (MTeam *arg = firstTeam; arg != nil; arg = va_arg(args, MTeam*))
		{
			[teams addObject:arg];
			[self pushTeam:arg];
		}
		va_end(args);
	}
	return self;
}
-(void)dealloc
{
	[map release];
	[teams release];
	[teamTurnQueue release];
	[super dealloc];
}
-(void)pushTeam :(MTeam*)pTeam
{
	[teamTurnQueue insertObject:pTeam atIndex:0];
}
-(MTeam*)popTeam
{
	MTeam *team = [teamTurnQueue lastObject];
	[teamTurnQueue removeLastObject];
	return team;
}
-(void)completeTurn
{
	turnComplete = YES;
}
-(void) nextTeam
{
	currentTeam = [self popTeam];
	turnComplete = NO;
	//Sets controlstate based on the team being a CPU team or not
	if([currentTeam controlled] == YES)
	{
		controlstate = PlayerControl;
	}
	else 
	{
		controlstate = CPUControl;
	}
}
-(BOOL)isQueuedTeam
{
	if([teamTurnQueue count] > 0)
	{
		return YES;
	}
	else {
		return NO;
	}
}
-(void)begin
{
	round = 1;
	turnComplete = NO;
	matchstate = InProgress;
	controlstate = NoControl;
}
-(void)nextTurn
{
	if([self isQueuedTeam] == YES)
	{
		[self nextTeam];
	}
	else 
	{
		[self nextRound];
	}

}
-(void)nextRound
{
	controlstate = NoControl;
	if(matchstate == InProgress)
	{
		if(round < maxRound)
		{
			round++;
			//Queue up the turns of each team
			for(MTeam *team in teams)
			{
				[self pushTeam:team];	
			}
		}
		else {
			matchstate = Completed;
		}

	}
	else 
	{
		//Nothing
	}
}
@end
