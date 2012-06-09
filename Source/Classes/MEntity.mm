//
//  Entity.m
//  Monster
//
//  Created by Ryan Renna on 10-05-08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MEntity.h"

@implementation MEntity
#define PTM_RATIO 32
@synthesize team;
@synthesize activityState;
@synthesize health;

-(id) initWithName: (NSString*) pName andPosition: (Vertex) pPosition andTeam:(MTeam*)pTeam
{	
	if( (self=[super initWithName:pName] )) {
		team = pTeam;
		position = pPosition;
		rotation = 0;
		health = 100;
	}
	return self;
}
- (void) dealloc
{
	[super dealloc];
}
-(NSString*) key
{
	return [NSString stringWithFormat:@"%i-%i",position.x,position.y];	
}
-(void) update
{
	sprite.position = ccp((position.x * TILEXSIZE) + 32,(position.y * TILEYSIZE) + 32);
	sprite.rotation = rotation;		
}
-(CGRect) rect {
	//TODO: Make property
	ccDeviceOrientation orientation = [[CCDirector sharedDirector] deviceOrientation ];
	CGPoint pos;
	if(orientation == kCCDeviceOrientationLandscapeLeft)
	{
		CGPoint p = { [sprite position].y,[sprite position].x}; 
		pos = [[CCDirector sharedDirector]convertToUI:p];	
	}
	else {
		pos = [[CCDirector sharedDirector]convertToUI:[sprite position]];
	}
	float w = [sprite contentSize].width;
	float h = [sprite contentSize].height;
	CGPoint point = CGPointMake(pos.x - (w/2), pos.y - (h/2));
	
	return CGRectMake(point.x,point.y,w,h);
}
-(void)sendMessage : (MMessage*) message
{
	switch([message messageType])
	{
		case UpdateMessage:
		{
			if(message.value)
			{
				[self setActivityState:message.value];
			}
			[self update];
			break;
		}
		case ActivityStateChangeMessage:
		{
			[self setActivityState:message.value];
			break;
		}
		case TransformationMessage:
			[self performTransformation:message.value];
			break;
		case DamageMessage:
		{
			//CGPoint force; force.x = [[[message reciever] position x];
			[self performDamage: [message value] withForce: ccp(1,0)];
			break;
		}
		case SpriteChangeMessage:
		{
			[self performSpriteChange:[message value]];
			break;
		}
		case FireProjectileMessage:
		{
			[self fireProjectile:[message value]];
			break;
		}
		default:
			break;
	}
}

-(void)performTransformation : (CCAction*) pAction
{
	[sprite runAction:pAction]; 
}

-(void)performDamage : (NSNumber*) pDamage withForce: (CGPoint) pForce
{	
	[self performShakeWithForce : pForce];
	health -= [pDamage intValue];	
}

-(void)performSpriteChange : (NSString*) pSpriteName
{
	[sprite initWithFile:pSpriteName]; 
	[self update];
}
-(void)performShake
{
	CGPoint tempV; tempV.x = 0; tempV.y = 0;
	[self performShakeWithForce : tempV];
}
-(void)performShakeWithForce : (CGPoint) pForce
{
	CCMoveBy *moveAway = [CCMoveBy actionWithDuration:0.01 position:ccp(pForce.x*2,pForce.y*2)];
	CCMoveBy *moveBack = [CCMoveBy actionWithDuration:0.075 position:ccp(-pForce.x*3,-pForce.y*3)];
	CCMoveBy *moveExact = [CCMoveBy actionWithDuration:0.05 position:ccp(pForce.x,pForce.y)];
	CCSequence *shake = [CCSequence actions: moveAway, moveBack,moveExact, nil];
	[sprite runAction: shake];
}
@end
