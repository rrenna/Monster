//
//  MActor.m
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-08.

#import "MActor.h"

@implementation MActor
@synthesize object;
@synthesize body;
@synthesize bodyDef;
-(id)initWithEntity :(MEntity*) pEntity
{
	if((self = [super init]))
	{
		object = [pEntity retain];
		bodyDef = new b2BodyDef;
	}
	return self;
}
-(id)initWithProjectile :(MProjectile*) pProjectile
{
	if((self = [super init]))
	{
		object = [pProjectile retain];
		bodyDef = new b2BodyDef;
	}
	return self;
}
-(void)dealloc
{
	[object release];
	[super dealloc];
}
@end
