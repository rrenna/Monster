//
//  MSkillChest.m
//  Monster
//
//  Created by Ryan Renna on 10-05-31.

#import "MSkillChest.h"

@implementation MSkillChest
-(NSArray*)getMovementSkills
{
	NSMutableArray *movementSkills = [[NSMutableArray alloc] initWithCapacity:1];
	for(MSkill *skill in skills)
	{
		if(skill.type == MovementSkill)
		{
			[movementSkills addObject:skill];
		}
	}
	return movementSkills;
}
-(NSArray*)getMeleeSkills
{	
	NSMutableArray *meleeSkills = [[NSMutableArray alloc] initWithCapacity:1];
	for(MSkill *skill in skills)
	{
		if(skill.type == AttackSkill && skill.range == 1)
		{
			[meleeSkills addObject:skill];
		}
	}
	return meleeSkills;
}
-(NSArray*)getRangedSkills
{
	NSMutableArray *rangeSkills = [[NSMutableArray alloc] initWithCapacity:1];
	for(MSkill *skill in skills)
	{
		if(skill.type == AttackSkill && skill.range > 1)
		{
			[rangeSkills addObject:skill];
		}
	}
	return rangeSkills;
}
-(NSArray*)getDefensiveSkills
{
	return nil;	
}
-(NSArray*)getPassiveSkills
{
	return nil;	
}
-(id)init
{
	if((self = [super init]))
	{
		skills = [NSMutableArray new]; 
	}
	return self;
}
-(void)add : (MSkill*) pSkill
{
	[skills addObject:pSkill];
}
@end
