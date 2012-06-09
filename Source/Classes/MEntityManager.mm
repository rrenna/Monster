//  EntityManager.m
//  Monster
//
//  Created by Ryan Renna on 10-05-25.

#import "MEntityManager.h"

//Static variables
static b2World* world;
static NSMutableDictionary *units = nil;
static NSMutableDictionary *structures = nil;
static NSMutableArray *messageAddQueue = nil;
static NSMutableArray *messages = nil;
static NSMutableArray *cleanupEntityQueue = nil;
static MEntity *focusEntity = nil;
static BOOL processing = NO;
static UnitLayer *unitLayer = nil;

@implementation MEntityManager
#define PTM_RATIO 32
+(void)initWithLayer : (UnitLayer*) pEntityLayer
{
	if( (!units )) 
	{
		unitLayer = pEntityLayer;
		//Setup Box2D physics
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, 0.0f);
		bool doSleep = true;
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);	
		world->SetContactListener(new MContactListener);
		world->SetContinuousPhysics(true);	

		units = [[NSMutableDictionary alloc] init];
		structures = [[NSMutableDictionary alloc] init];
		messages = [[NSMutableArray alloc]init];
		messageAddQueue = [[NSMutableArray alloc]init];
		cleanupEntityQueue = [[NSMutableArray alloc]init];
	}
}
+(BOOL)isProcessing
{
	return processing;
}
+(b2World*)getWorld
{
	return world;
}
+(NSMutableArray*)getCleanUpEntityQueue
{
	return cleanupEntityQueue;
}
+(void)cleanUpEntityQueue
{
	for(MActor *actor in cleanupEntityQueue)
	{		
		[unitLayer removeChild:[[actor object] sprite] cleanup:YES];
		b2World *world = [MEntityManager getWorld];
		world->DestroyBody(actor.body);
	}
	[cleanupEntityQueue removeAllObjects];
}
+(void)update
{
	BOOL checkForFocusUnitMessages = NO;
	BOOL focusUnitHasMessage = NO;
	NSMutableArray *messageDeletionQueue = nil;
	processing = NO;
	
	//Clean up removed entities
	[self cleanUpEntityQueue];
	//Perform queued action of focusUnit, unless messages are inbound to currentUnit
	if(focusEntity != nil)
	{
		if([focusEntity hasQueuedMoves])
		{
			//While the update is doing a pass of each message, check if any are for the
			// focus unit, if no messages are waiting for it, perform it's next move
			checkForFocusUnitMessages = YES;
		}
		else {
			if(((MUnit*)focusEntity).activityState != idle)
			{
				processing = YES;
			}

		}

	}

	//Add all queued messeges
	for(MMessage *message in messageAddQueue)
	{
		[messages addObject:message];
	}
	//Clear out the add message queue
	[messageAddQueue removeAllObjects];
	for (MMessage *message in messages) 
	{
		processing = YES;
		//If we're doing a focus unit message check, also check if the recipient is the 
		// focus unit
		if(checkForFocusUnitMessages)
		{
			//If a message is being sent to the focus unit's position, directed to a unit type
			// consider it a message directed to the specific unit in waiting
			if([[message reciever] isEqualToString:[focusEntity key]] && [message entityType] == UnitType)
			{
				focusUnitHasMessage = YES;
			}
		}
		
		if ([message delay] <= 0) 
		{
			[self sendMessage:message];
			if(!messageDeletionQueue)
			{
				messageDeletionQueue = [[NSMutableArray alloc] init];
			}
			[messageDeletionQueue addObject:message];
		}
		else 
		{
			message.delay -= 1;
		}
	}
	
	//If there are messages to delete
	if(messageDeletionQueue)
	{
		for(MMessage *message in messageDeletionQueue)
		{
			[messages removeObject:message];
		}
		[messageDeletionQueue release];
		messageDeletionQueue = nil;
	}
	
	//Perform the next move for the focus unit, assuming no messages are incoming
	// and it has queued moves to perform
	if(checkForFocusUnitMessages && !focusUnitHasMessage)
	{
		[focusEntity performQueuedAction];	
	}
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(0.1, velocityIterations, positionIterations);
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if(b->GetType() == b2_staticBody)
		{
			MEntity *entity = (MEntity*)b->GetUserData();
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			b2Vec2 actorSpriteLocation; 
			actorSpriteLocation.x = [entity sprite].position.x / PTM_RATIO;
			actorSpriteLocation.y = [entity sprite].position.y / PTM_RATIO;
			b->SetTransform(actorSpriteLocation,[entity sprite].rotation);
		}
		else
		{
			MProjectile *projectile = (MProjectile*)b->GetUserData();
			CGPoint projectilePoint = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			[projectile.sprite setPosition:projectilePoint];
			projectile.sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
}
+(void) setFocusEntity : (MEntity*) pEntity
{
	focusEntity = pEntity;	
}
+(MEntity*) getFocusEntity
{
	return focusEntity;
}
+(void) clearFocusEntity
{
	focusEntity = nil;
}
+(void)add : (MEntity*) pEntity : (EntityType) pType
{
	
	[unitLayer addChild:[pEntity sprite] z:1];
	
	MActor *actor = [[MActor alloc] initWithEntity: pEntity];
	[actor bodyDef]->userData = [actor object];
	[actor bodyDef]->type = b2_staticBody;
	[actor bodyDef]->position.Set([pEntity sprite].position.x/PTM_RATIO, [pEntity sprite].position.y/PTM_RATIO);
	actor.body = world->CreateBody([actor bodyDef]);
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
    
    MPersona* persona = [[actor object] persona];
    b2PolygonShape shape = [persona shape];
    
	fixtureDef.shape = &shape;	
	fixtureDef.density = [[[actor object] persona] weight];
	fixtureDef.friction = 0.5f;
	fixtureDef.restitution = 0.9f;
	[actor body]->CreateFixture(&fixtureDef);
	
	NSString *EntityKey = [pEntity key];
	switch (pType) {
		case UnitType:
			//Add to unit dictionary
			[units setObject:actor forKey:EntityKey];
			break;
		case StructureType:
			//Add to structure dictionary
			[structures setObject:actor forKey:EntityKey];
			break;
		default:
			break;
	}
}
+(void)refreshKey :(MEntity*)pEntity:(EntityType)pType:(Vertex)pPosition
{	
	NSString *oldEntityKey = [pEntity key];
	pEntity.position = pPosition;
	NSString *newEntityKey = [pEntity key];
	
	MActor *actor;
	switch (pType) {
		case UnitType:
			//refresh to unit dictionary
			actor = [[units objectForKey:oldEntityKey] retain];
			[units removeObjectForKey:oldEntityKey];
			[units setObject:actor forKey:newEntityKey];
			[actor release];
			break;
		case StructureType:
			//refresh to structure dictionary
			actor = [[structures objectForKey:oldEntityKey] retain];
			[structures removeObjectForKey:oldEntityKey];
			[structures setObject:actor forKey:newEntityKey];
			[actor release];
			break;
		default:
			break;
	}
}
+(void)remove: (MEntity*) pEntity : (EntityType) pType
{
	[self remove:pEntity :pType Cleanup:YES];
}
+(void)remove: (MEntity*) pEntity : (EntityType) pType Cleanup:(BOOL)pCleanup
{
	NSString *EntityKey = [pEntity key];
	MActor *actor;
	MEntity *entity;
	//TODO: Flesh out
	//Place a particle explosion at removal point
	CCParticleSystemQuad *particleSystem = [[CCParticleSystemQuad alloc] initWithFile:@"smallExplosion.plist"];
	
	CGPoint explosionPosition; explosionPosition.x = pEntity.sprite.position.x;
	
	explosionPosition.y = pEntity.sprite.position.y;
	[particleSystem setPosition:explosionPosition];
	[unitLayer addChild:particleSystem];
	[particleSystem release];
	
	//
	switch (pType) {
		case UnitType:
		{
			//Add to unit dictionary
			actor = [units objectForKey:EntityKey];
			entity = [actor object];
			if(entity.clean == NO)
			{
				if(pCleanup)
				{
					[cleanupEntityQueue addObject:actor];
				}
				[units removeObjectForKey:EntityKey];
			}
		}
			break;
		case StructureType:
			//Add to structure dictionary
			actor = [structures objectForKey:EntityKey];
			entity = [actor entity];
			if(pCleanup)
			{
				[cleanupEntityQueue addObject:actor];
			}
			[structures removeObjectForKey:EntityKey];

			break;
		default:
			break;
	}
	[entity setCleaned];
}
+(void)queueMessage : (MMessage*) message
{
	if([message delay] > 0)
	{
		[messageAddQueue addObject:message]; 
	}
	else 
	{
		[self sendMessage : message];
	}

}
+(void)sendMessage : (MMessage*) message
{
	NSString *locationKey = [message reciever];
	[message retain];
	if([message entityType] == AnyType || [message entityType] == UnitType)
	{
		[[[units objectForKey:locationKey] object] sendMessage : message];
	}
	if([message entityType] == AnyType || [message entityType] == StructureType)
	{
		[[[structures objectForKey:locationKey] object] sendMessage : message];
	}	
	[message release];
}
+(NSMutableDictionary*) allUnits
{
	return units;
}
+(MUnit*) unmovedUnit : (MTeam*) pTeam
{
	for(NSString *unitKey in units)
	{
		MActor *actor = [units objectForKey:unitKey];
		MUnit *unit = actor.object;
		if([unit team] == pTeam)
		{
			if ([unit moves] > 0) 
			{
				return unit;
				break;
			}
		}
	}
	return nil;
}
+(MTeam*)unitTeamAt:(Vertex)pVertex
{
	MActor *actor = [units objectForKey:[MVertexUtil VertexLocationKey:pVertex]]; 
	MUnit *unit = [actor object];
	if(unit)
	{
		return [unit team];
	}
	return nil;
}
+(NSMutableDictionary*) allStructures
{
	return structures;
}
@end
