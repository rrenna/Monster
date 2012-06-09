//  Unit.h
//  Monster
//
//  Created by Ryan Renna on 10-05-25.

#import "MProjectileManager.h"
#import "MEntityManager.h"
#import "MProjectileManager.h"
#import "MEntity.h"
#import "MProjectile.h"
#import "MAStarSearch.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface MUnit : MEntity {

	int moves;
	BOOL hasQueuedMoves;
	MAction *nextAction;
	MPersona *persona;
}
@property (readonly) int moves;
@property (retain,readonly) MAction *nextAction;
@property (retain,readonly) MPersona *persona;
@property (readonly) BOOL hasQueuedMoves;

-(NSMutableArray*)  getActions: (MMap*) map;
-(void)performQueuedAction;
-(void)performAction : (MAction*) action;
-(void)performMove : (MMove*) move;
-(void)performMovement :(MMove*) pMove;
-(void)performMeleeAttack :(MMove*) pMove;
-(void)performRangeAttack :(MMove*) pMove;
-(void)queueAction : (MAction*) pAction;
-(void)replenishMoves;
-(void)setAnimation;
-(void)setActivityState : (NSNumber*)pState;
@end
