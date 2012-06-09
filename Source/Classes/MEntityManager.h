//  EntityManager.h
//  Monster
//
//  Created by Ryan Renna on 10-05-25.

#import "MActor.h"
#import "MProjectileManager.h"
#import "MEntity.h"
#import "MVertexUtil.h"
#import "MMessage.h"
#import "MTeam.h"
#import "MUnit.h"
#import "LevelScene.h"
#import "MIManager.h"

@class MUnit;
@class UnitLayer;

@interface MEntityManager : NSObject <MIManager> 
{
}
+(void)initWithLayer : (UnitLayer*) pEntityLayer;
+(BOOL)isProcessing;
+(b2World*)getWorld;
+(NSMutableArray*)getCleanUpEntityQueue;
+(void)cleanUpEntityQueue;
+(void) setFocusEntity : (MEntity*) pEntity;
+(MEntity*) getFocusEntity;
+(void) clearFocusEntity;
+(void)add : (MEntity*) pEntity : (EntityType) pType;
+(void)refreshKey :(MEntity*)pEntity:(EntityType)pType:(Vertex)pPosition;
+(void)remove: (MEntity*) pEntity : (EntityType) pType;
+(void)remove: (MEntity*) pEntity : (EntityType) pType Cleanup:(BOOL)pCleanup;
+(void)queueMessage : (MMessage*) message;
+(void)sendMessage : (MMessage*) message;
+(NSMutableDictionary*) allUnits;
+(MTeam*)unitTeamAt:(Vertex)pVertex;
+(MUnit*) unmovedUnit : (MTeam*) pTeam;
+(NSMutableDictionary*) allStructures;
@end
