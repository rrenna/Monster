//  AStarSearch.m
//  Monster
//
//  Created by Ryan Renna on 10-05-27.

#import "MAStarSearch.h"

@implementation MAStarNode
@synthesize location;
@synthesize costFromStart;
@synthesize costFromGoal;
@synthesize depth;
@synthesize parent;
-(NSComparisonResult)compareNode:(MAStarNode*)pNode
{
	if(([self costFromStart] + [self costFromGoal]) < ([pNode costFromStart] + [pNode costFromGoal]))
	{
		return NSOrderedAscending;
	}
	else if(([self costFromStart] + [self costFromGoal]) == ([pNode costFromStart] + [pNode costFromGoal]))
	{
		return NSOrderedSame;
	}
	else 
	{
		return NSOrderedDescending;
	}
}
@end

@implementation MAStarSearch
-(id)init : (MMap*) pMap
{
	if((self = [super init]))
	{
		matchMap = pMap;
	}
	return self;
}
-(void)dealloc
{
	[super dealloc];
}
-(MAction*)AStarSearch : (Vertex)pStart : (Vertex) pGoal : (int) pLimit : (MSkill*)pMoveSkill : (MSkill*)pFinalSkill : (MTeam*)pFriendlyTeam
{
	open = [[JAPriorityQueue alloc] initWithComparator:@selector(compareNode:)];
	closed = [[NSMutableArray alloc] init];
	goal = pGoal;
	moveSkill = pMoveSkill;
	finalSkill = pFinalSkill;
	friendlyTeam = pFriendlyTeam;
	MAStarNode *startNode = [[MAStarNode alloc] init];
	startNode.location = pStart;
	startNode.costFromStart = 0;
	startNode.costFromGoal = [self PathCostEstimate: pStart : pGoal];
	startNode.depth = 0;
	//Add initial start node
	[open addObject:startNode];
	[openArray addObject:startNode];	
	
	while([open count] > 0)
	{
		MAStarNode *node = [open nextObject]; 
		//Remove object from mirror list
		[openArray removeObject:node];
		if([MVertexUtil VertexEqual:node.location :pGoal])
		{
			//Construct Action object, filled with moves, return
			return [self getActionFromNode: node];
		}
		else 
		{
			[closed addObject:node];
			//Foreach Neighbour of Node
			for(MAStarNode *newNode in [self getNeighbours : node])
			{
				float newCost = node.costFromStart + [self TraverseCost:node :newNode];
				BOOL containedInOpen = NO;
				int indexInClosed = -1;
				BOOL containedInClosed = NO;
				MAStarNode *openNodeRef = nil;
				for(MAStarNode *Onode in openArray)
				{
					if([MVertexUtil VertexEqual:Onode.location :newNode.location])
					{
						containedInOpen = YES;
						openNodeRef = Onode;
						break;
					}
				}
				for(MAStarNode *Cnode in closed)
				{
					indexInClosed++;
					if([MVertexUtil VertexEqual:Cnode.location :newNode.location])
					{
						containedInClosed = YES;
						break;
					}
				}
				if((containedInOpen || containedInClosed) && (newNode.costFromStart <= newCost))
				{
					continue;
				}
				else 
				{
					if(node.depth + 1 > pLimit)
					{
						continue;
					}
					//Store the new or improved information
					newNode.parent = node;
					newNode.costFromStart = newCost;
					newNode.costFromGoal = [self PathCostEstimate:newNode.location :pGoal];
					newNode.depth = node.depth + 1;
					
					if(containedInClosed)
					{
						[closed removeObjectAtIndex:indexInClosed];
					}
					if(containedInOpen)
					{
						//adjust northNode location in open
						[open removeObject:openNodeRef];
						[open addObject:newNode];
					}
					else
					{
						[open addObject:newNode];
					}
					//new node has been updated or inserted
				}
			}
		}
		[closed addObject:node];
	}
	[open release];
	[openArray release];
	[closed release];
	[startNode release];
	return nil;							  
}
-(float)PathCostEstimate : (Vertex)pStart : (Vertex) pGoal
{
	//Heuristic distance from start to finish
	return [MVertexUtil VertexDistance:pStart :pGoal];	
}
-(float) TraverseCost : (MAStarNode*)pFromNode : (MAStarNode*) pToNode
{
	//TODO: Implement modifiers
	//Discourage walking over certain areas
	
	//Was replaced with NO walking over water
	//if(map.landGrid.tiles[[pToNode location].x][[pToNode location].y ] == 5)
	//{
		//Discourage walking through water
	//	return 10;	
	//}
	return 1;	
}
-(NSArray*)getNeighbours : (MAStarNode*)node
{
	NSMutableArray *neighbours = [[NSMutableArray alloc] init];
	Vertex north; north.x = node.location.x; north.y = node.location.y + 1;
	Vertex east; east.x = node.location.x + 1; east.y = node.location.y;
	Vertex west; west.x = node.location.x - 1; west.y = node.location.y;
	Vertex south; south.x = node.location.x; south.y = node.location.y - 1;
	[self directionValid : north : neighbours];
	[self directionValid : east : neighbours];
	[self directionValid : west : neighbours];
	[self directionValid : south : neighbours];
	return neighbours;
}
-(void)directionValid : (Vertex)direction : (NSMutableArray*)pNeighbours
{	
	if([matchMap isValidPosition:direction])
	{
		if([MVertexUtil VertexEqual:direction :goal])
		{
			if([finalSkill type] == MovementSkill)
			{
				if([matchMap isWalkable:direction])
				{
					//If no unit at position
					if(![MEntityManager unitTeamAt:direction])
					{
						MAStarNode *directionNode = [[[MAStarNode alloc] init] autorelease];
						directionNode.location = direction;
						[pNeighbours addObject:directionNode];
					}
				}
			}
			else if([finalSkill type] == AttackSkill)
			{
				MTeam *teamOfUnit = [MEntityManager unitTeamAt:direction];
				//And is enemy unit
				if(teamOfUnit != friendlyTeam)
				{
					MAStarNode *directionNode = [[[MAStarNode alloc] init] autorelease];
					directionNode.location = direction;
					[pNeighbours addObject:directionNode];
				}
			}		
		}
		else 
		{
			if([matchMap isWalkable:direction])
			{
				//If no unit at position
				if(![MEntityManager unitTeamAt:direction])
				{
					MAStarNode *directionNode = [[[MAStarNode alloc] init] autorelease];
					directionNode.location = direction;
					[pNeighbours addObject:directionNode];
				}
			}
		}
	}
}
-(MAction*)getActionFromNode : (MAStarNode*) node
{
	NSMutableArray *moves = [[NSMutableArray alloc] init];
	MAStarNode *currentNode = node;
	BOOL first = YES;
	while(true)
	{
		if(first)
		{
			MMove *move = [[MMove alloc] init: currentNode.parent.location : currentNode.location: finalSkill];
			[moves insertObject:move atIndex:0];
			first = NO;
		}
		else 
		{
			MMove *move = [[MMove alloc] init: currentNode.parent.location : currentNode.location: moveSkill];
			[moves insertObject:move atIndex:0];
		}
		currentNode = currentNode.parent;
		if(currentNode.parent == nil)
		{
			break;
		}
	}
	
	
	//[self getParentMoveFromNode: node : moves];
	MAction *action = [[MAction alloc] initWithMoveArray:moves];
	
	[moves release];
	return action;
}
@end
