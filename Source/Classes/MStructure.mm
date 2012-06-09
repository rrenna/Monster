//  Structure.m
//  Monster
//
//  Created by Ryan Renna on 10-05-25.

#import "MStructure.h"

@implementation MStructure
@synthesize crushable;

-(id)initStructure : (NSString*) pName : (Vertex) pPosition : (NSString*) pSpriteName : (BOOL) pCrushable : (int) damageStages
{
	if(self == [super initWithName:pName andPosition:pPosition andTeam:nil])
	{
		sprite = [CCSprite spriteWithFile:pSpriteName];
		damageAnimation = [[[CCAnimation alloc] initWithName:@"damaged" delay:1/4.0] retain];
		//Populate damage animation
		for(int i = 1; i <= damageStages; i++)
		{
			NSString *frameName = [NSString stringWithFormat:@"%@%@%i.png",name,@"_damage",i];
			[damageAnimation addFrameWithFilename:frameName];
		}
		crushable = pCrushable;
		[self update];
	}
	return self;
}
-(void) dealloc
{
	[damageAnimation release];
	[super dealloc];
}
-(void)performDamage : (NSNumber*) pNumber
{
	[super performDamage:pNumber];
	if(health <= 0)
	{
		[self performSpriteChange:@"House1_damage3.png"];
		//[sprite initWithFile:@"House1_damage3.png"];
		//[self update];
		//id action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:damageAnimation] times:1 ];
		//[sprite runAction:action];
		
		//Message *spriteChangeMessage = [[Message alloc] initWithSender:[self locationKey] andReciever:[self locationKey] andEntityType:StructureType andMessageType:SpriteChangeMessage andValue:@"" andDelay:2500];
		//[EntityManager queueMessage:spriteChangeMessage];
	}	
}

@end
