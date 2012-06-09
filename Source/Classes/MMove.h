//
//  Move.h
//  Monster
//
//  Created by Ryan Renna on 10-05-17.
#import "MVertexUtil.h"
#import "MSkill.h"

typedef enum
{
	Movement,
	MeleeAttack,
	RangedAttack,
	Defensive
}MoveType;

@interface MMove : NSObject {
	Vertex sourcePosition;
	Vertex destinationPosition;
	MSkill *skill;
}
@property (readonly) Vertex sourcePosition;
@property (readonly) Vertex destinationPosition;
@property (readonly) MSkill *skill;
-(id)init:(Vertex) pSourcePosition : (Vertex) pDestinationPosition : (MSkill*) pSkill;
@end
