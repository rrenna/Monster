//
//  Skill.m
//  Monster
//
//  Created by Ryan Renna on 10-05-31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSkill.h"

@implementation MSkill
@synthesize type;
@synthesize energyCost;
@synthesize moveCost;
@synthesize range;
@synthesize accuracy;
@synthesize effects;
@synthesize augments;
-(id)initWithType : (SkillType) pType andEnergyCost: (double) pEnergyCost andMoveCost:(int) pMoveCost andRange: (int)pRange andAccuracy: (double) pAccuracy
{
	if((self = [super init]))
	{
		type = pType;
		energyCost = pEnergyCost;
		moveCost = pMoveCost;
		range = pRange;
		accuracy = pAccuracy;
	}
	return self;
	
}
-(void)setEffectsArray : (NSArray*) pEffects
{
	effects = [pEffects retain];
}
-(void)setEffect : (MEffect*) pEffects
{
	effects = [[NSArray alloc] initWithObjects:pEffects,nil];
}
-(void)dealloc
{
	[effects release];
	[augments release];
	[super dealloc];
}
@end
