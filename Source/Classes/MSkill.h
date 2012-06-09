//  MSkill.h
//  Monster
//
//  Created by Ryan Renna on 10-05-31.

#import "MEffect.h"

typedef enum
{
	AttackSkill,
	DefenseSkill,
	MovementSkill,
	PassiveSkill
} SkillType;

@interface MSkill : NSObject {
	SkillType type;
	double energyCost;
	int moveCost;
	int range;
	double accuracy;
	NSArray *effects;
	NSArray *augments;
}
@property (readonly) SkillType type;
@property (readonly) double energyCost;
@property (readonly) int moveCost;
@property (readonly) int range;
@property (readonly) double accuracy;
@property (retain,readonly) NSArray *effects;
@property (retain,readonly) NSArray *augments;
-(id)initWithType : (SkillType) pType andEnergyCost: (double) pEnergyCost andMoveCost:(int) pMoveCost andRange: (int)pRange andAccuracy: (double) pAccuracy;
-(void)setEffectsArray : (NSArray*) pEffects;
-(void)setEffect : (MEffect*) pEffects;
@end
