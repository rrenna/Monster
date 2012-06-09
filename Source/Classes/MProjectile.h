//  MProjectile.h
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-06.

#import "cocos2d.h"
#import "MObject.h"
#import "MTeam.h"

@class MProjectileManager;

@interface MProjectile : MObject 
{
	MTeam* team;
	int damage;
	CGPoint force;
}
@property (retain,readonly) MTeam *team;
@property (readonly) int damage;
@property (readonly) CGPoint force;
-(id)initWithName:(NSString*)pName andPosition:(Vertex)pPosition andForce: (CGPoint)pForce andDamage:(int) pDamage andTeam: (MTeam*) pTeam;
-(id)initWithName:(NSString*)pName andSprite:(NSString*)pSpriteName andPosition:(Vertex)pPosition andForce: (CGPoint)pForce andDamage:(int) pDamage andTeam: (MTeam*) pTeam;
@end
