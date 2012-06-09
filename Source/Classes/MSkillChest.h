//  MSkillChest.h
//  Monster
//
//  Created by Ryan Renna on 10-05-31.

#import "MSkill.h"
#import "MEffect.h"

@interface MSkillChest : NSObject {
	NSMutableArray *skills;
}
-(NSArray*)getMovementSkills;
-(NSArray*)getMeleeSkills;
-(NSArray*)getRangedSkills;
-(NSArray*)getDefensiveSkills;
-(NSArray*)getPassiveSkills;
-(void)add : (MSkill*) pSkill;
@end
