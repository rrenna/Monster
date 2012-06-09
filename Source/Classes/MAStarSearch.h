//  AStarSearch.h
//  Monster
//
//  Created by Ryan Renna on 10-05-27.

//TODO: MAKE STATIC

#import "JAPriorityQueue.h"
#import "MAction.h"
#import "MMove.h"
#import "MMap.h"
#import "MSkill.h"
#import "MEntityManager.h"
#import "MVertexUtil.h"

@interface MAStarNode : NSObject {
	Vertex location;
	float costFromStart;
	float costFromGoal;
	int depth;
	MAStarNode *parent;
}
@property (readwrite) Vertex location;
@property (readwrite) float costFromStart;
@property (readwrite) float costFromGoal;
@property (readwrite) int depth;
@property (retain,readwrite) MAStarNode *parent;
-(NSComparisonResult)compareNode:(MAStarNode*)pNode;
@end
@interface MAStarSearch : NSObject {
	//Priority Queue of search nodes
	JAPriorityQueue *open;
	//Copy of open priority queue, used for checking if objects exist
	NSMutableArray *openArray;
	//List of search nodes
	NSMutableArray *closed;
	MTeam *friendlyTeam;
	Vertex goal;
	MSkill *moveSkill;
	MSkill *finalSkill;
	MMap *matchMap;
}
-(id)init : (MMap*) pMap;
-(MAction*)AStarSearch : (Vertex)pStart : (Vertex) pGoal : (int) pLimit : (MSkill*)pMoveSkill : (MSkill*)pFinalSkill : (MTeam*)pFriendlyTeam;
-(float)PathCostEstimate : (Vertex) pStart : (Vertex) pGoal;
-(float) TraverseCost : (MAStarNode*)pFromNode : (MAStarNode*) pToNode;
-(NSArray*)getNeighbours : (MAStarNode*)node;
-(void)directionValid : (Vertex)direction : (NSMutableArray*)pNeighbours;
-(MAction*)getActionFromNode : (MAStarNode*) node;
@end
