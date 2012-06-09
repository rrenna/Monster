//
//  MPersona.m
//  Monster
//
//  Created by Ryan Renna on 10-05-11.

#import "MPersona.h"

//Static variables
static NSMutableDictionary *personas = nil;

@implementation MPersona
@synthesize spriteName;
@synthesize animations;
@synthesize maxMoves;
@synthesize skillChest;
@synthesize rangeOffset;
@synthesize sentienceType;
@synthesize weight;
@synthesize shape;
//Static constructor
+(void)load
{
	//Setup static personas
	personas = [[NSMutableDictionary alloc] init];
}
+(void)initialize
{
	if (self == [MPersona class]) 
	{
		//Initialize Animations
			//Tank Animations
			CCAnimation *tank_idle = [[[CCAnimation alloc] init] autorelease];
            tank_idle.delay = 1/3.0;
			[tank_idle addFrameWithFilename:@"Tank-Idle1.png"];
			CCAnimation *tank_moving = [[[CCAnimation alloc] init] autorelease];
            tank_moving.delay = 1/3.0;
			[tank_moving addFrameWithFilename:@"Tank-Idle1.png"];
			NSMutableDictionary *tank_animations = [[NSMutableDictionary alloc] init];
			[tank_animations setObject:tank_idle forKey:@"tank_idle"];
			[tank_animations setObject:tank_moving forKey:@"tank_moving"];		
			//Monster Animations
			CCAnimation *monster_idle = [[[CCAnimation alloc] init] autorelease];
            monster_idle.delay = 1/2.0;
			[monster_idle addFrameWithFilename:@"Monster-Idle1.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle2.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle3.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle4.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle5.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle6.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle7.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle8.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle9.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle10.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle11.png"];
			[monster_idle addFrameWithFilename:@"Monster-Idle12.png"];
			CCAnimation *monster_moving = [[[CCAnimation alloc] init] autorelease];
        monster_moving.delay = 1/6.0;
			[monster_moving addFrameWithFilename:@"Monster-Walk1.png"];
			[monster_moving addFrameWithFilename:@"Monster-Walk2.png"];
			[monster_moving addFrameWithFilename:@"Monster-Walk3.png"];
			[monster_moving addFrameWithFilename:@"Monster-Walk4.png"];
			[monster_moving addFrameWithFilename:@"Monster-Walk5.png"];
			[monster_moving addFrameWithFilename:@"Monster-Walk6.png"];
			[monster_moving addFrameWithFilename:@"Monster-Walk7.png"];
			[monster_moving addFrameWithFilename:@"Monster-Walk8.png"];
			NSMutableDictionary *monster_animations = [[NSMutableDictionary alloc] init];
			[monster_animations setObject:monster_idle forKey:@"monster_idle"];
			[monster_animations setObject:monster_moving forKey:@"monster_moving"];
		//
		//Initialize Skills
		//Tank Skills
		MSkillChest *tankSkillChest = [MSkillChest new];
		//Range shot Skill
		MSkill *rangeShotSkill = [[MSkill alloc] initWithType:AttackSkill andEnergyCost:5 andMoveCost:1 andRange:5 andAccuracy:0.9];		
		MEffect *rangeDamageEffect = [[MEffect alloc] initWithDamage:10];
		[rangeShotSkill setEffect:rangeDamageEffect];
		[rangeDamageEffect release];
		[tankSkillChest add:rangeShotSkill];
		[rangeShotSkill release];
		//Movement Skill
		MSkill *tankMovementSkill = [[MSkill alloc] initWithType:MovementSkill andEnergyCost:0 andMoveCost:1 andRange:1 andAccuracy:1.0];
		[tankSkillChest add:tankMovementSkill];
		//Monster Skills
		MSkillChest *monsterSkillChest = [MSkillChest new];
		//Movement Skill
		MSkill *monsterMovementSkill = [[MSkill alloc] initWithType:MovementSkill andEnergyCost:0 andMoveCost:1 andRange:1 andAccuracy:1.0];
		[monsterSkillChest add:monsterMovementSkill];
		//Melee Skill
		MSkill *monsterMeleeSkill = [[MSkill alloc] initWithType:AttackSkill andEnergyCost:0 andMoveCost:1 andRange:1 andAccuracy:1.0];
		MEffect *meleeDamageEffect = [[MEffect alloc] initWithDamage:25];
		[monsterMeleeSkill setEffect:meleeDamageEffect];
		[meleeDamageEffect release];
		[monsterSkillChest add:monsterMeleeSkill];
		//Initialize Range Offset positions
		Vertex tankRangeOffset; tankRangeOffset.x = 0; tankRangeOffset.y = 16;
		Vertex monsterRangeOffset; monsterRangeOffset.x = 0; monsterRangeOffset.y = 16;
		//
		//Initialize Personas
		MPersona *tank = [[MPersona alloc] init:@"tank" :@"Tank-Idle1.png" : MechanicalSentience : 1 : 2.5f : tankRangeOffset : tank_animations : tankSkillChest];
		MPersona *monster = [[MPersona alloc] init: @"Monster-Idle1" : @"Monster-Idle1.png" : OrganizeSentience : 2 : 5.0f : monsterRangeOffset :monster_animations : monsterSkillChest];
		//
		[personas setObject:tank forKey:@"tank"];
		[personas setObject:monster forKey:@"monster"];
		//Cleanup
		[monster_animations release];
		[tank_animations release];
		[tank release];
		[monster release];
	}
}

//Instance constructor
-(id)init : (NSString *)pName : (NSString *)pSpriteName : (SentienceType) pSentienceType  :(int)pMaxMoves : (float)pWeight : (Vertex) pRangeOffset : (NSDictionary*) pAnimations
{
	MSkillChest *chest = [[MSkillChest alloc]init];
	return [self init:pName :pSpriteName : pSentienceType : pMaxMoves :pWeight :pRangeOffset : pAnimations : chest];
}

-(id)init:(NSString *)pName :(NSString *)pSpriteName : (SentienceType) pSentienceType :(int)pMaxMoves : (float)pWeight : (Vertex) pRangeOffset : (NSDictionary*) pAnimations : (MSkillChest*)pSkillChest
{
	if( (self=[super init] )) 
	{
		name = pName;
		spriteName = pSpriteName;
		sentienceType = pSentienceType;
		maxMoves = pMaxMoves;
		weight = pWeight;
		rangeOffset = pRangeOffset;
		animations = [pAnimations retain];
		skillChest = pSkillChest;
		shape.SetAsBox(weight/100, weight/50);
	}
	return self;
}
- (void) dealloc
{
	[skillChest release];
	[animations release];
	[super dealloc];
}

+(MPersona*)getPersona : (NSString*) pName
{
	return [personas objectForKey:pName];
}
@end
