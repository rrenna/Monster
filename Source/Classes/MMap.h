//
//  Map.h
//  Monster
//
//  Created by Ryan on 10-05-08.
//
#import "MSettings.h"
#import "MVertexUtil.h"

typedef struct
{
	int tiles[12][12];	
}grid;

@interface MMap : NSObject {
	int width;
	int height;
	grid skyGrid;
	grid structureGrid;
	CCTMXTiledMap *tileMap;
	CCTMXLayer *landLayer;
}
@property int width;
@property int height;
@property grid skyGrid;
@property grid structureGrid;
@property (retain,readonly) CCTMXTiledMap *tileMap;
-(id)init;
-(BOOL)isValidPosition:(Vertex)position;
-(BOOL)isWalkable : (Vertex) pPosition;
@end
