//  MActor.h
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-08.

#import "Box2D.h"
#import "MEntity.h"
#import "MProjectile.h"

@interface MActor : NSObject 
{
	MObject *object;
	b2Body *body;
	b2BodyDef *bodyDef;
}
@property (retain,readwrite) MObject* object;
@property (assign,readwrite) b2Body* body;
@property (assign,readwrite) b2BodyDef *bodyDef;
-(id)initWithProjectile :(MProjectile*) pProjectile;
-(id)initWithEntity :(MEntity*) pEntity;
@end