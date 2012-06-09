//  Structure.h
//  Monster
//
//  Created by Ryan Renna on 10-05-25.

#import "MEntity.h"
#import "MEntityManager.h"

@interface MStructure : MEntity 
{
	CCAnimation *damageAnimation;
	BOOL crushable;
}

@property (readonly) BOOL crushable;
-(id)initStructure : (NSString*) pName : (Vertex) pPosition : (NSString*) pSpriteName : (BOOL) pCrushable : (int) damageStages;
@end
