//  MyContactListener.h
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-02.

#import "Box2D.h"
#import "MEntity.h"
#import "MUnit.h"

const int32 k_maxContactPoints = 2048;
struct ContactPoint
{
	b2Fixture* fixtureA;
	b2Fixture* fixtureB;
	b2Vec2 normal;
	b2Vec2 position;
	b2PointState state;
};

class MContactListener : public b2ContactListener
{	
public:
	/* void BeginContact(b2Contact* contact) 
	{ 
		//TODO : CLEAN UP!
		
		b2Fixture *fixtureA = contact->GetFixtureA();
		b2Fixture *fixtureB = contact->GetFixtureB();
		b2Body *bodyA = fixtureA->GetBody();
		b2Body *bodyB = fixtureB->GetBody();
		
		b2Vec2 origin; origin.x = 0; origin.y = 0;
		
		if(bodyA->GetType() == b2_staticBody)
		{
			
		}
		else 
		{
			b2Vec2 test; test.x = 0.1; test.y = 0;
			bodyA->ApplyLinearImpulse(test,origin);
		}

		if(bodyB->GetType() == b2_staticBody)
		{
			
		}
		else 
		{
			b2Vec2 test; test.x = 0.1; test.y = 0;
			bodyB->ApplyLinearImpulse(test,origin);
		}

	}
	
	/// Called when two fixtures cease to touch.
	void EndContact(b2Contact* contact) 
	{ 
		
	}*/
	
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
	{
		double damage = 0;
		b2Body *bodyA = contact->GetFixtureA()->GetBody();
		b2Body *bodyB = contact->GetFixtureB()->GetBody();
		MObject *ObjectA = (MObject*)bodyA->GetUserData();
		MObject *ObjectB = (MObject*)bodyB->GetUserData();
		MTeam *teamA = [ObjectA team];
		MTeam *teamB = [ObjectB team];
		MProjectile *projectile;
		CGPoint collisionForce; 
		if(teamB != teamA)
		{
			if([ObjectA class] == [MProjectile class])
			{
				projectile = (MProjectile*)ObjectA;
				collisionForce.x = bodyA->GetLinearVelocity().x;
				collisionForce.y = bodyA->GetLinearVelocity().y;
				damage = [projectile damage];
			}
			else if([ObjectB class] == [MProjectile class])
			{
				projectile = (MProjectile*)ObjectB;
				collisionForce.x = bodyB->GetLinearVelocity().x;
				collisionForce.y = bodyB->GetLinearVelocity().y;
				damage = [projectile damage];
			}
			[ObjectA performDamage:[NSNumber numberWithInt:damage] withForce:collisionForce];
			[ObjectB performDamage:[NSNumber numberWithInt:damage] withForce:collisionForce];	
		}
		else 
		{
				contact->SetEnabled(false);
		}
	}
	
	
	
	void Add(const b2ContactPoint* point)
	{
		//Handle add point
	}
	
	void Persist(const b2ContactPoint* point)
	{
		// handle persist point
	}
	
	void Remove(const b2ContactPoint* point)
	{
		// handle remove point
	}
	
	void Result(const b2ContactResult* point)
	{
		// handle results
	}
};