//
//  Match.h
//  Monster
//
//  Created by Ryan Renna on 10-05-16.
#import "MTeam.h"
#import "MMap.h"

typedef enum
{
	InProgress,
	Completed
}MatchState;
typedef enum
{
	PlayerControl,
	CPUControl,
	NoControl
}ControlState;

@interface MMatch : NSObject {
	int round;
	int maxRound;
	BOOL turnComplete;
	MatchState matchstate;
	ControlState controlstate;
	MTeam *currentTeam;
	NSMutableArray *teams;
	NSMutableArray *teamTurnQueue;
	MMap *map;
}
@property (readonly) int round;
@property (readonly) int maxRound;
@property (readwrite) BOOL turnComplete;
@property (readonly) MatchState matchstate;
@property (readonly) ControlState controlstate;
@property (readonly) MTeam *currentTeam;
@property (retain,readonly) NSArray *teams;
@property (retain,readonly) MMap *map;
-(id)initWithMaxRoundAndTeams:(int)pMaxRound : (MTeam*) firstTeam, ...;
-(void)pushTeam :(MTeam*)pTeam;
-(MTeam*)popTeam;
-(BOOL)isQueuedTeam;
-(void)completeTurn;
-(void)begin;
-(void)nextRound;
-(void)nextTurn;
@end
