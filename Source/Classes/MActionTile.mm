//  MActionTile.m
//  Monster
//
//  Created by Ryan Renna on 10-05-17.

#import "MActionTile.h"

//Sprites
static CCSpriteBatchNode *movementOverlaySheet = nil;
static CCSpriteFrame *movementFrame;
static CCSpriteFrame *movementSelectedFrame;
static CCSpriteFrame *attackFrame;
static CCSpriteFrame *attackSelectedFrame;

@implementation MActionTile
@synthesize sprite;
@synthesize actions;
+(void)initialize
{
	if(!movementOverlaySheet)
	{
		movementFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Movement.png"];
		movementSelectedFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MovementSelected.png"];
		attackFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Attack.png"];
		attackSelectedFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"AttackSelected.png"];
	}
}
-(id)init
{
	if( (self=[super init] )) 
	{
		actions = [[NSMutableArray alloc]init];	
	}
	return self;
}
-(id)initWithType :(ActionType) pType
{
	if(self = [self init])
	{
		[self init];
		type = pType;
		selected = NO;
		sprite = [CCSprite spriteWithSpriteFrame:[self getFrame]];
	}
	return self;
}
- (void) dealloc
{
	[sprite release];
	[actions release];
	[super dealloc];
}
-(void)refreshSprite
{
	[sprite setDisplayFrame:[self getFrame]];
}
-(void)changeType :(ActionType) pType
{
	type = pType;
	[self refreshSprite];
}
-(void)setSelected : (BOOL) pSelected
{
	selected = pSelected;
	[self refreshSprite];
}
-(CCSpriteFrame*)getFrame
{
	if(type == MovementAction)
	{
		if(selected)
		{
			return movementSelectedFrame;
		}
		else 
		{
			return movementFrame;
		}
	}
	else if(type == MeleeAttackAction)
	{
		if(selected)
		{
			return attackSelectedFrame;
		}
		else 
		{
			return attackFrame;
		}
	}
	else 
	{
		return nil;
	}

}
-(CGRect) rect {
//TODO: Make property
	ccDeviceOrientation orientation = [[CCDirector sharedDirector] deviceOrientation ];
	CGPoint position;
	if(orientation == kCCDeviceOrientationLandscapeLeft)
	{
		CGPoint p = { [sprite position].y,[sprite position].x}; 
		position = [[CCDirector sharedDirector]convertToUI:p];	
	}
	else {
		position = [[CCDirector sharedDirector]convertToUI:[sprite position]];
	}
	float w = [sprite contentSize].width;
	float h = [sprite contentSize].height;
	CGPoint point = CGPointMake(position.x - (w/2), position.y - (h/2));
	
	return CGRectMake(point.x,point.y,w,h);
}
@end
