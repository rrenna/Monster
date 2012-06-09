//
//  MProjectile.m
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-06.

#import "MProjectile.h"


@implementation MProjectile
@synthesize damage;
@synthesize force;
@synthesize team;

-(void)kill
{
	//This is to prevents subsequent calls to kill
	if(!clean)
	{
		[MProjectileManager remove:self];
	}
}

-(id)initWithName:(NSString*)pName andPosition:(Vertex)pPosition andForce: (CGPoint)pForce andDamage:(int) pDamage andTeam: (MTeam*) pTeam
{
	return [self initWithName:pName andSprite:@"Shell.png" andPosition:pPosition andForce:pForce andDamage:pDamage andTeam: pTeam];
}

-(id)initWithName:(NSString*)pName andSprite:(NSString*)pSpriteName andPosition:(Vertex)pPosition andForce: (CGPoint)pForce andDamage:(int) pDamage andTeam: (MTeam*) pTeam
{
	if((self = [super initWithName:pName]))
	{
		team = pTeam;
		sprite = [[CCSprite spriteWithFile:pSpriteName] retain];
		position = pPosition;
		CGPoint newPosition; newPosition.x = position.x; newPosition.y = position.y;
		[sprite setPosition:newPosition];
		force = pForce;
		damage = pDamage;
		rotation = 0;
	}
	return self;
}
-(void)dealloc
{
	[super dealloc];
}
@end
