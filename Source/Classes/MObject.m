//
//  MObject.m
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MObject.h"

@implementation MObject
@synthesize position;
@synthesize name;
@synthesize sprite;
@synthesize rotation;
@synthesize clean;
-(id) initWithName: (NSString*) pName
{	
	if( (self=[super init] )) {
		name = pName;
	}
	return self;
}
-(void)dealloc
{
	[name release];
	[sprite release];
	[super dealloc];
}
-(NSString*) key
{
	return name;	
}
-(void)setCleaned
{
	clean = YES;
}
-(void)kill
{
}
-(void)performDamage : (NSNumber*) pDamage withForce: (CGPoint) pForce
{	
	[self kill];
}
@end
