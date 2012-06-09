//  MProjectileManager.mm
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-02.

#import "MProjectileManager.h"

static NSMutableDictionary *projectiles = nil;
static UnitLayer *projectileLayer= nil;
static NSMutableArray *cleanupProjectileQueue = nil;
static b2World *world = nil;
static int projectileCounter;

@implementation MProjectileManager
#define PTM_RATIO 32
+(void)initWithLayer : (UnitLayer*) pProjectileLayer
{
	if(!projectileLayer)
	{
		projectiles = [[NSMutableDictionary alloc] init];
		projectileLayer = pProjectileLayer;
		cleanupProjectileQueue = [[NSMutableArray alloc] init];
		world = [MEntityManager getWorld];
		projectileCounter = 0;
	}
}
+(void)cleanUpProjectileQueue
{
	for(MActor *actor in cleanupProjectileQueue)
	{		
		[projectileLayer removeChild:[[actor object] sprite] cleanup:YES];
		b2World *world = [MEntityManager getWorld];
		world->DestroyBody(actor.body);
	}
	[cleanupProjectileQueue removeAllObjects];
}		
+(void)update
{
	//Clean up removed projectiles
	[self cleanUpProjectileQueue];
	
}
+(BOOL)isProcessing
{
	return (projectileCounter > 0);
}
+(UnitLayer*)getUnitLayer
{
	return projectileLayer;
}
+(NSString*)getNextProjectileName
{
	/*
	if(projectileCounter == MAXPROJECTILES)
	{
		projectileCounter = 1;
	}
	else {
		projectileCounter++;
	}
	return [[NSNumber numberWithInt:projectileCounter] stringValue];
	 */
	return [[NSProcessInfo processInfo] globallyUniqueString];
}
+(void)add : (MProjectile*) pProjectile
{
	//Set the manager to be processing atleast one projectile
	projectileCounter++;
	
	[projectileLayer addChild:pProjectile.sprite z:0];
	MActor *actor = [[MActor alloc] initWithProjectile: pProjectile];
	[actor bodyDef]->userData = [actor object];
	[actor bodyDef]->type = b2_dynamicBody;
	[actor bodyDef]->position.Set([pProjectile sprite].position.x/PTM_RATIO, [pProjectile sprite].position.y/PTM_RATIO);
	actor.body = world->CreateBody([actor bodyDef]);
	// Define another box shape for our dynamic body.
	b2FixtureDef fixtureDef;
	b2CircleShape circle;
	circle.m_radius = 7.0/PTM_RATIO;
	
	//b2PolygonShape dynamicBox;
	//dynamicBox.SetAsBox(.25f, .25f);
	fixtureDef.shape = &circle;	
	fixtureDef.density = 0.3f;
	fixtureDef.friction = 0.1f;
	fixtureDef.restitution = 1.0f;
	[actor body]->CreateFixture(&fixtureDef);
	
	NSString *ProjectileKey = [pProjectile key];
	//Add to projectile dictionary
	for(NSString* key in [projectiles allKeys])
	{
		if([key isEqualToString:ProjectileKey])
		{
			[self remove:[[projectiles objectForKey:key] object]];
			break;
		}
	}
	[projectiles setObject:actor forKey:ProjectileKey];
	b2Vec2 position; position.x = pProjectile.position.x; position.y = pProjectile.position.y;
	b2Vec2 force; force.x = pProjectile.force.x; force.y = pProjectile.force.y;
	actor.body->ApplyLinearImpulse(force,position);	
}

+(void)remove: (MProjectile*) pProjectile
{
	//reduces the projectile count by 1
	projectileCounter--;
	
	NSString *EntityKey = [pProjectile key];
	MActor *actor = [projectiles objectForKey:EntityKey];
	MProjectile *projectile  = [actor object];
	//Add to projectile dictionary 
	if(projectile.clean == NO)
	{
			[cleanupProjectileQueue addObject:actor];
			[projectiles removeObjectForKey:EntityKey];
	}
	[projectile setCleaned];
}

@end
