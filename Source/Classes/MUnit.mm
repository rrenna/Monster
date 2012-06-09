//  Unit.m
//  Monster
//
//  Created by Ryan Renna on 10-05-25.

#import "MUnit.h"

@implementation MUnit
#define PTM_RATIO 32
@synthesize moves;
@synthesize nextAction;
@synthesize persona;
@synthesize hasQueuedMoves;

-(id) initWithName: (NSString*) pName andPosition: (Vertex) pPosition andTeam:(MTeam*)pTeam
{	
	if( (self=[super initWithName:pName andPosition:pPosition andTeam:pTeam] )) 
	{
		hasQueuedMoves = NO;
		activityState = idle;
		persona = [MPersona getPersona:pName];
		sprite = [CCSprite spriteWithFile:[persona spriteName]];
		[self update];
		[self replenishMoves];
	}
	return self;
}
- (void) dealloc
{
	[super dealloc];
}
-(NSMutableArray*)  getActions: (MMap*) map
{
	[map retain];
	NSMutableArray *actions = [[NSMutableArray alloc] init];
	int speed = moves;
	
	NSArray *movementSkills = [[persona skillChest] getMovementSkills];
	NSArray *meleeSkills = [[persona skillChest] getMeleeSkills];
	NSArray *defenseSkills = [[persona skillChest] getDefensiveSkills];
	
	for(MSkill* movementSkill in movementSkills)
	{
		if(moves >= movementSkill.moveCost)
		{
			//TODO: For each square, in a speed radius, can move there
			//int movementSize = (speed * speed) + 1;
			int skipAmount = speed;
			//If directionSwitch is true, we're checking spaces above the entity, if false, below 
			// and will be adding to skipAmount instead of subtracking
			bool directionSwitch = true;
			for(int y = speed; y >= -speed; y--)
			{
				for(int x = -speed; x <= speed; x++)
				{
					Vertex pos; 
					pos.x = position.x + x; 
					pos.y = position.y + y;
					//Check if pos is moveable
					if([map isValidPosition:pos])
					{
						MTeam* TeamAtPosition = [MEntityManager unitTeamAt:pos];
						
						//Skip current position
						if(y == 0 && x == 0)
						{
							for(MSkill* defenseSkill in defenseSkills)
							{
								//Check all defense skills aplicable to self
							}
						}
						//Skip unwalkable positions
						//TODO: Implement dyanmic walkable terrain
						else if([map isWalkable:pos] == NO)
						{
							continue;
						}
						//Generate attack actions for positions with other Enemy Units
						else if (TeamAtPosition != nil) 
						{
							if(TeamAtPosition == team)
							{
								//Friendly unit moves
								for(MSkill* defenseSkill in defenseSkills)
								{
									//Check all defense skills aplicable to other friendly units
								}
							}
							else 
							{
								//Hostile Units - Get all Melee moves
								for(MSkill* meleeSkill in meleeSkills)
								{
									MAStarSearch *search = [[MAStarSearch alloc] init:map];
									MAction *action = [search AStarSearch: position : pos : speed : movementSkill : meleeSkill : team];
									//If there is a route, add it to the list
									if(action)
									{
										[actions addObject:action];
									}
									[action release];
									[search release];
								}
							}
						}
						//Since used to only check squares the entity could possibly move to, and ignore the "corners" of the 2d movement space
						else if(x >= (-speed + skipAmount) && x <= (speed - skipAmount))
						{
							MAStarSearch *search = [[MAStarSearch alloc] init:map];
							
							MAction *action = [search AStarSearch:position :pos :speed :movementSkill :movementSkill : team];
						
							//If there is a route, add it to the list
							if(action)
							{
								[actions addObject:action];
							}
							[action release];
							[search release];
						}
						else 
						{
							continue;
						}
					}
				}
				//When reaching "half way" down the movement space, switch directionSwitch to false
				if(y == 0)
				{
					directionSwitch = !directionSwitch;
				}
				if(directionSwitch)
				{
					skipAmount--;
				}
				else 
				{
					skipAmount++;
				}
				
			}				
		}
	}
		
	// Ranged Attacks
	NSArray *rangeSkills = [[persona skillChest] getRangedSkills];
	//Only want to for each over nearby units if there are any range shots
	// to consider
	if([rangeSkills count] > 0)
	{
		for(NSString *unitKey in [MEntityManager allUnits])
		{
			MActor *actor = [[MEntityManager allUnits] objectForKey:unitKey];
			MUnit *unit = [actor object];
			MTeam *teamAtPosition = [unit team];
			//Skip all units on your team (including yourself)
			if(teamAtPosition == team)
			{
				continue;
			}
			else {
				//Create a ranged attack action
				for(MSkill *rangeSkill in rangeSkills)
				{
					//For any skill that has enough range
					if([MVertexUtil VertexDistance:position:[unit position]] < rangeSkill.range)
					{
						MMove * rangedAttackMove = [[MMove alloc] init:position :[unit position] : rangeSkill];
						MAction *rangedAttackAction = [[MAction alloc] initWithMove:rangedAttackMove];
						[actions addObject:rangedAttackAction];
						[rangedAttackAction release];
						[rangedAttackMove release];
					}
				}
			}
			
		}
	}
	
	[defenseSkills release];
	[movementSkills release];
	[meleeSkills release];	
	[rangeSkills release];
	[map release];
	return actions;
}
-(void)performQueuedAction
{
	[self performAction:nextAction];
}
-(void)performAction : (MAction*) action
{
	if([action moves].count > 0)
	{
		hasQueuedMoves = YES;
		MMove *move = [[action moves] objectAtIndex:0];
		[self performMove:move];
		[[action moves] removeObject:move];
	}
	else 
	{
		hasQueuedMoves = NO;
		[action release];
	}
}
-(void)performMove : (MMove*) pMove
{
	moves--;
	if([[pMove skill] type] == MovementSkill)
	{
		[self performMovement:pMove];	
	}
	else if([[pMove skill] type] == AttackSkill)
	{
		if([[pMove skill] range] == 1)
		{
			[self performMeleeAttack:pMove];
		}
		else 
		{
			[self performRangeAttack:pMove];
		}
	}
	else 
	{
		
	}

/*
	switch([[pMove type] type])
	{
		case(MovementSkill):
		{
			[self performMovement:pMove];
			break;
		}
		case(MeleeAttackSkill):
		{
			[self performMeleeAttack:pMove];
			break;
		}
		case(RangedAttackSkill):
		{
			[self performRangeAttack:pMove];
			break;
		}
		case(DefensiveSkill):
		{
			break;
		}
	}
 */
}
-(void)kill
{
	if(clean == NO)
	{
		[MEntityManager remove:self : UnitType];	
	}
}
-(void)performDamage : (NSNumber*) pNumber withForce : (CGPoint)pForce
{
	[super performDamage:pNumber withForce: pForce];
	//Show damage particles
	CCParticleSystemQuad *particleSystem = [CCParticleSystemQuad alloc];
	if([persona sentienceType] == OrganizeSentience)
	{
		particleSystem = [particleSystem initWithFile:@"MonsterBloodSpurt.plist"];
	}
	else {
		particleSystem = [particleSystem initWithFile:@"Spark.plist"];
	}

	CGPoint explosionPosition; explosionPosition.x = sprite.position.x;
	explosionPosition.y = sprite.position.y;
	[particleSystem setPosition:explosionPosition];
	[[sprite parent] addChild:particleSystem];
	[particleSystem release];
	
	
	if(health <= 0)
	{
		[self kill];
	}
}
-(void)performMovement :(MMove*) pMove
{
	activityState = rotating;
	[self update];

	int deltaX = [pMove destinationPosition].x - position.x;
	int deltaY = [pMove destinationPosition].y - position.y;
	double newAngle = atan2(-deltaY, deltaX) * (180/ 3.14) + 90;
	
	//Changes key in the dictionary to correspond to new position
	[MEntityManager refreshKey :self :UnitType :[pMove destinationPosition]];

	double diff = MIN(abs(newAngle - rotation),abs((360 + rotation) - newAngle));
	//Generates the frames it should update to rotate the unit, based on it's size
	double rotationTimeRequired = (diff / 360) * (45 * [persona weight]);
	rotation = newAngle;
	CCRotateBy *rotate = [CCRotateTo  actionWithDuration:(rotationTimeRequired/50) angle:newAngle];
	CCMoveBy *movement = [CCMoveBy actionWithDuration:2.65 position:ccp(deltaX * TILEXSIZE, deltaY * TILEYSIZE)]; 
	[self performTransformation:rotate];	
	
	//Queue future events
	//Move towards next square
	NSNumber *movementStateValue = [[NSNumber alloc] initWithInt:moving];
	MMessage *stateMessage = [[MMessage alloc] initWithSender:[self key] andReciever:[self key] andEntityType:UnitType andMessageType:ActivityStateChangeMessage andValue:movementStateValue andDelay:rotationTimeRequired];
	MMessage *moveSpriteMessage = [[MMessage alloc] initWithSender:[self key] andReciever:[self key] andEntityType:UnitType andMessageType:TransformationMessage andValue:movement andDelay:rotationTimeRequired];
	MMessage *crushMessage = [[MMessage alloc] initWithSender:[self key] andReciever:[self key] andEntityType:StructureType andMessageType:DamageMessage andValue:[NSNumber numberWithInt:100] andDelay:rotationTimeRequired + 70];
	NSNumber *idleStateValue = [[NSNumber alloc] initWithInt:idle];
	MMessage *updateMessage = [[MMessage alloc] initWithSender:[self key] andReciever:[self key] andEntityType:UnitType andMessageType:UpdateMessage andValue:idleStateValue andDelay:rotationTimeRequired + 80];
	[MEntityManager queueMessage:moveSpriteMessage];
	[MEntityManager queueMessage:crushMessage];
	[MEntityManager queueMessage:stateMessage];
	[MEntityManager queueMessage:updateMessage];
	
	[moveSpriteMessage release];
	[crushMessage release];
	[stateMessage release];
	[updateMessage release];
}
-(void)performMeleeAttack :(MMove*) pMove
{
	activityState = melee;
	[self update];
	int deltaX = [pMove destinationPosition].x - position.x;
	int deltaY = [pMove destinationPosition].y - position.y;
	double newAngle = atan2(-deltaY, deltaX) * (180/ 3.14) + 90;
	double diff = abs(newAngle - rotation);
	double rotationTimeRequired = (diff / 360) * (50 * persona.weight);
	rotation = newAngle;
	
	CCRotateBy *rotate = [CCRotateTo  actionWithDuration:(rotationTimeRequired/100) angle:newAngle];
	[self performTransformation:rotate];
	NSNumber *damageValue = [[NSNumber alloc] initWithInt:50];
	MMessage *damageMessage = [[MMessage alloc] initWithSender:[self key] andReciever:[MVertexUtil VertexLocationKey:pMove.destinationPosition] andEntityType:UnitType andMessageType:DamageMessage andValue:damageValue andDelay:rotationTimeRequired ];
	NSNumber *stateValue = [[NSNumber alloc] initWithInt:idle];
	MMessage *updateMessage = [[MMessage alloc] initWithSender:[self key] andReciever:[self key] andEntityType:UnitType andMessageType:UpdateMessage andValue:stateValue andDelay:rotationTimeRequired + 100];
	//[EntityManager queueMessage:transformMessage];

	[MEntityManager queueMessage:damageMessage];
	[MEntityManager queueMessage:updateMessage];
	[damageMessage release];
	[updateMessage release];
}
-(void)performRangeAttack :(MMove*) pMove
{
	activityState = rotating;
	[self update];
	int deltaX = [pMove destinationPosition].x - position.x;
	int deltaY = [pMove destinationPosition].y - position.y;
	double newAngle = atan2(-deltaY, deltaX) * (180/ 3.14) + 90;
	double diff = abs(newAngle - rotation);
	//Calculates the time required to rotate, multiplied by unit size, giving illution of girth
	double rotationTimeRequired = (diff / 360) * (50 * persona.weight);
	rotation = newAngle;
	
	CCRotateBy *rotate = [CCRotateTo  actionWithDuration:(rotationTimeRequired/90) angle:newAngle];
	[self performTransformation:rotate];
	
	MMessage *projectileMessage = [[MMessage alloc] initWithSender:[self key] andReciever:[self key] andEntityType:UnitType andMessageType:FireProjectileMessage andValue:pMove andDelay:rotationTimeRequired];
	[MEntityManager queueMessage:projectileMessage];
}
-(void)fireProjectile : (MMove*) pMove
{
	activityState = range;
	int deltaX = [pMove destinationPosition].x - position.x;
	int deltaY = [pMove destinationPosition].y - position.y;
	Vertex shotPoint;
	CGPoint force; force.x = deltaX/32.0f; force.y = deltaY/32.0f;
	
	[self performShakeWithForce : force];
	
	double radAngle = (rotation * 3.14/180);
	double xTemp = ([persona rangeOffset].x * cos(-radAngle)) - ([persona rangeOffset].y * sin(-radAngle));
	shotPoint.y = ([persona rangeOffset].x * sin(-radAngle)) + ([persona rangeOffset].y * cos(-radAngle));
	shotPoint.x = xTemp;
	shotPoint.x += sprite.position.x;
	shotPoint.y += sprite.position.y;
	MProjectile *projectile = [[MProjectile alloc] initWithName:[MProjectileManager getNextProjectileName] andPosition:shotPoint andForce:force andDamage:10 andTeam: self.team];
	[MProjectileManager add: projectile];
	//MMessage *damageMessage = [[MMessage alloc] initWithSender:[self locationKey] andReciever:[MVertexUtil VertexLocationKey:pMove.destinationPosition] andEntityType:UnitType andMessageType:DamageMessage andValue:damageValue andDelay:55 ];
	//[MEntityManager queueMessage:damageMessage];
	//[damageMessage release];
}
-(void)queueAction : (MAction*) pAction
{
	hasQueuedMoves = YES;
	nextAction = pAction;
}
-(void) replenishMoves
{
	moves = [persona maxMoves];
}
-(void) update
{
	[super update];
	//Check if there's any running actions on the Unit's sprite. If not, set the 
	// status to idle
	if ([sprite numberOfRunningActions] == 0)
	{
		activityState = idle;
	}
	[self setAnimation];
}
-(void) setAnimation
{
	if(activityState == idle)
	{
		NSString *animationName = [NSString stringWithFormat:@"%@%@",name,@"_idle"];
		CCAnimation *animation = [[[self persona] animations]objectForKey:animationName];
		id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
		[[self sprite] runAction:action];
	}
	else if(activityState == moving)
	{
		NSString *animationName = [NSString stringWithFormat:@"%@%@",name,@"_moving"];
		CCAnimation *animation = [[[self persona] animations]objectForKey:animationName];
		id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
		[[self sprite] runAction:action];
	}
	else if(activityState == melee)
	{
		//TODO: Replace with Melee animation
		NSString *animationName = [NSString stringWithFormat:@"%@%@",name,@"_moving"];
		CCAnimation *animation = [[[self persona] animations]objectForKey:animationName];
		id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
		[[self sprite] runAction:action];
	}
}
-(void) setActivityState : (NSNumber*)pState
{
	activityState = (ActivityState)[pState intValue];
	[self setAnimation];
}
@end
