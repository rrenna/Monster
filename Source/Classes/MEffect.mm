//  MEffect.m
//  Monster
//
//  Created by Ryan Renna on 10-05-31.

#import "MEffect.h"


@implementation MEffect
@synthesize damage;
@synthesize health;
@synthesize energy;
@synthesize moves;


-(id)initWithDamage : (double) pDamage
{
	return [self initWithDamage:pDamage andHealth:0 andEnergy:0 andMoves:0];
}
-(id)initWithHealth : (double) pHealth
{
	return [self initWithDamage:0 andHealth:pHealth andEnergy:0 andMoves:0];
}
-(id)initWithEnergy : (double) pEnergy
{
	return [self initWithDamage:0 andHealth:0 andEnergy:pEnergy andMoves:0];
}
-(id)initWithMoves : (int) pMoves
{
	return [self initWithDamage:0 andHealth:0 andEnergy:0 andMoves:pMoves];
}
-(id)initWithDamage:(double)pDamage andHealth:(double)pHealth andEnergy:(double)pEnergy andMoves:(int)pMoves
{
	if((self = [super init]))
	{
		damage = pDamage;
		health = pHealth;
		energy = pEnergy;
		moves = pMoves;
	}
	return self;
}
@end
