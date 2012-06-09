//
//  Map.m
//  Monster
//
//  Created by Ryan Renna on 10-05-08.

#import "MMap.h"

@implementation MMap
@synthesize  width;
@synthesize height;
@synthesize skyGrid;
@synthesize structureGrid;
@synthesize tileMap;
-(id)init
{
	if( (self=[super init] )) 
	{
		tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"Prototype.tmx"];
		landLayer = [tileMap layerNamed:@"Land"];
		[[landLayer texture] setAliasTexParameters];
		width = MAPXSIZE;
		height = MAPYSIZE;
		grid empty = 
		{
			{	
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0}
			}
		};
		grid structure = 
		{
			{	
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,1,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,1,1,1,0,0,0,0,0,0,0,0},
				{0,0,1,1,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,0,0,0,0}
			}
		};	
		
		 skyGrid = empty;
		 structureGrid = structure;
	
	}
	return self;
	
}
-(BOOL)isValidPosition:(Vertex)position
{
	if(position.x < 0)
	{
		return false;
	}
	if(position.x >= width)
	{
		return false;	
	}
	if(position.y < 0)
	{
		return false;
	}
	if(position.y >= height)
	{
		return false;	
	}
	return true;
}

-(BOOL)isWalkable : (Vertex) pPosition
{	
	CGPoint pointPosition; 
	pointPosition.x= pPosition.x;
	pointPosition.y = 11 - pPosition.y;
	
	int GID = [landLayer tileGIDAt:pointPosition];
	NSDictionary *tileProperties = [tileMap propertiesForGID:GID]; 
	NSString *walkableValue = [tileProperties objectForKey:@"Walkable"];
	if(walkableValue && ![walkableValue isEqualToString:@"True"])
	{
		return NO;
	}
	return YES; 
}
@end
