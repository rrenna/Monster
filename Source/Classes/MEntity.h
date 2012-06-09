//
//  MEntity.h
//  Monster
//
//  Created by Ryan Renna on 10-05-08.

#import "MObject.h"
#import "MVertexUtil.h"
#import "MPersona.h"
#import "Map.h"
#import "MMove.h"
#import "MAction.h"
#import "MTeam.h"
#import "MMessage.h"
#import "Box2D.h"
#import "MSettings.h"

@class MProjectileManager;
@class UnitLayer;

typedef enum
{
	idle,
	melee,
	moving,
	rotating,
	range
}	ActivityState;

@interface MEntity : MObject 
{
	MTeam *team;
	ActivityState activityState;
	float health;
}
@property (retain,readonly) MTeam *team;
@property (readonly) ActivityState activityState;
@property (readonly) float health;

-(id) initWithName: (NSString*) pName andPosition: (Vertex) pPosition andTeam:(MTeam*)pTeam;
-(CGRect) rect;

-(void) sendMessage : (MMessage*) message;
-(void) update;
-(void)performTransformation : (CCAction*) pOffset;
-(void)performDamage : (NSNumber*) pDamage withForce: (CGPoint) pForce;
-(void)performSpriteChange : (NSString*) pSpriteName;
-(void)performShake;
-(void)performShakeWithForce : (CGPoint) pForce;
@end
