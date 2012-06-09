//
//  MPersona.h
//  Monster
//
//  Created by Ryan Renna on 10-05-11.

#import "cocos2d.h"
#import "Box2D.h"
#import "MVertexUtil.h"
#import "MSkillChest.h"

typedef enum
{
	OrganizeSentience,
	MechanicalSentience
}SentienceType;

@interface MPersona : NSObject {
	NSString *name;
	NSString *spriteName;
	NSDictionary *animations;
	Vertex rangeOffset;
	int maxMoves;
	//Unit's skillChest
	MSkillChest *skillChest;
	//Bigger Units will rotate and move slower
	float weight;
	//Box2d Shape
	b2PolygonShape shape;
}
@property (retain,readonly) NSString *spriteName;
@property (retain,readonly) NSDictionary *animations;
@property (readonly) int maxMoves;
@property (retain,readonly) MSkillChest *skillChest;
@property (readonly) Vertex rangeOffset;
@property (readonly) SentienceType sentienceType;
@property (readonly) float weight;
@property (readonly) b2PolygonShape shape;

//Retieves a requested persona
+(MPersona*)getPersona : (NSString*) pName;
//Instance constructor
-(id)init : (NSString *)pName : (NSString *)pSpriteName : (SentienceType) pSentienceType  :(int)pMaxMoves : (float)pWeight : (Vertex) pRangeOffset : (NSDictionary*) pAnimations;
-(id)init:(NSString *)pName :(NSString *)pSpriteName : (SentienceType) pSentienceType :(int)pMaxMoves : (float)pWeight : (Vertex) pRangeOffset : (NSDictionary*) pAnimations : (MSkillChest*)pSkillChest;
@end
