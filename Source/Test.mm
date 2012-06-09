//
//  untitled.mm
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tests.h"

@implementation Tests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle
-(void) setUp
{
	TestMTeam = NSClassFromString(@"MTeam");	
	TestMMatch = NSClassFromString(@"MMatch");
	TestMMap = NSClassFromString(@"MMatch");
	TestMEffect= NSClassFromString(@"MMatch");
	TestMSkill = NSClassFromString(@"MMatch");
	TestMAction = NSClassFromString(@"MMatch");
	TestMButton = NSClassFromString(@"MMatch");
	TestMSkillChest = NSClassFromString(@"MMatch");
	TestMMessage = NSClassFromString(@"MMatch");
	TestMProjectile = NSClassFromString(@"MMatch");
	TestMMove = NSClassFromString(@"MMatch");
	TestMObject = NSClassFromString(@"MMatch");
	TestMVertexUtil = NSClassFromString(@"MMatch");
	TestMSetting = NSClassFromString(@"MMatch");
}
- (void) testMTeam
{
	MTeam *team = [[TestMTeam alloc] initWithColor:[UIColor redColor] isPlayerControlled:NO];
	STAssertNil(team,@"testMTeam - MTeam instance is nil.");
}
- (void) testMMatch
{
	MTeam *team = [[TestMTeam alloc] initWithColor:[UIColor redColor] isPlayerControlled:NO];
	MMatch *match = [[TestMMatch alloc] initWithMaxRoundAndTeams:15:team,nil];
	STAssertNil(match,@"testMMatch - MMatch instance is nil.");
}
- (void) testMMap
{
	MMap *map = [[TestMMap alloc] init];
	STAssertNil(map,@"testMMap - MMap instance is nil.");
}

- (void) testMEffect
{
	MEffect *effect = [[TestMEffect alloc] initWithDamage : 25];
	STAssertNil(effect,@"testMEffect - MEffect instance is nil.");	
}

-(void) testMSkill
{
	MSkill *skill = [[TestMSkill alloc] initWithType:AttackSkill andEnergyCost:0.0 andMoveCost:1 andRange:1 andAccuracy:0.9];
	STAssertNil(skill,@"testMSkill - MSkill instance is nil.");
}

- (void) testMMovement
{
	Vertex source; source.x = 1; source.y = 1;
	Vertex destination; destination.x = 1; destination.y = 2;
	MSkill *skill = [[TestMSkill alloc] initWithType:AttackSkill andEnergyCost:0.0 andMoveCost:1 andRange:1 andAccuracy:0.9];
	
	MMove *move = [[TestMMove alloc] init:source:destination:skill];
	STAssertNil(move,@"testMMovement - MMovement instance is nil.");
}

- (void) testMAction
{
	Vertex source; source.x = 1; source.y = 1;
	Vertex destination; destination.x = 1; destination.y = 2;
	MSkill *skill = [[TestMSkill alloc] initWithType:AttackSkill andEnergyCost:0.0 andMoveCost:1 andRange:1 andAccuracy:0.9];
	MMove *move = [[TestMMove alloc] init:source:destination:skill];
	
	MAction *action = [[TestMAction alloc] initWithMove : move];
	STAssertNil(action,@"testMAction - MAction instance is nil.");
}

- (void) testMButton
{
	MButton *button1 = [TestMButton buttonWithImage:@"NextTurnButton.png" PressedImaged:@"NextTurnButtonPressed.png" atPosition:ccp(25,25) target:self selector:@selector(btnNextTurn_Click:)];
	STAssertNil(button1,@"testMButton - MButton instance is nil.");
	MButton *button2 = [TestMButton buttonWithText:@"Start" background:true backgroundImage:@"button.png" backgroundImagePressed:@"button_pressed.png" atPosition:ccp(25,25) target:self selector:@selector(startGame:)];
	STAssertNil(button2,@"testMButton - MButton instance is nil.");
}

- (void) testMSkillChest
{
	MSkillChest *skillChest = [[TestMSkillChest alloc] init];
	
	MSkill *attackskill = [[TestMSkill alloc] initWithType:AttackSkill andEnergyCost:0.0 andMoveCost:1 andRange:1 andAccuracy:0.9];
	[skillChest add:attackskill];
	NSArray *meleeSkills = [skillChest getMeleeSkills];
	
	STAssertNil(skillChest,@"testMSkillChest - MSkillChest instance is nil.");
	STAssertNil(meleeSkills,@"testMSkill - Melee Skill Array is nil.");	
}

#endif


@end
